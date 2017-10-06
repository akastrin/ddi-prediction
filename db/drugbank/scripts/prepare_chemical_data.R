library(ChemmineR)

sdfset <- read.SDFset("./downloads/structures.sdf")
valid <- validSDF(sdfset)
sdfset <- sdfset[valid]

# Extract DrugBank identifiers
db_id <- unname(sapply(datablock(sdfset), `[`, 1))

# Create an instance of a 1024 bit "FPset" of type "apfp"
apset <- sdf2ap(sdfset)
fpset <- desc2fp(apset, descnames=1024, type="FPset") 

# Create empty matrix
sim <- matrix(0, length(fpset), length(fpset))
rownames(sim) <- db_id
colnames(sim) <- db_id

# Compute Tanimoto similarity matrix
for (i in 1:length(fpset)) {
  sim[i, ] <- fpSim(fpset[i], fpset, method = "Tanimoto", sorted = FALSE)
}

# Write table
write.table(sim, file = "./data/chemical_similarity.txt", row.names = FALSE)