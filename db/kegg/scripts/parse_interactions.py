import re
import requests

kegg2db = {}

with open('../drugbank/data/drugbank_kegg.tsv', 'r') as file:
  for line in file:
    line = line.rstrip().split('\t')
    (drugbank_id, kegg_id) = line
    kegg2db[kegg_id] = drugbank_id

with open('./data/kegg_interactions.tsv', 'r') as file:
  for line in file:
    line = line.rstrip()
    rsplL = line.split('\t')
    (drug1, drug2, p_or_c, pkMech) = rsplL
    if drug1.startswith('dr:') and drug2.startswith('dr:'):
      drug1 = drug1.replace('dr:', '')
      drug2 = drug2.replace('dr:', '')
      if drug1 in kegg2db and drug2 in kegg2db:
        print(kegg2db[drug1], kegg2db[drug2], sep = '\t')
