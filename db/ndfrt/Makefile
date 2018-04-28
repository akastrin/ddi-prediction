include config.cfg

all: create_directory query_database ndfrt_interactions drugbank_interactions prepare_topology analysis_prepare analysis_learning analysis_test

create_directory:
	mkdir -p data downloads mappings

query_database:
	mysql -sN -D${DB} -u${USER} -p${PASS} < ./scripts/rxcui2nui.sql > ./data/rxcui2nui.tsv
	mysql -sN -D${DB} -u${USER} -p${PASS} < ./scripts/rxcui2db.sql > ./data/rxcui2db.tsv

ndfrt_interactions:
	python3 ./scripts/fetch_interactions.py > ./data/ndfrt_interactions.tsv

drugbank_interactions:
	python3 ./scripts/nui2db.py > ./data/drugbank_interactions.tsv

prepare_topology:
	python3 ./scripts/net2measures.py

analysis_prepare:
	Rscript ./scripts/analysis_prepare_data.R

analysis_learning:
	Rscript ./scripts/analysis_learning.R

analysis_test:
	Rscript ./scripts/analysis_train_test.R
