#!/bin/bash

# Download VEP cache
curl -SL https://ftp.ensembl.org/pub/release-105/variation/indexed_vep_cache/homo_sapiens_vep_105_GRCh38.tar.gz -o vep_data/homo_sapiens_vep_105_GRCh38.tar.gz

# Download necessary files for LOFTEE
mkdir -p vep_data && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/loftee.sql.gz -o vep_data/loftee.sql.gz && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz -o vep_data/human_ancestor.fa.gz && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz.fai -o vep_data/human_ancestor.fa.gz.fai && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz.gzi -o vep_data/human_ancestor.fa.gz.gzi && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/gerp_conservation_scores.homo_sapiens.GRCh38.bw -o vep_data/gerp_conservation_scores.homo_sapiens.GRCh38.bw

# Download dbNSFP
curl -SL https://dbnsfp.s3.amazonaws.com/dbNSFP4.3a.zip -o vep_data/dbNSFP4.3a.zip
