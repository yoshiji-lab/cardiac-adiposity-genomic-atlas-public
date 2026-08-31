#!/usr/bin/env bash
set -euo pipefail
source "${1:?Usage: $0 01.config/local.env}"
in_dir="${RESULTS_DIR}/regenie_step2"
out_dir="${RESULTS_DIR}/summary_statistics"
mkdir -p "$out_dir"

pheno="${WORK_DIR}/phenotypes.processed.tsv"
mapfile -t traits < <(head -n1 "$pheno" | cut -f3- | tr '\t' '\n')

for trait in "${traits[@]}"; do
  out="${out_dir}/${trait}.regenie.gz"
  first="${in_dir}/chr1_${trait}.regenie.gz"
  [[ -s "$first" ]] || { echo "Missing $first" >&2; exit 1; }
  zcat "$first" | gzip -c > "$out"
  for chr in {2..22}; do
    f="${in_dir}/chr${chr}_${trait}.regenie.gz"
    [[ -s "$f" ]] || { echo "Missing $f" >&2; exit 1; }
    zcat "$f" | tail -n +2
  done | gzip -c >> "$out"

  header_count=$(zcat "$out" | awk 'NR==1{h=$0} $0==h{n++} END{print n+0}')
  rows=$(zcat "$out" | awk 'END{print NR-1}')
  [[ "$header_count" -eq 1 && "$rows" -gt 0 ]] ||
    { echo "Failed merge check for $trait" >&2; exit 1; }
  printf "%s\t%s\n" "$trait" "$rows"
done > "${out_dir}/row_counts.tsv"
