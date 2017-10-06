library(data.table)
library(dplyr)
library(lsa)

# Read drugbank_id -> mesh_dui file
db2mh <- fread("./data/drugbank_mesh.tsv", header = FALSE, col.names = c("drugbank_id", "mesh_dui"))

# Create empty matrix
sim <- matrix(data = 0, nrow = length(unique(db2mh$drugbank_id)), ncol = length(unique(db2mh$mesh_dui)))
rownames(sim) <- unique(db2mh$drugbank_id)
colnames(sim) <- unique(db2mh$mesh_dui)

# Count 1s and 0s
for (i in 1:nrow(sim)) {
  sel <- db2mh %>% filter(drugbank_id == rownames(sim)[i]) %>% select(mesh_dui)
  sim[i, ] <- as.numeric(colnames(sim) %in% sel$mesh_dui)
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
write.table(cos, file = "./data/mesh_similarity.txt", row.names = FALSE)