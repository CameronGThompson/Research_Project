#!/usr/bin/env python3

import sys
from collections import defaultdict
from Bio import SeqIO

gff3_file = sys.argv[1]
faa_file  = sys.argv[2]
out_file  = sys.argv[3]

# protein length lookup
protein_seqs = SeqIO.to_dict(SeqIO.parse(faa_file, "fasta"))

# gene -> best protein
best_protein = {}
best_length = defaultdict(int)

def parse_attributes(attr_string):
    attrs = {}
    for item in attr_string.strip().split(";"):
        if "=" in item:
            k, v = item.split("=", 1)
            attrs[k] = v
    return attrs

# STEP 1: map transcript/protein → gene
transcript_to_gene = {}

with open(gff3_file) as gff:
    for line in gff:
        if line.startswith("#"):
            continue
        parts = line.strip().split("\t")
        if len(parts) < 9:
            continue

        feature_type = parts[2]
        attrs = parse_attributes(parts[8])

        # Ensembl style
        if feature_type in ["mRNA", "transcript"]:
            if "ID" in attrs and "Parent" in attrs:
                transcript_to_gene[attrs["ID"]] = attrs["Parent"]

        # NCBI style
        if feature_type == "CDS":
            if "protein_id" in attrs and "gene" in attrs:
                transcript_to_gene[attrs["protein_id"]] = attrs["gene"]

# STEP 2: assign proteins to genes
for prot_id, record in protein_seqs.items():

    # try direct match
    gene_id = None

    if prot_id in transcript_to_gene:
        gene_id = transcript_to_gene[prot_id]
    else:
        # fallback: sometimes protein ID is embedded
        gene_id = prot_id.split(".")[0]

    length = len(record.seq)

    if length > best_length[gene_id]:
        best_length[gene_id] = length
        best_protein[gene_id] = record

# STEP 3: write output
SeqIO.write(best_protein.values(), out_file, "fasta")
