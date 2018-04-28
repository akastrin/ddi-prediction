import requests
from lxml import etree
import pandas

ns = {"atom": "http://www.ncbi.nlm.nih.gov"} 

# Read DrugBank compounds
drugbank_df = pandas.read_table('./data/drugbank.tsv')
drugbank_df = drugbank_df[-drugbank_df.inchikey.isnull()]

# Map DrugBank compounds to pubchem using InChI key
rows = list()
print("drugbank_id" + "\t" + "pubchem_cid")
for i, row in drugbank_df.iterrows():
    url = "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/{}/XML".format(row.inchikey)
    request = requests.get(url)
    root = etree.XML(request.content)
    cid = root.xpath("//atom:PC-Compound/atom:PC-Compound_id/atom:PC-CompoundType/atom:PC-CompoundType_id/atom:PC-CompoundType_id_cid", namespaces=ns)
    if cid:    
        print(row.drugbank_id + "\t" + cid[0].text)
