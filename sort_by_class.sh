#!/bin/bash

# Input files
METADATA="metadata.tsv"
PROTEOME_DIR="Proteomes"

# Output directory structure
OUTPUT_DIR="Sorted_Proteomes"

mkdir -p "${OUTPUT_DIR}"

# Skip header line
tail -n +2 "${METADATA}" | while IFS=$'\t' read -r FILENAME SPECIES CLASS SUBCLASS
do

    # Choose whether to sort by class or subclass
    TAXON="${CLASS}"

    DEST_DIR="${OUTPUT_DIR}/${TAXON}"

    mkdir -p "${DEST_DIR}"

    SOURCE_FILE="${PROTEOME_DIR}/${FILENAME}"

    if [[ -f "${SOURCE_FILE}" ]]; then

        # Symlink (preferred)
        ln -sf "$(realpath "${SOURCE_FILE}")" \
               "${DEST_DIR}/${FILENAME}"

        echo "Placed ${FILENAME} -> ${TAXON}"

    else
        echo "WARNING: ${SOURCE_FILE} not found"
    fi

done
