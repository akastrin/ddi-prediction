library(caret)
library(data.table)
library(ROSE)
library(ranger)
library(plotROC)
library(ROCR)
library(PRROC)
library(knitr)
library(tidyverse)

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

# Create train and test partition
set.seed(123)
idx <- createDataPartition(data$class, p = 0.66, list = FALSE)
train <- data[idx, ]
test <- data[-idx, ]

fit_rf <- readRDS("./data/model_rf.rda")
fit_gb <- readRDS("./data/model_gb.rda")
fit_dt <- readRDS("./data/model_dt.rda")
fit_knn <- readRDS("./data/model_knn.rda")
fit_svm <- readRDS("./data/model_svm.rda")

# Evaluation on training data
# phat_rf <- predict(fit_rf, type = "prob")[, "X1"]
# phat_gb <- predict(fit_gb, type = "prob")[, "X1"]
# phat_dt <- predict(fit_dt, type = "prob")[, "X1"]
# phat_knn <- predict(fit_knn, type = "prob")[, "X1"]
# phat_svm <- predict(fit_svm, type = "prob")[, "X1"]
# df <- data.frame(prob_rf = phat_rf, prob_gb = phat_gb, prob_dt = phat_dt, prob_knn = phat_knn, prob_svm = phat_svm, class = as.numeric(gsub("X", "", train$class)))

# Evaluation on test data
phat_rf <- predict(fit_rf, newdata = test, type = "prob")[, "X1"]
phat_gb <- predict(fit_gb, newdata = test, type = "prob")[, "X1"]
phat_dt <- predict(fit_dt, newdata = test, type = "prob")[, "X1"]
phat_knn <- predict(fit_knn, newdata = test, type = "prob")[, "X1"]
phat_svm <- predict(fit_svm, newdata = test, type = "prob")[, "X1"]

# Confusion matrices
# cm_rf <- confusionMatrix(data = ifelse(phat_rf >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
# cm_gb <- confusionMatrix(data = ifelse(phat_gb >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
# cm_dt <- confusionMatrix(data = ifelse(phat_dt >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
# cm_knn <- confusionMatrix(data = ifelse(phat_knn >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")
# cm_svm <- confusionMatrix(data = ifelse(phat_svm >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", train$class)), positive = "1")

# Confusion matrices
cm_rf <- confusionMatrix(data = ifelse(phat_rf >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_gb <- confusionMatrix(data = ifelse(phat_gb >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_dt <- confusionMatrix(data = ifelse(phat_dt >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_knn <- confusionMatrix(data = ifelse(phat_knn >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")
cm_svm <- confusionMatrix(data = ifelse(phat_svm >= 0.5, 1, 0), reference = as.numeric(gsub("X", "", test$class)), positive = "1")

tbl <- cm_gb$table
round(FNrate(tbl), 2)
round(FPrate(tbl), 2)
round(TNrate(tbl), 2)
round(TPrate(tbl), 2)

