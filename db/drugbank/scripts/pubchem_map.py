import pandas
import pubchempy

# Read DrugBank compounds
drugbank_df = pandas.read_table('./data/drugbank.tsv')
drugbank_df = drugbank_df[-drugbank_df.inchi.isnull()]

# Map DrugBank compounds to pubchem using InChI 
rows = list()
for i, row in drugbank_df.iterrows():
    try:
        compounds = pubchempy.get_compounds(row.inchi, namespace='inchi')
    except pubchempy.BadRequestError:
        print('BadRequestError', row)
        continue
    try:
        compound, = compounds
    except ValueError:
        print(row, compounds)
        continue
    row['pubchem_cid'] = compound.cid
    rows.append(row)

# Create a DataFrame of the mapping
mapped_df = pandas.DataFrame(rows)
mapping_df = mapped_df[['drugbank_id', 'pubchem_cid']].dropna()
mapping_df['pubchem_cid'] = mapping_df['pubchem_cid'].astype(int)

# Save mapping
mapping_df.to_csv('./data/drugbank2pubchem.tsv', index=False, sep='\t')

# The number of DrugBank compounds that did not uniquely map to PubChem (240)
len(drugbank_df) - len(mapping_df)







