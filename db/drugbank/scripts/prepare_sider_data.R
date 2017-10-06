library(data.table)
library(dplyr)
library(lsa)

# Read drugbank_id -> side_effects file
db2se <- fread("./data/side_effects.tsv", header = TRUE)

# Create empty matrix
sim <- matrix(data = 0, nrow = length(unique(db2se$drugbank_id)), ncol = length(unique(db2se$umls_cui_from_meddra)))
rownames(sim) <- unique(db2se$drugbank_id)
colnames(sim) <- unique(db2se$umls_cui_from_meddra)

# Count 1s and 0s
for (i in 1:nrow(sim)) {
  sel <- db2se %>% filter(drugbank_id == rownames(sim)[i]) %>% select(umls_cui_from_meddra)
  sim[i, ] <- as.numeric(colnames(sim) %in% sel$umls_cui_from_meddra)
}

# Compute IDF
tf <- sim
idf <- log(nrow(sim) / colSums(sim))
tfidf <- sim

# Compute term TF * IDF
for(word in names(idf)){
  tfidf[, word] <- tf[, word] * idf[word]
}

# Normalize matrix
tfidf_norm <- tfidf / sqrt(rowSums(tfidf^2))

# Compute similarity matrix
cos <- cosine(as.matrix(t(tfidf_norm)))

# Write table
write.table(cos, file = "./data/sider_similarity.txt", row.names = FALSE)