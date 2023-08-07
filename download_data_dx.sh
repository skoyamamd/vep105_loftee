#!/bin/bash

unset DX_WORKSPACE_ID; \
dx cd $DX_PROJECT_CONTEXT_ID:; \
mkdir vep_data/
dx download /annotation/data/* -o vep_data/
tar xzf vep_data/homo_sapiens_vep_105_grch38.tar.gz -C vep_data
