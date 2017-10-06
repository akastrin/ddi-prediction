all: create_directory download_twosides drugbank_interactions prepare_topology analysis_prepare analysis_learning analysis_test

create_directory:
	mkdir -p data downloads

download_twosides:
	curl -L -o ./downloads/twosides.zip https://api.pharmgkb.org/v1/site/redirect?p=https://stanford.box.com/shared/static/5fz2nlthlhdlmidwkgng.zip
	rm -f ./downloads/twosides.tsv ;unzip -p ./downloads/twosides.zip > ./downloads/twosides.tsv; rm -f ./downloads/twosides.zip

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
