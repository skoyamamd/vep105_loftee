## VEP 105, LOFTEE

```
bash download_data.sh
docker build -t vep_105_loftee .

vep_cmd="vep \
    --format vcf \
    __OUTPUT_FORMAT_FLAG__ \
    --everything \
    --allele_number \
    --no_stats \
    --offline \
    --cache \
    --assembly GRCh38 \
    --dir_plugins / \
    --plugin dbNSFP,/vep_data/dbNSFP4.3a_grch38.gz,REVEL_score,CADD_phred \
    --plugin LoF,loftee_path:/loftee,human_ancestor_fa:/vep_data/human_ancestor.fa.gz,conservation_file:/vep_data/loftee.sql,gerp_bigwig:/vep_data/gerp_conservation_scores.homo_sapiens.GRCh38.bw"

docker run -v $(pwd)/vep_data:/vep_data/ \
           -v $(pwd)/variant_data:/variant_data/ \
           -it vep_105_loftee $vep_cmd
```
