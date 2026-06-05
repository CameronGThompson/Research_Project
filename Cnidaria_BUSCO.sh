#!/bin/bash

GENOME_DIR=Genomes
OUT_DIR=BUSCO_Results
LINEAGE=metazoa_odb10

mkdir -p "$OUT_DIR"

for genome in Genomes/*.fna
do
    echo "Running BUSCO on $genome"

    name=$(basename "$genome" .fna)

    busco \
        -i "$genome" \
        -m genome \
        -l metazoa_odb12 \
        -o "$name" \
        --out_path BUSCO_Results \
        -c 4
done


