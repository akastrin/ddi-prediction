include config.cfg

all: create_directory download_drugbank download_sider drugbank_interactions drugbank_atc drugbank_mesh drugbank_kegg parse_drugbank pubchem_map sider_map prepare_data prepare_topology analysis_prepare analysis_learning analysis_test analysis_evaluation

create_directory:
	mkdir -p data downloads

download_drugbank:
	curl -L -o ./downloads/drugbank.zip -u ${USER}:${PASS} https://www.drugbank.ca/releases/5-0-7/downloads/all-full-database 
	rm -f ./downloads/drugbank.xml ; unzip -p ./downloads/drugbank.zip > ./downloads/drugbank.xml; rm -f ./downloads/drugbank.zip
	curl -L -o ./downloads/structures.zip -u ${USER}:${PASS} https://www.drugbank.ca/releases/5-0-7/downloads/all-structures
	rm -f ./downloads/structures.sdf ; unzip -p ./downloads/structures.zip > ./downloads/structures.sdf; rm -f ./downloads/structures.zip

download_sider:
	curl -L -o ./downloads/meddra_all_se.tsv.gz http://sideeffects.embl.de/media/download/meddra_all_se.tsv.gz
	gzip -df ./downloads/meddra_all_se.tsv.gz

drugbank_interactions:
	xmlstarlet sel -T -N t=http://www.drugbank.ca -t -m 't:drugbank/t:drug/t:drug-interactions/t:drug-interaction' -v 'concat(../../t:drugbank-id, "	", t:drugbank-id)' -n ./downloads/drugbank.xml > ./data/drugbank_interactions.tsv

drugbank_atc:
	xmlstarlet sel -T -N t=http://www.drugbank.ca -t -m "t:drugbank/t:drug/t:atc-codes/t:atc-code" -v "concat(../../t:drugbank-id, '	', @code)" -n ./downloads/drugbank.xml > ./data/drugbank_atc.tsv

drugbank_mesh:
	xmlstarlet sel -T -N t=http://www.drugbank.ca -t -m "t:drugbank/t:drug/t:categories/t:category" -v "concat(../../t:drugbank-id, '	', t:mesh-id)" -n ./downloads/drugbank.xml | awk '{FS="\t"; OFS="\t"}{if ($$2 != "") print $$1, $$2}' > ./data/drugbank_mesh.tsv

drugbank_kegg:
	xmlstarlet sel -T -N t=http://www.drugbank.ca -t -m "t:drugbank/t:drug/t:external-identifiers/t:external-identifier[t:resource='KEGG Drug']" -v "concat(../../t:drugbank-id, '	', t:identifier)" -n ./downloads/drugbank.xml > ./data/drugbank_kegg.tsv

parse_drugbank:
	python3 ./scripts/parse_drugbank.py

pubchem_map:
	python3 ./scripts/pubchem_map.py > ./data/drugbank2pubchem.tsv

sider_map:
	python3 ./scripts/sider_map.py

prepare_data:
	Rscript ./scripts/prepare_atc_data.R
	Rscript ./scripts/prepare_chemical_data.R
	Rscript ./scripts/prepare_mesh_data.R
	Rscript ./scripts/prepare_sider_data.R

prepare_topology:
	python3 ./scripts/net2measures.py

analysis_prepare:
	Rscript ./scripts/analysis_prepare_data.R

analysis_learning:
	Rscript ./scripts/analysis_learning.R

analysis_test:
	Rscript ./scripts/analysis_train_test.R

analysis_evaluation:
	Rscript ./scripts/analysis_evaluation.R
