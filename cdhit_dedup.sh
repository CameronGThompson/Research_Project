#!/bin/bash

INPUT_DIR="Proteomes_cleaned"
OUTPUT_DIR="Proteomes_dedup"
CDHIT="/user/work/iy21106/Research_Project/Analysis_Pipeline/Quality_Analysis/CDHit/cd-hit-v4.8.1-2019-0228/cd-hit"

mkdir -p "${OUTPUT_DIR}"


for faa in ${INPUT_DIR}/*.faa
do
    species=$(basename "${faa}" .faa)

    echo "Processing ${species}"

    $CDHIT \
        -i "${faa}" \
        -o "${OUTPUT_DIR}/${species}.dedup.faa" \
        -c 1.0 \
        -n 5 \
        -T 16 \
        -M 0

done

echo "Finished"
