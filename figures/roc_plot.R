# Postprocessing: convert -density 600 -compress lzw -resize 2250 -alpha off -depth 8 roc.pdf output.tiff
# convert -compress LZW -alpha remove $BN.png $BN.tiff
# mogrify -alpha off $BN.tiff
library(data.table)
library(ggplot2)
library(plotROC)
library(cowplot)
library(tidyverse)

.st <- function(s){
  bquote(bold(.(s)*phantom("tp")))
}

## DrugBank
df <- fread(input = "../db/drugbank/data/probs.tsv", header = TRUE) %>% rename(RF = prob_rf, GBM = prob_gb)
long <- melt_roc(df, "class", c("RF", "GBM"))
  
p1 <- ggplot(long, aes(d = D, m = M, color = name)) + 
  geom_roc(labels = FALSE, size.point = 0) + 
  style_roc(xlab = "False positive rate", ylab = "True positive rate") +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold")) +
  coord_equal() +
  ggtitle(.st("DrugBank"))

## KEGG
df <- fread(input = "../db/kegg/data/probs.tsv", header = TRUE) %>% rename(RF = prob_rf, GBM = prob_gb)
long <- melt_roc(df, "class", c("RF", "GBM"))

p2 <- ggplot(long, aes(d = D, m = M, color = name)) + 
  geom_roc(labels = FALSE, size.point = 0) + 
  style_roc(xlab = "False positive rate", ylab = "True positive rate") +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold")) +
  coord_equal() +
  ggtitle(.st("KEGG"))

## NDF-RT
df <- fread(input = "../db/ndfrt/data/probs.tsv", header = TRUE) %>% rename(RF = prob_rf, GBM = prob_gb)
long <- melt_roc(df, "class", c("RF", "GBM"))

p3 <- ggplot(long, aes(d = D, m = M, color = name)) + 
  geom_roc(labels = FALSE, size.point = 0) + 
  style_roc(xlab = "False positive rate", ylab = "True positive rate") +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold")) +
  coord_equal() +
  ggtitle(.st("NDF-RT"))

## SemMedDB
df <- fread(input = "../db/semmeddb/data/probs.tsv", header = TRUE) %>% rename(RF = prob_rf, GBM = prob_gb)
long <- melt_roc(df, "class", c("RF", "GBM"))

p4 <- ggplot(long, aes(d = D, m = M, color = name)) + 
  geom_roc(labels = FALSE, size.point = 0) + 
  style_roc(xlab = "False positive rate", ylab = "True positive rate") +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold")) +
  coord_equal() +
  ggtitle(.st("SemMedDB"))

## Twosides
df <- fread(input = "../db/twosides/data/probs.tsv", header = TRUE) %>% rename(RF = prob_rf, GBM = prob_gb)
long <- melt_roc(df, "class", c("RF", "GBM"))

p5 <- ggplot(long, aes(d = D, m = M, color = name)) + 
  geom_roc(labels = FALSE, size.point = 0) + 
  style_roc(xlab = "False positive rate", ylab = "True positive rate") +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold")) +
  coord_equal() +
  ggtitle(.st("Twosides"))

all <- plot_grid(p1, p2, p3, p4, p5, ncol = 3, align = "v")
legend <- get_legend(p1 + theme(legend.position = "bottom"))
p <- plot_grid(all, legend, ncol = 1, rel_heights = c(1, 0.05))
save_plot("roc.pdf", p, base_height = 8, base_width = 12)

