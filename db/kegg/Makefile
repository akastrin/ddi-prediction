all: create_directory download_kegg kegg_interactions drugbank_interactions prepare_topology analysis_prepare analysis_learning analysis_test

create_directory:
	mkdir -p data downloads

download_kegg:
	curl -L -o ./downloads/drug ftp://ftp.genome.jp/pub/kegg/medicus/drug/drug

kegg_interactions:
	python3 ./scripts/fetch_interactions.py > ./data/kegg_interactions.tsv

drugbank_interactions:
	python3 ./scripts/parse_interactions.py > ./data/drugbank_interactions.tsv

prepare_topology:
	python3 ./scripts/net2measures.py

analysis_prepare:
	Rscript ./scripts/analysis_prepare_data.R

analysis_learning:
	Rscript ./scripts/analysis_learning.R

analysis_test:
	Rscript ./scripts/analysis_train_test.R
