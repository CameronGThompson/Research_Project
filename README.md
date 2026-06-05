# Research_Project
This is a collection of scripts used in my Masters research project. It was a comparative genomic analysis of symbiotic and aposymbiotic Cnidarians, aiming to identify genomic innovations involved in the successful establishment and maintenance of Cnidarian-algal symbioses.

## Scripts

This repository contains the following scripts:
  * `Cnidaria_BUSCO.sh`
  * `longest_isoform.py`
  * `run_longest_isoform.sh`
  * `cdhit_dedup.sh`
  * `run_orthofinder.sh`
  * `sort_by_class.sh`
  * `run_orthofinder2.sh`

Below, I will go into more detail on each of these scripts. Scripts are listed in the order in which they should be run.

## Cnidaria_BUSCO.sh

### Purpose 

Runs BUSCO on a collection of genome assemblies to assess genome completeness using conserved single-copy orthologs.

### What it does

  * Iterates through a directory of genome assemblies.
  * Runs BUSCO on each genomes.
  * Generates completeness statistics including:
      * Complete BUSCOs
      * Single-copy BUSCOs
      * Duplicated BUSCOs
      * Fragmented BUSCOs
      * Missing BUSCOs
  * Stores BUSCO output for downstream quality assessment.

### Why it is necessary

Before comparative genomics analyses, genome quality should be evaluated to ensure assemblies are sufficiently complete. BUSCO provides a standardised measure of assembly completeness and helps identify genomes that may need to be excluded from downstream analyses.

### Required directory structure

***Input:***

Genomes/

|-- Species_A.fna

|-- Species_B.fna

|-- Species_C.fna

***Output:***

BUSCO_Results/

|-- Species_A/

|-- Species_B/

|-- Species_C/

### Dependencies

  * BUSCO (v5+ recommended)
  * Python 3
  * HMMER
  * Miniprot/Augustus (depending on BUSCO mode)
  * Appropriate BUSCO lineage dataset (e.g. metazoa_odb12)

## longest_isoform.py

### Purpose

To be run within the following `run_longest_isoform.sh` script, not independently. Extracts the longest protein isoform for each gene from annotated proteomes.

### What it does

  * Reads a protein FASTA file and corresponding GFF3 annotation file.
  * Groups transcripts by gene.
  * Identifies the longest protein isoform associated with each gene.
  * Produces a filtered proteome containing only one representative protein per gene.

### Why it is necessary

Many genome annotations contain multiple transcript isoforms per gene. Orthology tools such as OrthoFinder generally perform best when supplied with a single representative protein per gene. Selecting the longest isoform:

  * Reduces redundancy.
  * Prevents inflation of orthogroup counts.
  * Simplifies downstream comparative analyses.

### Required directory strucutre

***Input:***

Genome_Annotations/

|-- Species_A/

|   |-- Species_A.gff3

|   |--- Species_A.faa

|-- Species_B/

|   |-- Species_B.gff3

|   |-- Species_B.faa

***Output:***

Longest_Isoforms/

|-- Species_A_longest.faa

|-- Species_B_longest.faa

### Dependencies

  * Python 3
  * Biopython

## run_longest_isoform.sh

### Purpose

Automates execution of `longest_isoform.py` across multiple species.

### What it does

  * Iterates through annotation diretories.
  * Identifies matching protein and GFF3 files.
  * Executes `longest_isoform.p` for each species.
  * Organises outputs into a central directory.

### Why it is necessary

Running longest isoform extraction manually for dozens or hundreds of genomes is time-consuming and prone to error. This script standardises processing and ensures all proteomes are handles consistently.

### Require directory structure

***Input:***

Genome_Annotations/

|-- Species_A/

|   |-- Species_A.gff3

|   |-- Species_A.faa

|-- Species_B/

|   |-- Species_B.gff3

|   |-- Species_B.faa

***Output:***

Longest_Isoforms/

|-- Species_A_longest.faa

|-- Species_B_longest.faa

### Dependencies

  * Bash
  * Python 3
  * Biopython
  * `longest_isoform.p`

## cdhit_dedup.sh

### Purpose

Removes redundant protein sequences from predicted proteomes using CD-HIT.

### What it does

  * Processess all protein FASTA files (.faa) within a specified directory.
  * Clusters highly similar sequences using CD-HIT.
  * Retains representative sequences from each cluster.
  * Produces non-redundant proteomes for downstream analyses.

### Why it is necessary

Protein predictions pipelines frequently generate duplicate or highly similar sequences. Removing redundancy:

  * Reduces computational requirements.
  * Improves orthology inference.
  * Minimises bias during comparative analyses.

### Required directory structure

***Input:***

Proteomes/

|-- Species_A.faa

|-- Species_B.faa

|-- Species_C.faa

***Output:***

CDHIT_Output/

|-- Species_A_dedup.faa

|-- Species_B_dedup.faa

|-- Species_C_dedup.faa

### Dependencies

  * CD-HIT
  * BASH shell

## run_orthofinder.sh

### Purpose

Runs OrthoFinder on groups of species organised by taxonomic class.

### What it does

  * Traverses a directory containing class-level proteome datasets.
  * Identifies valid classes containing at least two species.
  * Runs OrthoFinder independently on each class.
  * Stores orthology results for each taxonomic group.

### Why it is necessary

Running OrthoFinder separately on each class:

  * Reduces computational requirements.
  * Improves orthology inference amon closely related species.
  * Enables class-specific comparative genomic analyses.

### Required directory structure

***Input:***

Final_Proteomes/

|-- Corals/

|   |-- Symbiotic/

|   |   |-- Species_A.faa

|   |   |-- Species_B.faa

|   |-- Non_Symbiotic/

|      |-- Species_C.faa

|       |-- Species_D.faa

|-- Hydra/

|   |-- Symbiotic/

|   |-- Non_Symbiotic/

***Output:***

Orthofinder_Results/

|-- Anthozoa/

|-- Hydrozoa/

|-- Scyphozoa/

### Dependencies

  * OrthoFinder
  * DIAMOND (recommended)
  * Python 3
  * FastTree and/or IQTREE (depending on OrthoFinder configuration)
  * Bash

## sort_by_class.sh

### Purpose 

THis script automatically sorts protein FASTA files into taxonomic groups using a metadata file. It prepares proteome datasets for downstream comprative genomic analyses such as OrthoFinder.

### What it does

 * Reads a tab-delimited metadata file containing file names and taxonomy.
 * Creates a directory structure based on a chosen taxonomic rank (e.g. Class or Subclass).
 * Organises proteomes into these directories using symbolic links (not copies).
 * Flags missing files with warnings.

### Why it is necessary

Large comparative genomics datasets often containg many species that must be grouped logically before analysis. Manually sorting hundreds of proteomes is error-prone and time-consuming.

This script ensures:

 * Consistent grouping across analyses.
 * Reproducibility of dataset structure.
 * Efficient handling of large datasets without duplicating files.
 * Flexibility to regourp datasets at different taxonomic levels.

### Required directory structure

All proteomes should be stored in a single directory. This directory should also include the .tsv metadata file.

The metadata file (TSV format) should contain the following column headers:

 * `filename`
 * `species` (the full latin name)
 * `class`
 * `subclass`

Each directory contains symbolic links to proteomes belonging to that taxonomic group.

### Dependencies

 * BASH
 * GNU core utilities (`awk`, `sed`, `ln`, `mkdir`, `find`)
 * Unix-like environment (Linux or HPC system recommended)

## run_orthofinder2.sh

### Purpose

This script is a modified version of my `run_orthofinder.sh` script, and runs OrthoFinder independently on each taxonomic group created by the `sort_by_class.sh` script, enabling controlled comparative genomics within defined evolutionary groups.

### What it does

 * Iterates through each taxonomic directory.
 * Counts available proteomes in each group.
 * Skips groups with fewer than two proteomes.
 * Runs OrthoFinder separately for each valid group.
 * Store results in a structured output directory.

### Why it is necessary

Running OrthoFinder across all species simultaneously can produce overly complex orthogroup structures when taxa are highly divergent.

This grouped approach:

 * Reduces noise from deep evolutionary divergence.
 * Improves biological interpretability or orthogroups.
 * Enables targeted comparisons (e.g. symbiotic vs non-symbiotic within classes).
 * Reduces computational load per analysis.

### Required directory structure

***Input (from sorting script):***

Final_Proteomes/ 

|-- Anthozoa/ 

| |-- species1.faa 

| |-- species2.faa 

| |-- ... 

|-- Hydrozoa/ 

|-- Scyphozoa/

Each directory must contain at least two proteomes.

***Output:***

Orthofinder_Results/

|-- Anthozoa/

|-- Hydrozoa/

|-- Scyphozoa/

Each folder contains full OrthoFinder outputs including:

 * Orthogroups
 * Gene trees
 * Species tree
 * Orthologue tables

### Dependencies

 * OrthoFinder (v2.5+ recommended)
 * Python
 * DIAMOND or BLAST (depending on OrthoFinder configuration)
 * Bash
 * Sufficient RAM and CPU resources for protein clustering.
