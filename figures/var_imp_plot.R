library(cowplot)
library(caret)
library(reshape2)
library(ggplot2)
library(gbm)
library(grid)

.st <- function(s){
  bquote(bold(.(s)*phantom("tp")))
}

normalise <- function(x) {
  res <- (x-min(x))/(max(x)-min(x))
  return(res)
}

labels <- c(rf = "RF", gb = "GBM")

## Drugbank
fit_rf <- readRDS("../db/drugbank/data/model_rf.rda")
fit_gb <- readRDS("../db/drugbank/data/model_gb.rda")

d1 <- varImp(fit_rf, scale = TRUE)$importance
d2 <- varImp(fit_gb, scale = TRUE)$importance
df1 <- data.frame(rf = normalise(d1$Overall), gb= normalise(d2$Overall), feature = rownames(d1))
tbl1 <- df1
tbl1$network <- "Drugbank"
df1 <- melt(df1, id.vars = "feature")

p1 <- ggplot(df1, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() + 
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle(.st("DrugBank"))

## KEGG
fit_rf <- readRDS("../db/kegg/data/model_rf.rda")
fit_gb <- readRDS("../db/kegg/data/model_gb.rda")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df2 <- data.frame(rf = normalise(d1$Overall), gb= normalise(d2$Overall), feature = rownames(d1))
tbl2 <- df2
tbl2$network <- "KEGG"
df2 <- melt(df2, id.vars = "feature")

p2 <- ggplot(df2, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle(.st("KEGG"))

## NDF-RT
fit_rf <- readRDS("../db/ndfrt/data/model_rf.rda")
fit_gb <- readRDS("../db/ndfrt/data/model_gb.rda")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df3 <- data.frame(rf = normalise(d1$Overall), gb= normalise(d2$Overall), feature = rownames(d1))
tbl3 <- df3
tbl3$network <- "NDF-RT"
df3 <- melt(df3, id.vars = "feature")

p3 <- ggplot(df3, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle(.st("NDF-RT"))

## SemMedDB
fit_rf <- readRDS("../db/semmeddb/data/model_rf.rda")
fit_gb <- readRDS("../db/semmeddb/data/model_gb.rda")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df4 <- data.frame(rf = normalise(d1$Overall), gb= normalise(d2$Overall), feature = rownames(d1))
tbl4 <- df4
tbl4$network <- "SemMedDB"
df4 <- melt(df4, id.vars = "feature")

p4 <- ggplot(df4, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle(.st("SemMedDB"))

## TWOSIDES
fit_rf <- readRDS("../db/twosides/data/model_rf.rda")
fit_gb <- readRDS("../db/twosides/data/model_gb.rda")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df5 <- data.frame(rf = normalise(d1$Overall), gb= normalise(d2$Overall), feature = rownames(d1))
tbl5 <- df5
tbl5$network <- "Twosides"
df5 <- melt(df5, id.vars = "feature")

p5 <- ggplot(df5, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold"),
        panel.spacing = unit(1.5, "lines")) +
  ggtitle(.st("Twosides"))

all <- plot_grid(p1, p2, p3, p4, p5, ncol = 3, align = "v")
save_plot("var_imp.pdf", all, base_height = 8, base_width = 12)

tbl <- bind_rows(tbl1, tbl2, tbl3, tbl4, tbl5)
tbl %>%
  group_by(feature) %>% 
  summarise(mean = mean(gb)) %>% 
  arrange(mean)
