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

FNrate <- function(tab) {
  res <- (tab[2,1]) / ((tab[1,1]) + (tab[2,1]))
  return(res)
}

FPrate <- function(tab) {
  res <- (tab[1,2]) / ((tab[1,2]) + (tab[2,2]))
  return(res)
}

TNrate <- function(tab) {
  res <- (tab[2,2]) / ((tab[1,2]) + (tab[2,2]))
  return(res)
}

TPrate <- function(tab) {
  res <- (tab[1,1]) / ((tab[1,1]) + (tab[2,1]))
  return(res)
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
tbl_data <- scale(data %>% select(-class)) %>% as.data.frame()
tbl_data$class <- data$class

# Create train and test partition
set.seed(123)
idx <- createDataPartition(tbl_data$class, p = 0.66, list = FALSE)
train <- tbl_data[idx, ]
test <- tbl_data[-idx, ]

# Combine features into mean feature
train_combined <- apply(X = train %>% select(-class), MARGIN = 1, FUN = mean)
test_combined <- apply(X = test %>% select(-class), MARGIN = 1, FUN = mean)

threshold <- quantile(train_combined, 0.90)
cm_train_combined <- confusionMatrix(data = ifelse(train_combined >= threshold, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
cm_test_combined <- confusionMatrix(data = ifelse(test_combined >= threshold, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")

auc_train_combined <- unlist(slot(performance(prediction(train_combined, train$class), "auc"), "y.values"))
df <- data.frame(prob = train_combined, class = as.numeric(gsub("X", "", train$class)))
aupr_train_combined <- calc_auprc(tbl = df, var = "prob")
prec_train_combined <- precision(cm_train_combined$table, relevant = "1")
rec_train_combined <- recall(cm_train_combined$table, relevant = "1")
f_train_combined <- F_meas(cm_train_combined$table, relevant = "1")

auc_test_combined <- unlist(slot(performance(prediction(test_combined, test$class), "auc"), "y.values"))
df <- data.frame(prob = test_combined, class = as.numeric(gsub("X", "", test$class)))
aupr_test_combined <- calc_auprc(tbl = df, var = "prob")
prec_test_combined <- precision(cm_test_combined$table, relevant = "1")
rec_test_combined <- recall(cm_test_combined$table, relevant = "1")
f_test_combined <- F_meas(cm_test_combined$table, relevant = "1")


tbl <- cm_test_combined$table

round(FNrate(tbl), 2)

round(FPrate(tbl), 2)

round(TNrate(tbl), 2)

round(TPrate(tbl), 2)








