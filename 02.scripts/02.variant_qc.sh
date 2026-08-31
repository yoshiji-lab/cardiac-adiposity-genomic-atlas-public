#!/usr/bin/env bash
set -euo pipefail
source "${1:?Usage: $0 01.config/local.env}"
mkdir -p "${WORK_DIR}/variant_qc"

keep="${WORK_DIR}/sample_qc/keep.samples.txt"
[[ -s "$keep" ]] || { echo "Missing sample keep file: $keep" >&2; exit 1; }

for chr in {1..22}; do
  in_prefix="${PGEN_PATTERN/\{CHR\}/${chr}}"
  out="${WORK_DIR}/variant_qc/chr${chr}.qc"

  "${PLINK2}" \
    --pfile "${in_prefix}" \
    --keep "${keep}" \
    --snps-only just-acgt \
    --max-alleles 2 \
    --mac "${MIN_MAC}" \
    --geno 0.02 \
    --hwe 1e-6 0.001 midp \
    --make-pgen --no-pheno \
    --threads "${THREADS}" \
    --out "${out}"
done
