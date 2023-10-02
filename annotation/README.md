[Script usage]

bash vep105_loftee.sh \
  SINGULARITY_IMAGE \
  INPUT_FILE \
  OUTPUT_HEADER

[Arguments configuration]

SINGULARITY_IMAGE

SINGULARITY_IMAGE should be the path to the singularity image pulled from docker hub
to pull image

```singularity pull vep105_loftee.sif docker://skoyamamd/vep105_loftee```

INPUT_FILE

INPUT_FILE containes one column SNPIDs and gzipped by gzip or bgzip

chr1:11111:A:C
chr2:22222:G:T
chr3:333333:GT:A
(assuming chromosome:position:reference-allele:alternate-allele on hg38)

OUTPUT_HEADER

OUTPUT_HEADER could be any string for your output. The script generate temoporary filee named OUTPUT_HEADER.vep_annot_tmp.* (will be automatically removed) and output file named OUTPUT_HEADER.vep_annot.tsv.gz

