library(cowplot)
library(caret)
library(reshape2)
library(ggplot2)

.st <- function(s){
  bquote(bold(.(s)*phantom("tp")))
}

labels <- c(rf = "RF", gb = "GBM")

## Drugbank
fit_rf <- readRDS("../db/drugbank/data/fit_rf.rds")
fit_gb <- readRDS("../db/drugbank/data/fit_gb.rds")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df1 <- data.frame(rf = d1$Overall, gb= d2$Overall, feature = rownames(d1))
df1 <- melt(df1, id.vars = "feature")

p1 <- ggplot(df1, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() + 
  theme_bw() +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle(.st("DrugBank"))

## KEGG
fit_rf <- readRDS("../db/kegg/data/fit_rf.rds")
fit_gb <- readRDS("../db/kegg/data/fit_gb.rds")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df2 <- data.frame(rf = d1$Overall, gb= d2$Overall, feature = rownames(d1))
df2 <- melt(df2, id.vars = "feature")

p2 <- ggplot(df2, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle(.st("KEGG"))

## NDF-RT
fit_rf <- readRDS("../db/ndfrt/data/fit_rf.rds")
fit_gb <- readRDS("../db/ndfrt/data/fit_gb.rds")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df3 <- data.frame(rf = d1$Overall, gb= d2$Overall, feature = rownames(d1))
df3 <- melt(df3, id.vars = "feature")

p3 <- ggplot(df3, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle(.st("NDF-RT"))

## SemMedDB
fit_rf <- readRDS("../db/semmeddb/data/fit_rf.rds")
fit_gb <- readRDS("../db/semmeddb/data/fit_gb.rds")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df4 <- data.frame(rf = d1$Overall, gb= d2$Overall, feature = rownames(d1))
df4 <- melt(df4, id.vars = "feature")

p4 <- ggplot(df4, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle(.st("SemMedDB"))

## TWOSIDES
fit_rf <- readRDS("../db/twosides/data/fit_rf.rds")
fit_gb <- readRDS("../db/twosides/data/fit_gb.rds")

d1 <- varImp(fit_rf)$importance
d2 <- varImp(fit_gb)$importance
df5 <- data.frame(rf = d1$Overall, gb= d2$Overall, feature = rownames(d1))
df5 <- melt(df5, id.vars = "feature")

p5 <- ggplot(df5, aes(x = feature, y = value)) +
  geom_bar(stat = "identity") + 
  facet_wrap(~variable, labeller = labeller(variable = labels)) +
  xlab("Feature") +
  ylab("Importance") +
  coord_flip() +
  theme_bw() +
  theme(plot.title = element_text(face = "bold")) +
  ggtitle(.st("Twosides"))

all <- plot_grid(p1, p2, p3, p4, p5, ncol = 3, align = "v")
save_plot("var_imp.pdf", all, base_height = 8, base_width = 12)
