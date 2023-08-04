#!/bin/bash

unset DX_WORKSPACE_ID; \
dx cd $DX_PROJECT_CONTEXT_ID:; \
mkdir vep_data/
dx download /annotation/data/* -o vep_data/
