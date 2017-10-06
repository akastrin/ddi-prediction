library(igraph)
library(data.table)

data <- fread("../db/drugbank/data/drugbank_interactions.tsv", header = FALSE)
g <- graph_from_data_frame(d = data, directed = FALSE)

g <- simplify(as.undirected(g))
l <- layout.auto(g)

png("net.pdf")
plot(g, vertex.size = 0, vertex.shape = "none", vertex.label = NA,
     edge.color = adjustcolor("black", alpha = .1), edge.curved = TRUE, edge.width=0.2, layout = l)
dev.off()
