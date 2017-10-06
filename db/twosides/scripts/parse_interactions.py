import re

# Store pubchem -> drugbank mappings into a dictionary
# Note that there are multiple DrugBank entriest for Pubchem compound
pc2dbD = {}
with open("../drugbank/data/drugbank2pubchem.tsv") as file:
  for line in file:
    line = line.rstrip().split('\t')
    drugbank = line[0]
    pubchem = line[1]
    if not pubchem in pc2dbD: 
      pc2dbD[pubchem] = drugbank
    #else:
    #  print("WARNING: there are multiple drugbank entries for pubchemcompound %s (mapped to DrugBank: %s); only used the first drugbank entry " % (pubchem, drugbank))


with open("./downloads/twosides.tsv") as file:
  for line in file:
    line = line.rstrip().split('\t')
    drug1 = line[0]
    drug2 = line[1]
    rgx = re.compile("CID0+")
    drug1 = rgx.sub('', drug1)
    drug2 = rgx.sub('', drug2)
    if drug1 in pc2dbD and drug2 in pc2dbD:
     drug1 = pc2dbD[drug1]
     drug2 = pc2dbD[drug2]
     print(drug1, drug2, sep='\t')
    


