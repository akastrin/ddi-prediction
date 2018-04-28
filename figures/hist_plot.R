library(tidyverse)
library(data.table)
library(cowplot)

set.seed(20180329)

.st <- function(s){
  bquote(bold(.(s)*phantom("tp")))
}

## DrugBank
data <- fread("../db/drugbank/data/data_table.csv") %>% as_tibble() %>% 
  select(-c(u, v)) %>% 
  mutate_at(.funs = scale, .vars = vars(-c(class))) %>% 
  transmute(row_mean = rowMeans(select(., -class)), class)

dfs <- list(
  a <- data %>% filter(class == 1) %>% transmute(row_mean, class = "Positive"),
  b <- data %>% filter(class == 0) %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Negative"),
  c <- data %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Random")
)

df <- bind_rows(dfs)
kruskal.test(row_mean ~ as.factor(class), data = df)

p1 <- ggplot(df, aes(x = row_mean, fill = class)) +
  geom_histogram(aes(y = ..ncount..), binwidth = 0.5, alpha = .5, position = "identity") +
  theme_bw() +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold"), aspect.ratio = 1) +
  xlab("Average Similarity") + 
  ylab("Relative frequency") +
  ggtitle(.st("DrugBank"))
  

## KEGG
data <- fread("../db/kegg/data/data_table.csv") %>% as_tibble() %>% 
  select(-c(u, v)) %>% 
  mutate_at(.funs = scale, .vars = vars(-c(class))) %>% 
  transmute(row_mean = rowMeans(select(., -class)), class)

dfs <- list(
  a <- data %>% filter(class == 1) %>% transmute(row_mean, class = "Positive"),
  b <- data %>% filter(class == 0) %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Negative"),
  c <- data %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Random")
)

df <- bind_rows(dfs)
kruskal.test(row_mean ~ as.factor(class), data = df)

p2 <- ggplot(df, aes(x=row_mean, fill=class)) +
  geom_histogram(aes(y = ..ncount..), binwidth = 0.5, alpha = .5, position = "identity") +
  theme_bw() +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold"), aspect.ratio = 1) +
  xlab("Average Similarity") + 
  ylab("Relative frequency") +
  ggtitle(.st("KEGG"))

## NDF-RT
data <- fread("../db/ndfrt/data/data_table.csv") %>% as_tibble() %>% 
  select(-c(u, v)) %>% 
  mutate_at(.funs = scale, .vars = vars(-c(class))) %>% 
  transmute(row_mean = rowMeans(select(., -class)), class)

dfs <- list(
  a <- data %>% filter(class == 1) %>% transmute(row_mean, class = "Positive"),
  b <- data %>% filter(class == 0) %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Negative"),
  c <- data %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Random")
)

df <- bind_rows(dfs)
kruskal.test(row_mean ~ as.factor(class), data = df)

p3 <- ggplot(df, aes(x=row_mean, fill=class)) +
  geom_histogram(aes(y = ..ncount..), binwidth = 0.5, alpha = .5, position = "identity") +
  theme_bw() +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold"), aspect.ratio = 1) +
  xlab("Average Similarity") + 
  ylab("Relative frequency") +
  ggtitle(.st("NDF-RT"))

## SemMedDB
data <- fread("../db/semmeddb/data/data_table.csv") %>% as_tibble() %>% 
  select(-c(u, v)) %>% 
  mutate_at(.funs = scale, .vars = vars(-c(class))) %>% 
  transmute(row_mean = rowMeans(select(., -class)), class)

dfs <- list(
  a <- data %>% filter(class == 1) %>% transmute(row_mean, class = "Positive"),
  b <- data %>% filter(class == 0) %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Negative"),
  c <- data %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Random")
)

df <- bind_rows(dfs)
kruskal.test(row_mean ~ as.factor(class), data = df)

p4 <- ggplot(df, aes(x=row_mean, fill=class)) +
  geom_histogram(aes(y = ..ncount..), binwidth = 0.5, alpha = .5, position = "identity") +
  theme_bw() +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold"), aspect.ratio = 1) +
  xlab("Average Similarity") + 
  ylab("Relative frequency") +
  ggtitle(.st("SemMedDB"))

## Twosides
data <- fread("../db/twosides/data/data_table.csv") %>% as_tibble() %>% 
  select(-c(u, v)) %>% 
  mutate_at(.funs = scale, .vars = vars(-c(class))) %>% 
  transmute(row_mean = rowMeans(select(., -class)), class)

dfs <- list(
  a <- data %>% filter(class == 1) %>% transmute(row_mean, class = "Positive"),
  b <- data %>% filter(class == 0) %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Negative"),
  c <- data %>% sample_n(size = nrow(a)) %>% transmute(row_mean, class = "Random")
)

df <- bind_rows(dfs)
kruskal.test(row_mean ~ as.factor(class), data = df)

p5 <- ggplot(df, aes(x=row_mean, fill=class)) +
  geom_histogram(aes(y = ..ncount..), binwidth = 0.5, alpha = 0.5, position = "identity") +
  theme_bw() +
  theme(legend.title = element_blank(), legend.position = "none", plot.title = element_text(face = "bold"), aspect.ratio = 1) +
  xlab("Average Similarity") + 
  ylab("Relative frequency") +
  ggtitle(.st("Twosides"))

all <- plot_grid(p1, p2, p3, p4, p5, ncol = 3, align = "v")
legend <- get_legend(p1 + theme(legend.position = "bottom"))
p <- plot_grid(all, legend, ncol = 1, rel_heights = c(1, 0.05))
save_plot("hist.pdf", p, base_height = 8, base_width = 12)

