import pandas as pd

# Read file and remove Nan's
df = pd.read_csv("./mappings/rxcui2nui.tsv", delimiter="\t", header=None, names = ['rxcui', 'nui'])
df = df.dropna()
# Create dictionary
nui2rxcui = df.set_index('nui')['rxcui'].to_dict()

# Read file and remove Nan's
df = pd.read_csv("./mappings/rxcui2db.tsv", delimiter="\t", header=None, names = ['rxcui', 'db'])
df = df.dropna()
# Create dictionary
rxcui2db = df.set_index('rxcui')['db'].to_dict()

# Read NDFRT interactions file and convert to DrugBanks ids
with open('./data/ndfrt_interactions.tsv') as file:
  for line in file:
    line = line.rstrip().split('\t')
    (nui1, nui2) = line
    cui1 = nui2rxcui[nui1]
    cui2 = nui2rxcui[nui2]
    if cui1 in rxcui2db and cui2 in rxcui2db:
      db1 = rxcui2db[cui1]
      db2 = rxcui2db[cui2]
      print(db1, db2, sep="\t")

