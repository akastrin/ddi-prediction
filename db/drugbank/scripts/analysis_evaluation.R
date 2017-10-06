library(caret)
library(data.table)
library(dplyr)
library(ROSE)
library(xlsx)

n <- 1000

# Read data
data_table <- fread("./data/data_table.csv")
# Undersampling
data <- ovun.sample(class ~ ., data = data_table, p = 0.5, seed = 123, method = "under")$data
# Class variable should be factor
data$class <- as.factor(data$class)
levels(data$class) <- make.names(levels(data$class))

# Load stored model
model_glm <- readRDS(file = "./data/model_glm.rda")

# Prediction and post-processing
pred <- predict(model_glm, newdata = data, type = "prob")
pred <- cbind(u = data$u, v = data$v, pred)
pred$obs <- data$class
pred$pred <- ifelse(pred$X1 > 0.5, 1, 0)
pred <- pred %>% filter(obs == "X0" & pred == 1) %>% arrange(desc(X1)) %>% head(n = n)

# Map DrugBank IDs to names
drugbank <- fread(file = "./data/drugbank.tsv", header = TRUE)

u_name <- vector(length = n)
v_name <- vector(length = n)
for (i in 1:nrow(pred)) {
  u_name[i] <- as.character(drugbank %>% filter(drugbank_id == pred$u[i]) %>% dplyr::select(name))
  v_name[i] <- as.character(drugbank %>% filter(drugbank_id == pred$v[i]) %>% dplyr::select(name))
}

pred$name_u <- u_name
pred$name_v <- v_name
write.xlsx(x = pred, file = "./data/evaluation.xlsx")