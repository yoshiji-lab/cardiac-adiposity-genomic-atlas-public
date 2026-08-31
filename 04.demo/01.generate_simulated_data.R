#!/usr/bin/env Rscript
set.seed(73958)

`%||%` <- function(x, y) if (length(x) && !is.na(x) && nzchar(x)) x else y

args <- commandArgs(trailingOnly = FALSE)
file_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
script_path <- file_arg %||% "04.demo/01.generate_simulated_data.R"
demo_dir <- dirname(normalizePath(script_path, mustWork = FALSE))

n <- 100L
i <- seq_len(n)
id <- sprintf("SYN%03d", i)
sex <- i %% 2L
age <- 45 + (i %% 30L) + round(rnorm(n, 0, 1.5), 1)
assessment_center <- c("CENTER_A", "CENTER_B", "CENTER_C", "CENTER_D")[(i %% 4L) + 1L]
wgs_batch <- c("BATCH_A", "BATCH_B", "BATCH_C", "BATCH_D", "BATCH_E")[(i %% 5L) + 1L]
height <- round(ifelse(sex == 1L, rnorm(n, 176, 6), rnorm(n, 164, 6)), 1)
BMI <- round(rnorm(n, 26.5, 3.2) + 0.04 * (age - 55), 1)

pc <- sapply(seq_len(20), function(k) {
  round(rnorm(n, mean = (k - 10) / 500, sd = 0.04) + ((i %% (k + 3L)) - k / 2) / 1000, 4)
})
colnames(pc) <- paste0("PC", seq_len(20))

CO <- round(4.8 + 0.035 * (age - 55) + 0.18 * sex + pc[, 1] * 2 + rnorm(n, 0, 0.35), 3)
Android_fat_BMIadj <- round(0.20 + 0.012 * (BMI - 26) - 0.0009 * (height - 170) +
                              0.025 * sex + pc[, 2] * 0.6 + rnorm(n, 0, 0.035), 3)

samples <- data.frame(
  FID = id,
  IID = id,
  consent_ok = 1L,
  wgs_available = 1L,
  sex_concordant = 1L,
  no_sex_chr_aneuploidy = 1L,
  heterozygosity_missingness_ok = 1L,
  not_outlier = 1L,
  wgs_batch_available = 1L,
  check.names = FALSE
)

samples$wgs_available[c(7, 41)] <- 0L
samples$sex_concordant[23] <- 0L
samples$heterozygosity_missingness_ok[58] <- 0L
samples$not_outlier[76] <- 0L

pheno <- data.frame(
  FID = id,
  IID = id,
  CO = CO,
  Android_fat_BMIadj = Android_fat_BMIadj,
  sex = sex,
  age = age,
  assessment_center = assessment_center,
  wgs_batch = wgs_batch,
  pc,
  BMI = BMI,
  height = height,
  check.names = FALSE
)

pdef <- data.frame(
  phenotype = c("CO", "Android_fat_BMIadj"),
  class = c("cardiac", "adiposity_bmi_height_adjusted"),
  check.names = FALSE
)

write.table(samples, file.path(demo_dir, "03.simulated_samples.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
write.table(pheno, file.path(demo_dir, "04.simulated_idp_covariates.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
write.table(pdef, file.path(demo_dir, "05.simulated_phenotypes.tsv"),
            sep = "\t", quote = FALSE, row.names = FALSE)
