library(tidyverse)
library(scmamp)

data <- read_csv("data.csv")

# Train data
train <- data %>% filter(Regime == "Train" & Classifier != "Unsupervised") %>% select(-Regime)
train <- spread(train, Classifier, AUPR) %>% select(-Source)

# Testing for differences
friedmanTest(train)
nemenyi_test <- nemenyiTest(train, alpha = 0.05)
abs(nemenyi_test$diff.matrix) > nemenyi_test$statistic

pdf("cd-train.pdf", width = 8, height = 4)
plotCD(train, alpha = 0.05)
dev.off()

# Post-hoc test
pv_matrix <- friedmanAlignedRanksPost(data = train, control = NULL)
pv_adj <- adjustShaffer(pv_matrix)

# Test data
test <- data %>% filter(Regime == "Test" & Classifier != "Unsupervised") %>% select(-Regime)
test <- spread(test, Classifier, AUPR) %>% select(-Source)

# Testing for differences
friedmanTest(test)
nemenyi_test <- nemenyiTest(train, alpha = 0.05)
abs(nemenyi_test$diff.matrix) > nemenyi_test$statistic

pdf("cd-test.pdf", width = 8, height = 4)
plotCD(test, alpha = 0.05)
dev.off()

# Post-hoc test
pv_matrix <- friedmanAlignedRanksPost(data = test, control = NULL)
pv_adj <- adjustShaffer(pv_matrix)

# Now we also include unsupervised results as control group
train <- data %>% filter(Regime == "Train") %>% select(-Regime)
train <- spread(train, Classifier, AUPR) %>% select(-Source)
pv_matrix <- friedmanAlignedRanksPost(data = train, control = "Unsupervised")
pv_adj <- adjustHolland(pv_matrix)

test <- data %>% filter(Regime == "Test") %>% select(-Regime)
test <- spread(test, Classifier, AUPR) %>% select(-Source)
pv_matrix <- friedmanAlignedRanksPost(data = test, control = "Unsupervised")
pv_adj <- adjustHolland(pv_matrix)
