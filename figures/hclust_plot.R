library(dplyr)
library(data.table)
library(ROSE)
library(ggplot2)
library(ggdendro)
library(dendextend)
library(cowplot)

.st <- function(s){
  bquote(bold(.(s)*phantom("tp")))
}

## DrugBank
df1 <- fread("../db/drugbank/data/data_table.csv")
df1 <- ovun.sample(class ~ ., data = df1, p = 0.5, seed = 123, method = "under")$data
z_mat <- scale(df1[, 3:14])
d_mat <- dist(x = t(z_mat), method = "euclidean")
hc <- hclust(d = d_mat, method = "ward.D2")
dendr <- dendro_data(hc, type="rectangle")

p1 <- ggplot() + 
  geom_segment(data = segment(dendr), aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_text(data = label(dendr), aes(x, y = -0.5, label = paste(" ", label), hjust = 0), size = 5) +
  coord_flip() + scale_y_reverse(expand = c(0.3, 0)) + 
  theme_bw() +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank()) +
  ggtitle(.st("DrugBank"))

## KEGG
df2 <- fread("../db/kegg/data/data_table.csv")
df2 <- ovun.sample(class ~ ., data = df2, p = 0.5, seed = 123, method = "under")$data
z_mat <- scale(df2[, 3:14])
d_mat <- dist(x = t(z_mat), method = "euclidean")
hc <- hclust(d = d_mat, method = "ward.D2")
dendr <- dendro_data(hc, type="rectangle")

p2 <- ggplot() + 
  geom_segment(data = segment(dendr), aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_text(data = label(dendr), aes(x, y = -0.5, label = paste(" ", label), hjust = 0), size = 5) +
  coord_flip() + scale_y_reverse(expand = c(0.3, 0)) + 
  theme_bw() +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank()) +
  ggtitle(.st("KEGG"))

## NDF-RT
df3 <- fread("../db/ndfrt/data/data_table.csv")
df3 <- ovun.sample(class ~ ., data = df3, p = 0.5, seed = 123, method = "under")$data
z_mat <- scale(df3[, 3:14])
d_mat <- dist(x = t(z_mat), method = "euclidean")
hc <- hclust(d = d_mat, method = "ward.D2")
dendr <- dendro_data(hc, type="rectangle")

p3 <- ggplot() + 
  geom_segment(data = segment(dendr), aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_text(data = label(dendr), aes(x, y = -0.5, label = paste(" ", label), hjust = 0), size = 5) +
  coord_flip() + scale_y_reverse(expand = c(0.3, 0)) + 
  theme_bw() +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank()) +
  ggtitle(.st("NDF-RT"))

## SemMedDB
df4 <- fread("../db/semmeddb/data/data_table.csv")
df4 <- ovun.sample(class ~ ., data = df4, p = 0.5, seed = 123, method = "under")$data
z_mat <- scale(df4[, 3:14])
d_mat <- dist(x = t(z_mat), method = "euclidean")
hc <- hclust(d = d_mat, method = "ward.D2")
dendr <- dendro_data(hc, type="rectangle")

p4 <- ggplot() + 
  geom_segment(data = segment(dendr), aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_text(data = label(dendr), aes(x, y = -0.5, label = paste(" ", label), hjust = 0), size = 5) +
  coord_flip() + scale_y_reverse(expand = c(0.3, 0)) + 
  theme_bw() +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank()) +
  ggtitle(.st("SemMedDB"))

## Twosides
df5 <- fread("../db/twosides/data/data_table.csv")
df5 <- ovun.sample(class ~ ., data = df5, p = 0.5, seed = 123, method = "under")$data
z_mat <- scale(df5[, 3:14])
d_mat <- dist(x = t(z_mat), method = "euclidean")
hc <- hclust(d = d_mat, method = "ward.D2")
dendr <- dendro_data(hc, type="rectangle")

p5 <- ggplot() + 
  geom_segment(data = segment(dendr), aes(x = x, y = y, xend = xend, yend = yend)) + 
  geom_text(data = label(dendr), aes(x, y = -0.5, label = paste(" ", label), hjust = 0), size = 5) +
  coord_flip() + scale_y_reverse(expand = c(0.3, 0)) + 
  theme_bw() +
  theme(axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        panel.border = element_blank(),
        panel.grid = element_blank()) +
  ggtitle(.st("Twosides"))

all <- plot_grid(p1, p2, p3, p4, p5, ncol = 3, align = "v")
save_plot("hclust.pdf", all, base_height = 8, base_width = 12)
