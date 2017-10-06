library(igraph)
library(data.table)

data <- fread("./data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)

# Number of vertices and edges
vcount(g)
ecount(g)

# Mean degree
c <- mean(degree(g))

# Diameter
D <- diameter(g)

# Average path length
L <- average.path.length(g)

# Clustering coefficient
C <- transitivity(g, type = "average")

# Size of giant component
cl <- clusters(g) 
g1 <- induced.subgraph(g, which(cl$membership == which.max(cl$csize)))
size <- vcount(g1) / vcount(g) * 100

# Export network for Gephi
gD <- simplify(g)
nodes_df <- data.frame(ID = c(1:vcount(gD)), NAME = V(gD)$name)
edges_df <- as.data.frame(get.edges(gD, c(1:ecount(gD))))
