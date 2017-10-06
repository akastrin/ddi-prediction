import csv
import gzip
import collections
import pandas

# STITCH to DrugBank mapping utilities
def stitch_flat_to_pubchem(cid):
    assert cid.startswith('CID')
    return int(cid[3:]) - 1e8

def stitch_stereo_to_pubchem(cid):
    assert cid.startswith('CID')
    return int(cid[3:])

# Read DrugBank terms
file = './data/drugbank.tsv'
drugbank_df = pandas.read_table(file)[['drugbank_id', 'name']].rename(columns={'name': 'drugbank_name'})

# Pubchem to DrugBank mapping
file = './data/drugbank2pubchem.tsv'
drugbank_map_df = pandas.read_table(file)

# Parse meddra_all_se.tsv.gz
columns = [
    'stitch_id_flat',
    'stitch_id_sterio',
    'umls_cui_from_label',
    'meddra_type',
    'umls_cui_from_meddra',
    'side_effect_name',
]
se_df = pandas.read_table('./downloads/meddra_all_se.tsv', names=columns)
se_df['pubchem_cid'] = se_df.stitch_id_sterio.map(stitch_stereo_to_pubchem)
se_df = drugbank_map_df.merge(se_df)
#se_df.head(2)
se_df = se_df[['drugbank_id', 'umls_cui_from_meddra', 'side_effect_name']]
se_df = se_df.dropna()
se_df = se_df.drop_duplicates(['drugbank_id', 'umls_cui_from_meddra'])
se_df = drugbank_df.merge(se_df)
se_df = se_df.sort_values(['drugbank_id', 'umls_cui_from_meddra', 'side_effect_name'])
#len(se_df)

# Create a reference of side effect IDs and Names
#se_terms_df = se_df[['umls_cui_from_meddra', 'side_effect_name']].drop_duplicates()
#assert se_terms_df.side_effect_name.duplicated().sum() == 0
#se_terms_df = se_terms_df.sort_values('side_effect_name')
#se_terms_df.to_csv('../download/side-effect-terms.tsv', sep='\t', index=False)

# Number of drugbank drugs
se_df.drugbank_id.nunique()

# Number of UMLS side effects
se_df.umls_cui_from_meddra.nunique()

# Save side effects
se_df.to_csv('./data/side_effects.tsv', sep='\t', index=False)

