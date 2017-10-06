# Predicting potential drug-drug interactions on topological and semantic similarity features using statistical learning

This repository contains the programming code we developed for the paper submitted to PLoS ONE. The code implements the methodology of the paper and reproduce all the figures of the paper.

## Dependencies

The code is written in AWK, Python and R. To use the code you will need:
* Python 3 [https://www.python.org] with packages: `community`, `networkx`, `pandas`, `pubchempy`, `requests`
* R [https://www.r-project.org] with the packages: `caret`, `data.table`, `dplyr`, `ggplot2`, `igraph`, `lsa`,  `plotROC`, `ranger`, `ROSE`, `tidyverse`
* XMLStarlet [http://xmlstar.sourceforge.net]
* MySQL [https://www.mysql.com] or MariaDB [https://mariadb.org] server

The `Makefile` file executes appropriate download scripts, Python and R files which process data. Before you run the code you should register on Drugbank Web site [https://www.drugbank.ca/]. This enables you to download appropriate files from Drugbank. In addition you should install UMLS and SemMedDB. Instructions to install UMLS can be found in the following link [https://www.nlm.nih.gov/research/umls/quickstart.html]. Next, go to SemMedDB site [https://skr3.nlm.nih.gov/SemMedDB/], download `PREDICATION` file and run `sql` script. Note that you should also insert appropriate credentials into `Makefile` (only in `drugbank`, `ndfrt`, and `semmeddb` directories).

## Using the code

First download the code from GitHub repository using the command 
~~~~
git clone https://github.com/akastrin/ddi-prediction.git
~~~~
or by downloading a zipped version and extracting it as usual.

There are two directories in the `home` folder (`ddi-prediction`), namely `df` and `figures`. `db` directory contains the following subdirectories: `drugbank`, `kegg`, `ndfrt`, `semmeddb`, and `twosides`. To reproduce the results of the study you should execute `Makefile` file in each database directory one after another. For example:
~~~~
cd db/drugbank/
make
~~~~

## Reproducing the figures

To reproduce the figures presented in the paper run the following code from the command line:
~~~~
cd figures/
Rscript net_plot.R
Rscript roc_plot.R
Rscript var_imp_plot.R
Rscript hist_plot.R
Rscript hclust_plot.R
~~~~
