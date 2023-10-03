
## Pull singularity image

if [ ! -e vep105_loftee.sif ]; then
  singularity pull vep105_loftee.sif docker://skoyamamd/vep105_loftee
fi

## Reformat gnomad exome sitevcf

wget https://storage.googleapis.com/gcp-public-data--gnomad/release/2.1.1/vcf/exomes/gnomad.exomes.r2.1.1.sites.21.vcf.bgz

zcat gnomad.exomes.r2.1.1.sites.21.vcf.bgz \
  | grep -v "#" \
  | head -n 1000 \
  | cut -f -5 \
  | sed 's/chr//' \
  | awk -v OFS="\t" '{
    print "chr"$1":"$2":"$4":"$5
  }' \
  | gzip -c > gnomad.exomes.r2.1.1.sites.21.toy_input.txt.gz

rm gnomad.exomes.r2.1.1.sites.21.vcf.bgz

## Test run

bash vep105_loftee.sh \
  vep105_loftee.sif \
  gnomad.exomes.r2.1.1.sites.21.toy_input.txt.gz \
  gnomad.exomes.r2.1.1.sites.21.toy_input
