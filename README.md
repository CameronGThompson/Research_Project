# Cnidarian symbiosis OrthoFinder analysis

Reproducible analysis and report package for identifying candidate genomic
innovations associated with cnidarian–algal endosymbiosis. The repository
connects OrthoFinder comparative-genomics outputs to candidate definition,
profile-HMM absence validation, functional annotation and enrichment,
literature-guided prioritisation, KEGG cross-validation, and a final curated
set of pathway candidates.

## Analysis overview

The dataset contains 15 cnidarian proteomes representing Anthozoa, Scyphozoa
and Hydrozoa, including eight symbiotic and seven non-symbiotic taxa.

1. **OrthoFinder structure:** 442,747 proteins were analysed; 421,353 (95.2%)
   were assigned to 32,438 orthogroups.
2. **Candidate definition:** 2,864 orthogroups occurred in at least one
   symbiotic proteome and no sampled non-symbiotic proteome. Of these, 1,368
   were replicated across at least two symbiotic species and 250 occurred
   across multiple host groups.
3. **Absence validation:** profile-HMM searches retained 1,036 candidates with
   no non-symbiotic hit at the configured thresholds and flagged 1,828 for
   detectable non-symbiotic homologues.
4. **Functional analysis:** InterProScan annotated 17,985 of 19,582 sequences
   in the reported background set (91.8%). Enrichment was tested for the full,
   replicated, cross-lineage and HMM-strict candidate sets.
5. **Pathway prioritisation:** literature-guided GO/InterPro screening and
   BlastKOALA/KEGG cross-validation produced a final report set of 12
   orthogroups: four primary and eight secondary candidates.

These candidates are hypotheses for further study. Database concordance,
phylogenetic distribution and literature relevance do not constitute
experimental validation of a symbiotic function.

## Repository contents

| Path | Contents |
|---|---|
| `config/` | Species metadata, literature-screen rules and final curation manifest |
| `data/orthofinder/` | Compact OrthoFinder statistics, rooted tree and sharing matrices |
| `data/candidates/` | Candidate classifications, membership and HMM-validation summary |
| `data/annotation/` | Candidate annotations and InterProScan run summary |
| `data/enrichment/` | Complete enrichment outputs used in Figure 4 |
| `data/final_candidates/` | Final evidence matrix, summary table and report workbook |
| `data/supplementary/` | Tables S2 and S3 |
| `figures/` | PNG, PDF and SVG versions of report figures |
| `scripts/` | Workflow stages, figure scripts, table builders and validation |
| `hpc/slurm/` | BluePebble/SLURM submission templates for workflow stages 23–25 |
| `docs/` | Workflow, result interpretation, data dictionary and references |

## Quick start

```bash
git clone <repository-url>
cd cnidarian-symbiosis-orthofinder
conda env create -f environment.yml
conda activate cnidarian-symbiosis-orthofinder
python scripts/validate_package.py
```

Rebuild every figure and the final summary table:

```bash
bash scripts/rebuild_figures.sh
python scripts/tables/build_final_candidate_summary.py
```

The precomputed results are included so the reported findings can be inspected
without rerunning OrthoFinder, HMMER, InterProScan or BlastKOALA. Re-running the
complete biological workflow requires the original proteomes and upstream
annotation outputs described in [`docs/workflow.md`](docs/workflow.md).

## Core report outputs

- Species tree: `figures/orthofinder/cnidarian_species_tree_highlighted.png`
- Orthogroup assignment: `figures/orthofinder/orthogroup_assignment_percent_bold_italic.png`
- Candidate distribution and HMM validation: `figures/candidates/figure3_candidate_distribution_validation.png`
- Functional enrichment: `figures/enrichment/Figure_4_functional_enrichment_dotplot.png`
- Final candidate evidence matrix: `figures/final_candidates/Figure_5_final_candidate_evidence_matrix.png`
- Final candidate table: `figures/final_candidates/Table_1_final_candidates_no_role_citations.png`
- Candidate supplement: `data/supplementary/Table_S2_candidate_orthogroups.xlsx`
- Enrichment supplement: `data/supplementary/Table_S3_complete_functional_enrichment.xlsx`

## Reuse and attribution

The original study author and institutional details should be added before
public release. No open-source licence has been selected in this package; add
the licence required by the project or institution before publishing the
repository.

