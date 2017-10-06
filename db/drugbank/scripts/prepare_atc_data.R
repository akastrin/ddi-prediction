library(data.table)
library(dplyr)
library(lsa)

# Read drugbank_id -> mesh_dui file
db2atc <- fread("./data/drugbank_atc.tsv", header = FALSE, col.names = c("drugbank_id", "atc"))

# Extract first level ATC code
db2atc$atc <- substr(db2atc$atc, 1, 1)

# Create empty matrix
sim <- matrix(data = 0, nrow = length(unique(db2atc$drugbank_id)), ncol = length(unique(db2atc$atc)))
rownames(sim) <- unique(db2atc$drugbank_id)
colnames(sim) <- unique(db2atc$atc)

# Count 1s and 0s
for (i in 1:nrow(sim)) {
  sel <- db2atc %>% filter(drugbank_id == rownames(sim)[i]) %>% select(atc)
  sim[i, ] <- as.numeric(colnames(sim) %in% sel$atc)
}

# Compute IDF
tf <- sim
idf <- log(nrow(sim)/colSums(sim))
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
write.table(cos, file = "./data/atc_similarity.txt", row.names = FALSE)
