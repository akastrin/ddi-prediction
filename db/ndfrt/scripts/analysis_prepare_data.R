library(data.table)

# Read topological measures
measures <- fread("./data/topology_measures.txt")

# Read similarity matrix ATC
sim_atc <- as.matrix(fread("../drugbank/data/atc_similarity.txt"))
rownames(sim_atc) <- colnames(sim_atc)

# Read similarity matrix CHEMICAL
sim_chem <- as.matrix(fread("../drugbank/data/chemical_similarity.txt"))
rownames(sim_chem) <- colnames(sim_chem)

# Read similarity matrix MeSH
sim_mesh <- as.matrix(fread("../drugbank/data/mesh_similarity.txt"))
rownames(sim_mesh) <- colnames(sim_mesh)

# Read similarity matrix ADE
sim_ade <- as.matrix(fread("../drugbank/data/sider_similarity.txt"))
rownames(sim_ade) <- colnames(sim_ade)

# Loop over measures and store similarity for each pair of compounds
atc <- vector(length = nrow(measures))
chem <- vector(length = nrow(measures))
mesh <- vector(length = nrow(measures))
ade <- vector(length = nrow(measures))

for (i in 1:nrow(measures)) {
  u <- measures$u[i]
  v <- measures$v[i]
  # Check ATC
  trial <- (u %in% rownames(sim_atc)) && (v %in% rownames(sim_atc))
  if (trial) {
    atc[i] <- sim_atc[u, v]
  }
  # Check CHEMICAL
  trial <- (u %in% rownames(sim_chem)) && (v %in% rownames(sim_chem))
  if (trial) {
    chem[i] <- sim_chem[u, v]
  }
  # Check MeSH
  trial <- (u %in% rownames(sim_mesh)) && (v %in% rownames(sim_mesh))
  if (trial) {
    mesh[i] <- sim_mesh[u, v]
  }
  # Check ADE
  trial <- (u %in% rownames(sim_ade)) && (v %in% rownames(sim_ade))
  if (trial) {
    ade[i] <- sim_ade[u, v]
  }
}

# Create data frame
# Create data frame
data <- data.frame(u = measures$u, v = measures$v,
                   cn = measures$cn, rai = measures$rai, jc = measures$jc,
                   aai = measures$aai, pa = measures$pa, ccn = measures$ccn,
                   cra = measures$cra, wic = measures$wic,
                   atc = atc, chem = chem, mesh = mesh, ade = ade,
                   class = measures$has_edge)

# Store data frame
fwrite(x = data, file = "./data/data_table.csv", col.names = TRUE)
