include config.cfg

all: create_directory query_database drugbank_interactions prepare_topology analysis_prepare analysis_learning analysis_test

create_directory:
	mkdir -p data downloads mappings

query_database:
	mysql -sN -D${DB1} -u${USER} -p${PASS} < ./scripts/query_interactions.sql > ./data/semmeddb_interactions.tsv
	mysql -sN -D${DB2} -u${USER} -p${PASS} < ./scripts/cui2db.sql > ./mappings/cui2db.tsv

drugbank_interactions:
	python3 ./scripts/parse_interactions.py | sort | uniq > ./data/drugbank_interactions.tsv

prepare_topology:
	python3 ./scripts/net2measures.py

analysis_prepare:
	Rscript ./scripts/analysis_prepare_data.R

analysis_learning:
	Rscript ./scripts/analysis_learning.R

analysis_test:
	Rscript ./scripts/analysis_train_test.R
