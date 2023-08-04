#!/bin/bash

# Download necessary files for LOFTEE
mkdir -p /loftee_data && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/loftee.sql.gz -o /loftee_data/loftee.sql.gz && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz -o /loftee_data/human_ancestor.fa.gz && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz.fai -o /loftee_data/human_ancestor.fa.gz.fai && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/human_ancestor.fa.gz.gzi -o /loftee_data/human_ancestor.fa.gz.gzi && \
curl -SL https://personal.broadinstitute.org/konradk/loftee_data/GRCh38/gerp_conservation_scores.homo_sapiens.GRCh38.bw -o /loftee_data/gerp_conservation_scores.homo_sapiens.GRCh38.bw

# Download dbNSFP
curl -SL https://dbnsfp.s3.amazonaws.com/dbNSFP4.3a.zip -o dbNSFP4.3a.zip

