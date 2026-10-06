# Regenerates the annotated genome CSV and the TeX rows file from the committed
# genome JSON.  Run from the repository root: sh script/make_annotated_genome_table.sh
python3 script/make_annotated_genome_table.py \
  data/genome-16005-stint100-root1.json \
  data/annotated-genome-16005-stint100-root1.csv \
  data/annotated-genome-16005-stint100-root1.tex \
  data/knockout-highlighted-sites-16005-stint100-root1.csv
