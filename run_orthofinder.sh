#!/bin/bash

# Load OrthoFinder module + depencies

module load openmpi/5.0.3-et6p
module load orthofinder/2.5.5-openblas-ynxm


#!/bin/bash

# Base directories
PROTEOME_DIR="Final_Proteomes"
WORK_DIR="Orthofinder_Input"
RESULTS_DIR="Orthofinder_Results"

mkdir -p "${WORK_DIR}"
mkdir -p "${RESULTS_DIR}"

# Loop through each class directory
for CLASS_DIR in "${PROTEOME_DIR}"/*/; do

    CLASS=$(basename "${CLASS_DIR}")

    echo "================================="
    echo "Processing ${CLASS}"
    echo "================================="

    INPUT_DIR="${WORK_DIR}/${CLASS}"

    # Remove any old input directory
    rm -rf "${INPUT_DIR}"
    mkdir -p "${INPUT_DIR}"

    # Copy all FAA files from symbiotic and non-symbiotic folders
    find "${CLASS_DIR}" \
        -type f \
        -name "*.faa" \
        -exec ln -s "$(realpath {})" "${INPUT_DIR}/" \;

    NUM_FILES=$(find "${INPUT_DIR}" -name "*.faa" | wc -l)

    echo "Found ${NUM_FILES} proteomes"

    if [ "${NUM_FILES}" -lt 2 ]; then
        echo "Skipping ${CLASS}: fewer than 2 proteomes"
        continue
    fi

    echo "Running OrthoFinder for ${CLASS}"

    orthofinder \
        -f "${INPUT_DIR}" \
        -o "${RESULTS_DIR}/${CLASS}"

    echo "${CLASS} complete"
    echo

done

echo "All analyses complete."
