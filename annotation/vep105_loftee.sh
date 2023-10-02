## Arguments

export singularity_image=$1
export input_file=$2
export output_header=$3

## Convert SNP file to VCF

zcat ${input_file} \
  | sed 's/chr//' \
  | awk -v OFS="\t" '{
    split($1,arr,":"); print arr[1],arr[2],$1,arr[3],arr[4],".",".","."
  }' \
  | sed '1s/^/#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\n/' \
  | gzip -c > ${output_header}.vep_annot_tmp.input.vcf.gz

## VEP configuration

loftee_path=loftee_path:/opt/micromamba/share/ensembl-vep-105.0-1
human_ancestor_fa=human_ancestor_fa:/data/human_ancestor.fa.gz
conservation_file=conservation_file:/data/loftee.sql
gerp_bigwig=gerp_bigwig:/data/gerp_conservation_scores.homo_sapiens.GRCh38.bw
dbNSFP=/data/dbNSFP4.3a.thin.txt.gz,REVEL_score,CADD_phred
popmax=/data/gnomad.exomes.r2.1.1.sites.liftover_grch38_popmax_0.01.tsv.bgz

## VEP annotation

singularity exec --bind $(pwd):$(pwd) ${singularity_image} \
  vep \
    -i ${output_header}.vep_annot_tmp.input.vcf.gz \
    -o ${output_header}.vep_annot_tmp.vep.vcf \
    --assembly GRCh38 \
    --vcf \
    --format vcf \
    --everything \
    --force_overwrite \
    --cache \
    --offline \
    --dir_cache /data/ \
    --plugin LoF,${loftee_path},${human_ancestor_fa},${conservation_file},${gerp_bigwig} \
    --plugin dbNSFP,${dbNSFP}

## Index

singularity exec --bind $(pwd):$(pwd) ${singularity_image} \
  bgzip -f ${output_header}.vep_annot_tmp.vep.vcf

singularity exec --bind $(pwd):$(pwd) ${singularity_image} \
  tabix -f -s 1 -b 2 -e 2 ${output_header}.vep_annot_tmp.vep.vcf.gz

## Popmax filter

singularity exec --bind $(pwd):$(pwd) ${singularity_image} \
  bcftools view \
    -i'ID!=@/data/gnomad.exomes.r2.1.1.sites.liftover_grch38_popmax_0.01.tsv.bgz' \
    ${output_header}.vep_annot_tmp.vep.vcf.gz \
    -o ${output_header}.vep_annot_tmp.vep.popmax001.vcf.gz

## Process output

singularity exec --bind $(pwd):$(pwd) ${singularity_image} \
  bcftools +split-vep \
    ${output_header}.vep_annot_tmp.vep.popmax001.vcf.gz \
    -d \
    -f '%CHROM:%POS:%REF:%ALT %Gene %LoF %REVEL_score %CADD_phred %Consequence %Feature %MANE_SELECT %CANONICAL %BIOTYPE\n' \
    | sed '1s/^/SNP_ID GENE LOF REVEL_SCORE CADD_PHRED CSQ TRANSCRIPT MANE_SELECT CANONICAL BIOTYPE\n/' \
    | tr " " "\t" \
    | gzip -c > ${output_header}.vep_annot.tsv.gz

rm ${output_header}.vep_annot_tmp.*

