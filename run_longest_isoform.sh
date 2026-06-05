#!/bin/bash

GFF_DIR="GFF3"
FAA_DIR="Proteomes"
OUT_DIR="Proteomes_cleaned"

mkdir -p "${OUT_DIR}"

for faa in ${FAA_DIR}/*.faa
do
    species=$(basename "${faa}" .faa)
    gff="${GFF_DIR}/${species}.gff3"

    echo "Processing ${species}"

    python3 longest_isoform.py \
        "${gff}" \
        "${faa}" \
        "${OUT_DIR}/${species}.primary.faa"

done
