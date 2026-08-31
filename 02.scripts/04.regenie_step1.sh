#!/usr/bin/env bash
set -euo pipefail
source "${1:?Usage: $0 01.config/local.env}"
mkdir -p "${WORK_DIR}/regenie_step1/panels"

keep="${WORK_DIR}/sample_qc/keep.samples.txt"
pheno="${WORK_DIR}/phenotypes.processed.tsv"
merge_list="${WORK_DIR}/regenie_step1/pmerge.list"
: > "$merge_list"

for chr in {1..22}; do
  in_prefix="${PGEN_PATTERN/\{CHR\}/${chr}}"
  prune="${WORK_DIR}/regenie_step1/panels/chr${chr}.prune"
  panel="${WORK_DIR}/regenie_step1/panels/chr${chr}.step1"

  "${PLINK2}" --pfile "$in_prefix" --keep "$keep" \
    --snps-only just-acgt --max-alleles 2 \
    --maf 0.01 --geno 0.01 --hwe 1e-6 0.001 midp \
    --indep-pairwise 1000 200 0.2 \
    --threads "${THREADS}" --out "$prune"

  "${PLINK2}" --pfile "$in_prefix" --keep "$keep" \
    --extract "${prune}.prune.in" --make-pgen --no-pheno \
    --threads "${THREADS}" --out "$panel"

  printf "%s.pgen %s.pvar %s.psam\n" "$panel" "$panel" "$panel" >> "$merge_list"
done

"${PLINK2}" --pmerge-list "$merge_list" pfile --make-pgen \
  --out "${WORK_DIR}/regenie_step1/genome.step1"

pheno_cols=$(head -n1 "$pheno" | cut -f3- | tr '\t' ',')
"${REGENIE}" --step 1 --qt \
  --pgen "${WORK_DIR}/regenie_step1/genome.step1" \
  --phenoFile "$pheno" --phenoColList "$pheno_cols" \
  --keep "$keep" --bsize "${STEP1_BSIZE}" \
  --loocv --lowmem --gz --threads "${THREADS}" \
  --out "${WORK_DIR}/regenie_step1/idp"
