library(igraph)
library(data.table)

# DrugBank
data <- fread("../db/drugbank/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)
g_drugbank <- simplify(g)

# KEGG
data <- fread("../db/kegg/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)
g_kegg <- simplify(g)

# NDF-RT
data <- fread("../db/ndfrt/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)
g_ndfrt <- simplify(g)

# SemmedDB
data <- fread("../db/semmeddb/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)
g_semmeddb <- simplify(g)

# Twosides
data <- fread("../db/twosides/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)
g_twosides <- simplify(g)

# Main diagonal
vcount(g_drugbank)
vcount(g_kegg)
vcount(g_ndfrt)
vcount(g_semmeddb)
vcount(g_twosides)

# Lower triangle
length(intersect(V(g_twosides), V(g_kegg)))
