library(caret)
library(data.table)
library(ROSE)
library(ranger)
library(plotROC)
library(ROCR)
library(PRROC)
library(knitr)
library(tidyverse)

# Function for area under the Precision-Recall curve
calc_auprc <- function(tbl, var) {
  fg <- tbl %>% filter(class == 1) %>% select(var) %>% pull
  bg <- tbl %>% filter(class == 0) %>% select(var) %>% pull
  pr <- pr.curve(scores.class0 = fg, scores.class1 = bg)
  return(pr$auc.davis.goadrich)
}

# Read data
data_table <- fread("./data/data_table.csv")
# Number of rows to sample
n <- ceiling(0.1 * nrow(data_table))
# Proportion of class "1"
prop <- prop.table(table(data_table$class))[2]
# Sampling
data <- ovun.sample(class ~ ., data = data_table, N = n, p = prop, seed = 123)$data
# Repair data
data$class <- as.factor(data$class)
levels(data$class) <- make.names(levels(data$class))
data <- data.frame(data[, 3:14], class = data$class)

# Create train and test partition
set.seed(123)
idx <- createDataPartition(data$class, p = 0.66, list = FALSE)
train <- data[idx, ]
test <- data[-idx, ]

# Learning
fit_control <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary, allowParallel = TRUE, savePredictions = TRUE)
x <- train[, 1:12]
y <- train[, 13]
fit_rf <- train(x = x, y = y, method = "ranger", trControl = fit_control, verbose = FALSE, metric = "ROC", importance = "impurity", preProcess = c("center", "scale"))
fit_gb <- train(x = x, y = y, method = "gbm", trControl = fit_control, verbose = FALSE, metric = "ROC", preProcess = c("center", "scale"))
fit_dt <- train(x = x, y = y, method = "rpart", trControl = fit_control, metric = "ROC", preProcess = c("center", "scale"))
fit_knn <- train(x = x, y = y, method = "knn", trControl = fit_control, metric = "ROC", preProcess = c("center", "scale"))
fit_svm <- train(x = x, y = y, method = "svmLinear2", trControl = fit_control, metric = "ROC", preProcess = c("center", "scale"))

# Store learning models
saveRDS(fit_rf, file = "./data/model_rf.rda")
saveRDS(fit_gb, file = "./data/model_gb.rda")
saveRDS(fit_dt, file = "./data/model_dt.rda")
saveRDS(fit_knn, file = "./data/model_knn.rda")
saveRDS(fit_svm, file = "./data/model_svm.rda")

# Evaluation on training data
phat_rf <- predict(fit_rf, type = "prob")[, "X1"]
phat_gb <- predict(fit_gb, type = "prob")[, "X1"]
phat_dt <- predict(fit_dt, type = "prob")[, "X1"]
phat_knn <- predict(fit_knn, type = "prob")[, "X1"]
phat_svm <- predict(fit_svm, type = "prob")[, "X1"]
df <- data.frame(prob_rf = phat_rf, prob_gb = phat_gb, prob_dt = phat_dt, prob_knn = phat_knn, prob_svm = phat_svm, class = as.numeric(gsub("X", "", train$class)))

# Confusion matrices
cm_rf <- confusionMatrix(data = ifelse(phat_rf >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
cm_gb <- confusionMatrix(data = ifelse(phat_gb >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
cm_dt <- confusionMatrix(data = ifelse(phat_dt >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
cm_knn <- confusionMatrix(data = ifelse(phat_knn >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
cm_svm <- confusionMatrix(data = ifelse(phat_svm >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")

# Area under the ROC curve
auc_rf <- unlist(slot(performance(prediction(phat_rf, train$class), "auc"), "y.values"))
auc_gb <- unlist(slot(performance(prediction(phat_gb, train$class), "auc"), "y.values"))
auc_dt <- unlist(slot(performance(prediction(phat_dt, train$class), "auc"), "y.values"))
auc_knn <- unlist(slot(performance(prediction(phat_knn, train$class), "auc"), "y.values"))
auc_svm <- unlist(slot(performance(prediction(phat_svm, train$class), "auc"), "y.values"))
auc <- c(auc_rf, auc_gb, auc_dt, auc_knn, auc_svm)

# Area under the Precision-Recall curve
aupr_rf <- calc_auprc(tbl = df, var = "prob_rf")
aupr_gb <- calc_auprc(tbl = df, var = "prob_gb")
aupr_dt <- calc_auprc(tbl = df, var = "prob_dt")
aupr_knn <- calc_auprc(tbl = df, var = "prob_knn")
aupr_svm <- calc_auprc(tbl = df, var = "prob_svm")
aupr <- c(aupr_rf, aupr_gb, aupr_dt, aupr_knn, aupr_svm)

# Precision
prec_rf <- precision(cm_dt$table, relevant = "1")
prec_gb <- precision(cm_gb$table, relevant = "1")
prec_dt <- precision(cm_dt$table, relevant = "1")
prec_knn <- precision(cm_knn$table, relevant = "1")
prec_svm <- precision(cm_svm$table, relevant = "1")
prec <- c(prec_rf, prec_gb, prec_dt, prec_knn, prec_svm)

# Recall
rec_rf <- recall(cm_dt$table, relevant = "1")
rec_gb <- recall(cm_gb$table, relevant = "1")
rec_dt <- recall(cm_dt$table, relevant = "1")
rec_knn <- recall(cm_knn$table, relevant = "1")
rec_svm <- recall(cm_svm$table, relevant = "1")
rec <- c(rec_rf, rec_gb, rec_dt, rec_knn, rec_svm)

# F-measure
f_rf <- F_meas(cm_dt$table, relevant = "1")
f_gb <- F_meas(cm_gb$table, relevant = "1")
f_dt <- F_meas(cm_dt$table, relevant = "1")
f_knn <- F_meas(cm_knn$table, relevant = "1")
f_svm <- F_meas(cm_svm$table, relevant = "1")
f_meas <- c(f_rf, f_gb, f_dt, f_knn, f_svm)

# Export results
meas <- bind_cols(Precision = prec, Recall = rec, F1 = f_meas, AUC = auc, AUPR = aupr)
res <- kable(meas, digits = 2, format = "markdown")
sink("./data/learning-results-train.md", type = "output")
print(res)
sink()

# Evaluation on test data
phat_rf <- predict(fit_rf, newdata = test, type = "prob")[, "X1"]
phat_gb <- predict(fit_gb, newdata = test, type = "prob")[, "X1"]
phat_dt <- predict(fit_dt, newdata = test, type = "prob")[, "X1"]
phat_knn <- predict(fit_knn, newdata = test, type = "prob")[, "X1"]
phat_svm <- predict(fit_svm, newdata = test, type = "prob")[, "X1"]
df <- data.frame(prob_rf = phat_rf, prob_gb = phat_gb, prob_dt = phat_dt, prob_knn = phat_knn, prob_svm = phat_svm, class = as.numeric(gsub("X", "", test$class)))

# Confusion matrices
cm_rf <- confusionMatrix(data = ifelse(phat_rf >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_gb <- confusionMatrix(data = ifelse(phat_gb >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_dt <- confusionMatrix(data = ifelse(phat_dt >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_knn <- confusionMatrix(data = ifelse(phat_knn >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_svm <- confusionMatrix(data = ifelse(phat_svm >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")

# Area under the ROC curve
auc_rf <- unlist(slot(performance(prediction(phat_rf, test$class), "auc"), "y.values"))
auc_gb <- unlist(slot(performance(prediction(phat_gb, test$class), "auc"), "y.values"))
auc_dt <- unlist(slot(performance(prediction(phat_dt, test$class), "auc"), "y.values"))
auc_knn <- unlist(slot(performance(prediction(phat_knn, test$class), "auc"), "y.values"))
auc_svm <- unlist(slot(performance(prediction(phat_svm, test$class), "auc"), "y.values"))
auc <- c(auc_rf, auc_gb, auc_dt, auc_knn, auc_svm)

# Area under the Precision-Recall curve
aupr_rf <- calc_auprc(tbl = df, var = "prob_rf")
aupr_gb <- calc_auprc(tbl = df, var = "prob_gb")
aupr_dt <- calc_auprc(tbl = df, var = "prob_dt")
aupr_knn <- calc_auprc(tbl = df, var = "prob_knn")
aupr_svm <- calc_auprc(tbl = df, var = "prob_svm")
aupr <- c(aupr_rf, aupr_gb, aupr_dt, aupr_knn, aupr_svm)

# Precision
prec_rf <- precision(cm_dt$table, relevant = "1")
prec_gb <- precision(cm_gb$table, relevant = "1")
prec_dt <- precision(cm_dt$table, relevant = "1")
prec_knn <- precision(cm_knn$table, relevant = "1")
prec_svm <- precision(cm_svm$table, relevant = "1")
prec <- c(prec_rf, prec_gb, prec_dt, prec_knn, prec_svm)

# Recall
rec_rf <- recall(cm_dt$table, relevant = "1")
rec_gb <- recall(cm_gb$table, relevant = "1")
rec_dt <- recall(cm_dt$table, relevant = "1")
rec_knn <- recall(cm_knn$table, relevant = "1")
rec_svm <- recall(cm_svm$table, relevant = "1")
rec <- c(rec_rf, rec_gb, rec_dt, rec_knn, rec_svm)

# F-measure
f_rf <- F_meas(cm_dt$table, relevant = "1")
f_gb <- F_meas(cm_gb$table, relevant = "1")
f_dt <- F_meas(cm_dt$table, relevant = "1")
f_knn <- F_meas(cm_knn$table, relevant = "1")
f_svm <- F_meas(cm_svm$table, relevant = "1")
f_meas <- c(f_rf, f_gb, f_dt, f_knn, f_svm)

# Export results
meas <- bind_cols(Precision = prec, Recall = rec, F1 = f_meas, AUC = auc, AUPR = aupr)
res <- kable(meas, digits = 2, format = "markdown")
sink("./data/learning-results-test.md", type = "output")
print(res)
sink()