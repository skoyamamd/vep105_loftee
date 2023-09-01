import hail as hl
hl.init()

# This script shows how the gnomad.exomes.r2.1.1.sites.liftover_grch38_popmax_0.01.tsv.bgz in this 
# directory was generated from gnomAD hail tables. Note that we have gone this route to ensure 
# consistency in variant restriction via gnomAD and because of previous issues of ensembl VEP
# gnomAD AF annotations giving strange results in the past (flagged by Konrad Karzcewski).

# Download the gnomad exomes hail table:
# gsutil -m cp -R gs://gcp-public-data--gnomad/release/2.1.1/liftover_grch38/ht/exomes/gnomad.exomes.r2.1.1.sites.liftover_grch38.ht ./
# Note that this require installation of gsutil:
# https://cloud.google.com/storage/docs/gsutil_install

ht = hl.read_table("gnomad.exomes.r2.1.1.sites.liftover_grch38.ht")
# Restrict to variants in gnomAD with allele frequency > 0.01.
ht = ht.filter((ht.popmax[0].AF > 0.01) & (hl.len(ht.filters) == 0))
ht = ht.annotate(
	variant = hl.str(":").join([ht.locus.contig, hl.str(ht.locus.position), ht.alleles[0], ht.alleles[1]])
)
ht = ht.key_by()
ht = ht.select(ht.variant)
ht.export('gnomad.exomes.r2.1.1.sites.liftover_grch38_popmax_0.01.tsv.bgz', header=False)
