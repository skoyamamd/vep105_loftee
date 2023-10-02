# VEP105 LoFTEE Script Syntax & Usage

A script to use VEP105 and LoFTEE for annotating genetic variants using a Singularity container.

## Table of Contents
- [Script Syntax](#script-syntax)
- [Arguments](#arguments)
  - [SINGULARITY_IMAGE](#singularity_image)
  - [INPUT_FILE](#input_file)
  - [OUTPUT_HEADER](#output_header)
- [Example Usage](#example-usage)

## Script Syntax

Execute the script using the following syntax:

```bash
bash vep105_loftee.sh \
  [SINGULARITY_IMAGE] \
  [INPUT_FILE] \
  [OUTPUT_HEADER]
```
Note: Replace `[ARGUMENT]` with the actual values for your use case.

## Arguments

### SINGULARITY_IMAGE

`SINGULARITY_IMAGE` should be a Singularity image pulled from Docker Hub.

#### How to Pull the Image

Use the following command to pull the Singularity image:

```bash
singularity pull vep105_loftee.sif docker://skoyamamd/vep105_loftee
```

### INPUT_FILE

`INPUT_FILE` should be a gzipped text file that contains a single column of SNPIDs, formatted as follows:

```
chromosome:position:reference-allele:alternate-allele
```

#### Example Input

```plaintext
chr1:11111:A:C
chr2:22222:G:T
chr3:333333:GT:A
```
(Note: The above examples assume usage of the hg38 human genome reference.)

### OUTPUT_HEADER

`OUTPUT_HEADER` is a user-defined string utilized in naming the output and temporary files. 

- Temporary files: The script generates temporary files with the following naming convention and these will be automatically removed after the script run:

```plaintext
[OUTPUT_HEADER].vep_annot_tmp.*
```

- Output file: The final output file will be named as follows:

```plaintext
[OUTPUT_HEADER].vep_annot.tsv.gz
```

## Example Usage

Here is a basic example to illustrate how to use the script with specified arguments:

```bash
bash vep105_loftee.sh \
  vep105_loftee.sif \
  example_input.gz \
  example_output_header
```
