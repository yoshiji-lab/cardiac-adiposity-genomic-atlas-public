#!/usr/bin/env bash
set -euo pipefail
source "${1:?Usage: $0 01.config/local.env}"
mkdir -p "${WORK_DIR}/sample_qc"

# Required columns are documented in 03.docs/01.inputs.md.
# Values are expected to be 1/0, except FID and IID.
awk -F'\t' 'BEGIN{OFS="\t"}
NR==1 {
  for(i=1;i<=NF;i++) c[$i]=i
  req[1]="FID"; req[2]="IID"; req[3]="consent_ok"; req[4]="wgs_available";
  req[5]="sex_concordant"; req[6]="no_sex_chr_aneuploidy";
  req[7]="heterozygosity_missingness_ok"; req[8]="not_outlier"; req[9]="wgs_batch_available";
  for(j=1;j<=9;j++) if(!(req[j] in c)){print "Missing column: " req[j] > "/dev/stderr"; exit 2}
  next
}
$c["consent_ok"]==1 && $c["wgs_available"]==1 &&
$c["sex_concordant"]==1 && $c["no_sex_chr_aneuploidy"]==1 &&
$c["heterozygosity_missingness_ok"]==1 && $c["not_outlier"]==1 &&
$c["wgs_batch_available"]==1 {print $c["FID"],$c["IID"]}
' "${SAMPLE_TABLE}" > "${WORK_DIR}/sample_qc/keep.samples.txt"

n=$(wc -l < "${WORK_DIR}/sample_qc/keep.samples.txt")
printf "Participants passing prespecified sample QC: %s\n" "$n"
[[ "$n" -gt 0 ]] || { echo "ERROR: no samples passed QC" >&2; exit 1; }
