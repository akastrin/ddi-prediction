library(caret)
library(data.table)
library(dplyr)
library(pROC)
library(ROSE)
library(plotROC)

# Read data
data_table <- fread("./data/data_table.csv")
# Undersampling
data <- ovun.sample(class ~ rai + jc + aai + pa + ccn + cra+ wic + atc + chem + mesh + ade,
                    data = data_table, p = 0.5, seed = 123, method = "under")$data
# Class variable should be factor
data$class <- as.factor(data$class)
levels(data$class) <- make.names(levels(data$class))

# Machine learning 
train_control <- trainControl(method = "cv", number = 10, savePredictions = TRUE, classProbs = TRUE)
model_lda <- train(class ~ ., method = "lda", data = data, trControl = train_control)
model_glm <- train(class ~ ., method = "glm", data = data, trControl = train_control)

# Save predictions
set.seed(20170802)
idx <- sample(nrow(model_lda$pred), nrow(model_lda$pred) * 0.1)
fwrite(x = model_lda$pred[idx, ], file = "./data/pred_lda.csv", col.names = TRUE)
fwrite(x = model_glm$pred[idx, ], file = "./data/pred_glm.csv", col.names = TRUE)

saveRDS(model_lda, file = "./data/model_lda.rda")
saveRDS(model_glm, file = "./data/model_glm.rda")