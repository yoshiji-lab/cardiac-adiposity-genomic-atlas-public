#!/usr/bin/env bash
set -euo pipefail
source "${1:?Usage: $0 01.config/local.env}"
mkdir -p "${RESULTS_DIR}/regenie_step2"
keep="${WORK_DIR}/sample_qc/keep.samples.txt"
pheno="${WORK_DIR}/phenotypes.processed.tsv"
pred="${WORK_DIR}/regenie_step1/idp_pred.list"
pheno_cols=$(head -n1 "$pheno" | cut -f3- | tr '\t' ',')

for chr in {1..22}; do
  pgen="${WORK_DIR}/variant_qc/chr${chr}.qc"
  "${REGENIE}" --step 2 --qt \
    --pgen "$pgen" \
    --phenoFile "$pheno" --phenoColList "$pheno_cols" \
    --keep "$keep" --pred "$pred" \
    --bsize "${STEP2_BSIZE}" --minMAC "${MIN_MAC}" \
    --threads "${THREADS}" --gz \
    --out "${RESULTS_DIR}/regenie_step2/chr${chr}"
done
