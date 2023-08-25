# VEP version 105 with LOFTEE v1.04_GRCh38 containers

*This repository is [part 1](https://github.com/BRaVa-genetics/variant-annotation#1-run-vep-version-105-with-loftee-v104_grch38) of the full BRaVa annotation pipeline. Instructions for the full pipeline are [here](https://github.com/BRaVa-genetics/variant-annotation).*

Annotate your variant sites using VEP, ready for processing into SAIGE annotation group files.

## Docker
Download all required resources into vep_data/. This might take a while, are these files are quite large (many GB)!
```
bash download_data.sh
```
Pull the docker image built from the Dockerfile in this repository:
```
docker pull ghcr.io/brava-genetics/vep105_loftee:main
```
VEP annotate your VCF files. Below is an example, annotating chromosome 21 in UK Biobank data. Go ahead and replace `resources/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf` and `out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf` with the relevant input file and desired output filename, respectively to annotate your VCFs.
```
chr=21
cmd="vep -i vep_data/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf \
         --assembly GRCh38 \
         --vcf \
         --format vcf \
         --cache \
         --dir_cache vep_data/ \
         -o out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf \
         --plugin LoF,loftee_path:/opt/micromamba/share/ensembl-vep-105.0-1,human_ancestor_fa:vep_data/human_ancestor.fa.gz,conservation_file:vep_data/loftee.sql,gerp_bigwig:vep_data/gerp_conservation_scores.homo_sapiens.GRCh38.bw \
         --plugin dbNSFP,vep_data/dbNSFP4.3a_grch38.gz,REVEL_score,CADD_phred \
         --everything \
         --force_overwrite \
         --offline"

docker run -v $(pwd):/$HOME/ -it vep_105_loftee $cmd
```
Note that in order for the docker container to "see" the files required for VEP annotation, you will need to mount the directory containing the required resources and the VCF to be annotated. This is what `-v $(pwd):/$HOME/` is doing. If your VCF file to be annotated is located somewhere else, you will also need to mount the directory that it sits in, or move it to the current working directory (or any subfolder within the working directory) if you're using the above code as a template. `-it` runs our vep_105_loftee docker as an interactive process (like a shell), running the vep command (which we store as the variable `cmd`.

## Singularity
Download all required resources into vep_data/. This might take a while, are these files are quite large (many GB)!
```
bash download_data.sh
```
Pull docker image built from the Dockerfile in this repo and convert to a singularity.sif
```
singularity pull --docker-login -disable-cache "vep_data/vep.sif" "docker://ghcr.io/brava-genetics/vep105_loftee:main"
```
VEP annotate your VCF files. Below is an example, annotating chromosome 21 in UK Biobank data. Go ahead and replace `resources/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf` and `out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf` with the relevant input file and desired output filename, respectively to annotate your VCFs.
```
chr=21
cmd="vep -i vep_data/ukb_450k_wes/ukb_wes_450k.qced.chr${chr}.vcf \
         --assembly GRCh38 \
         --vcf
         --format vcf \
         --cache \
         --dir_cache vep_data/ \
         -o out/ukb_wes_450k.qced.chr${chr}_vep_output.vcf \
         --plugin LoF,loftee_path:/opt/micromamba/share/ensembl-vep-105.0-1,human_ancestor_fa:vep_data/human_ancestor.fa.gz,conservation_file:vep_data/loftee.sql,gerp_bigwig:vep_data/gerp_conservation_scores.homo_sapiens.GRCh38.bw \
         --plugin dbNSFP,vep_data/dbNSFP4.3a_grch38.gz,REVEL_score,CADD_phred \
         --everything \
         --force_overwrite \
         --offline"

singularity exec --bind $(pwd):$HOME/ "vep_data/vep.sif" $cmd
```
As with docker, in order for our singularity container to "see" the files required for VEP annotation, you will need to mount the directory containing the required resources and the VCF to be annotated. This is what `--bind $(pwd):$HOME/` is doing. If your VCF file to be annotated is located somewhere else, you will also need to mount the directory that it sits in, or move it to the current working directory (or any subfolder within the working directory) if you're using the above code as a template. `exec` executes the command `cmd` (our VEP command) within the singularity container `vep.sif` that we've created.

## Post-processing

Now we need to select the "worst consequence by gene, canonical" variant annotations. To munge the data into a format to carry this out easily (with our python code in [SAIGE-annotations-for-BRaVa](https://github.com/BRaVa-genetics/SAIGE-annotations-for-BRaVa), we use the BCFtools vep-split plugin. If you don't have BCFtools (we'd be surprised though), go ahead and install it following the instructions [here](https://samtools.github.io/bcftools/howtos/install.html). In order to use the BCFtools plugins, the environment variable `BCFTOOLS_PLUGIN` must be set and point to the correct location:

```
export BCFTOOLS_PLUGINS=/path/to/bcftools/plugins
```

(replacing `/path/to/bcftools/plugins` with the path to your BCFtools plugins folder). It may already be set within your compute environment, so make sure to check that first!

```
bgzip out/ukb_wes_450k.qced.chr${chr}.vep.vcf
tabix out/ukb_wes_450k.qced.chr${chr}.vep.vcf.gz

bcftools +split-vep out/ukb_wes_450k.qced.chr${chr}.vep.vcf.gz -d -f '%CHROM:%POS:%REF:%ALT %Gene %LoF %MAX_AF %REVEL_score %CADD_phred %Consequence %Feature %MANE_SELECT %CANONICAL %BIOTYPE\n' -o out/ukb_wes_450k.qced.chr${chr}.vep_processed.txt
sed -i '1i SNP_ID GENE LOF MAX_AF REVEL_SCORE CADD_PHRED CSQ TRANSCRIPT MANE_SELECT CANONICAL BIOTYPE' out/ukb_wes_450k.qced.chr${chr}.vep_processed.txt```
```
The above command simply splits multiple transcript annotations for a given variant across multiple lines and then grabs a subset of columns that we need to define our annotations for the SAIGE group files, and gives them some nice names.
