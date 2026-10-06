# Regenerates the annotated genome TSV from the committed genome JSON.
# Run from the repository root: sh script/make_annotated_genome_table.sh
python3 script/make_annotated_genome_table.py \
  data/genome-16005-stint100-highestroot.json \
  data/annotated-genome-16005-stint100-highestroot.tsv
