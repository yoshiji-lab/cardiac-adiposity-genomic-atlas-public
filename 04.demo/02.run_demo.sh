#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
demo_dir="${repo_root}/04.demo"
out_dir="${demo_dir}/output"
mkdir -p "${out_dir}"

env_file="${out_dir}/demo.env"
{
  printf 'DATA_DIR=%s\n' "${demo_dir}"
  printf 'WORK_DIR=%s\n' "${out_dir}"
  printf 'RESULTS_DIR=%s\n' "${out_dir}/results"
  printf 'PGEN_PATTERN=%s\n' "${demo_dir}/simulated_chr{CHR}"
  printf 'SAMPLE_TABLE=%s\n' "${demo_dir}/03.simulated_samples.tsv"
  printf 'PHENO_COVAR_FILE=%s\n' "${demo_dir}/04.simulated_idp_covariates.tsv"
  printf 'PLINK2=plink2\n'
  printf 'REGENIE=regenie\n'
  printf 'THREADS=1\n'
  printf 'MIN_MAC=20\n'
  printf 'STEP1_BSIZE=1000\n'
  printf 'STEP2_BSIZE=400\n'
} > "${env_file}"

bash "${repo_root}/02.scripts/01.sample_qc.sh" "${env_file}"

Rscript "${repo_root}/02.scripts/03.prepare_phenotypes.R" \
  --input "${demo_dir}/04.simulated_idp_covariates.tsv" \
  --phenotypes "${demo_dir}/05.simulated_phenotypes.tsv" \
  --output "${out_dir}/phenotypes.processed.tsv" \
  --sample-keep "${out_dir}/sample_qc/keep.samples.txt"

printf 'Simulated demo complete: %s\n' "${out_dir}/phenotypes.processed.tsv"
