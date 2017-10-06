import re

cui2dbD = {}
with open('./mappings/cui2db.tsv') as file:
  for line in file:
    line = line.rstrip().split('\t')
    (cui, drugbank) = line
    if not cui in cui2dbD:
      cui2dbD[cui] = drugbank
    
with open("./data/semmeddb_interactions.tsv") as file:
  for line in file:
    line = line.rstrip().split("\t")
    if re.match('^C\d+', line[0]) and re.match('^C\d+', line[1]):
      cui1 = line[0].split('|')[0]
      cui2 = line[1].split('|')[0]
      if cui1 in cui2dbD and cui2 in cui2dbD:
        drug1 = cui2dbD[cui1]
        drug2 = cui2dbD[cui2]
        print(drug1, drug2, sep='\t')
