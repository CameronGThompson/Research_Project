#!/bin/bash

INPUT_ROOT="Sorted_Proteomes"
RESULTS_DIR="Orthofinder_Results"

mkdir -p "${RESULTS_DIR}"

for TAXON_DIR in "${INPUT_ROOT}"/*/
do

    TAXON=$(basename "${TAXON_DIR}")

    NUM=$(find "${TAXON_DIR}" -name "*.faa" | wc -l)

    if [[ "${NUM}" -lt 2 ]]; then
        echo "Skipping ${TAXON} (<2 proteomes)"
        continue
    fi

    echo "Running OrthoFinder on ${TAXON} (${NUM} proteomes)"

    orthofinder \
        -f "${TAXON_DIR}" \
        -o "${RESULTS_DIR}/${TAXON}"

done
