library(tidyverse)
library(caret)
library(data.table)
library(dplyr)
library(ROSE)
library(ranger)
library(ggplot2)
library(plotROC)
library(ROCR)

n <- 7978

# Read data
data_table <- fread("./data/data_table.csv")
# Undersampling
data <- ovun.sample(class ~ ., data = data_table, p = 0.5, seed = 123, method = "under")$data
# Sample data
#set.seed(123)
idx <- sample(nrow(data), n)
data <- data[idx, ]
# Class variable should be factor
data$class <- as.factor(data$class)
levels(data$class) <- make.names(levels(data$class))
# Scale data
data <- data.frame(scale(data[, 3:14]), class = data$class)

set.seed(123)
idx <- createDataPartition(data$class, p = 0.66, list = FALSE)
train <- data[idx, ]
test <- data[-idx, ]

fit_control <- trainControl(method = "cv", number = 10, classProbs = TRUE, summaryFunction = twoClassSummary, allowParallel = TRUE)
x <- train[, 1:12]
y <- train[, 13]
fit_rf <- train(x = x, y = y, method = "ranger", trControl = fit_control, verbose = FALSE, metric = "ROC", importance = "impurity")
fit_gb <- train(x = x, y = y, method = "gbm", trControl = fit_control, verbose = FALSE, metric = "ROC")
phat_rf <- predict(fit_rf, newdata = test, type = "prob")[, "X1"]
phat_gb <- predict(fit_gb, newdata = test, type = "prob")[, "X1"]
df <- data.frame(prob_rf = phat_rf, prob_gb = phat_gb, class = as.numeric(gsub("X", "", test$class)))
write_tsv(x = df, path = "./data/probs.tsv")
saveRDS(fit_rf, "./data/fit_rf.rds")
saveRDS(fit_gb, "./data/fit_gb.rds")

cm_rf <- confusionMatrix(data = ifelse(phat_rf >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_gb <- confusionMatrix(data = ifelse(phat_gb >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")

auc_rf <- unlist(slot(performance(prediction(phat_rf, test$class), "auc"), "y.values"))
auc_gb <- unlist(slot(performance(prediction(phat_gb, test$class), "auc"), "y.values"))