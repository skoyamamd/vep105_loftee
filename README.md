## VEP 105, LOFTEE

*This repo is part 1 of the full BRaVa annotation pipeline - instructions for the full pipeline - [variant annotation repo](https://github.com/BRaVa-genetics/variant-annotation)*


Annotate your variant sites using VEP, ready for processing into SAIGE group files.

### Docker

```
# Download all required resources into resources/ - maybe take a while, many GB!
bash download_data.sh

# Pull docker image built from the Dockerfile in this repo
docker pull ghcr.io/brava-genetics/vep105_loftee:main

chr=21

cmd="vep -i resources/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf \
         --vcf
         --format vcf \
         --cache \
         --dir_cache resources/ \
         -o out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf \
         --plugin LoF,loftee_path:/opt/micromamba/share/ensembl-vep-105.0-1,human_ancestor_fa:resources/human_ancestor.fa.gz,conservation_file:resources/loftee.sql,gerp_bigwig:resources/gerp_conservation_scores.homo_sapiens.GRCh38.bw \
         --plugin dbNSFP,resources/dbNSFP4.3a_grch38.gz,REVEL_score,CADD_phred \
         --everything \
         --force_overwrite \
         --offline"

docker run -v $(pwd):/$HOME/ \
           -it vep_105_loftee $vep_cmd
```

### Singularity

```
# Download all required resources into resources/ - maybe take a while, many GB!
bash download_data.sh

# Pull docker image built from the Dockerfile in this repo and convert to a singularity.sif
singularity pull --docker-login -disable-cache "resources/vep.sif" "docker://ghcr.io/brava-genetics/vep105_loftee:main"

chr=21

cmd="vep -i resources/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf \
         --vcf
         --format vcf \
         --cache \
         --dir_cache resources/ \
         -o out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf \
         --plugin LoF,loftee_path:/opt/micromamba/share/ensembl-vep-105.0-1,human_ancestor_fa:resources/human_ancestor.fa.gz,conservation_file:resources/loftee.sql,gerp_bigwig:resources/gerp_conservation_scores.homo_sapiens.GRCh38.bw \
         --plugin dbNSFP,resources/dbNSFP4.3a_grch38.gz,REVEL_score,CADD_phred \
         --everything \
         --force_overwrite \
         --offline"

singularity exec \
      --bind $(pwd):$HOME/ \
      "resources/vep.sif" $cmd
```

### Post-processing

Now we need to select the "worst consequence by gene, canonical" variant annotations. We reccomend using the bcftools vep-split plugin:

```
chr=21

bcftools +split-vep ukb_wes_450k.qced.chr${chr}_vep_output_head.vcf.gz -s worst -s primary -f '%CHROM:%POS:%REF:%ALT %Gene %LoF %MAX_AF %REVEL_score %CADD_phred %Consequence\n' -o ukb_wes_450k.qced.${chr}.worst_csq_by_gene_canonical.txt

sed '1i SNP_ID GENE LOF MAX_AF REVEL_SCORE CADD_PHRED CSQ' ukb_wes_450k.qced.chr${chr}.worst_csq_by_gene_canonical.txt
```
