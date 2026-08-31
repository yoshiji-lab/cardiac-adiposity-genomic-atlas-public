#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(data.table))

args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(flag) {
  i <- match(flag, args)
  if (is.na(i) || i == length(args)) stop("Missing argument: ", flag)
  args[[i + 1]]
}
input <- get_arg("--input")
phenotype_file <- get_arg("--phenotypes")
output <- get_arg("--output")
keep_file <- get_arg("--sample-keep")
stratum <- if ("--stratum" %in% args) get_arg("--stratum") else "pooled"
if (!stratum %in% c("pooled", "female", "male")) stop("--stratum must be pooled, female, or male")

d <- fread(input, na.strings = c("NA", ""))
keep <- fread(keep_file, header = FALSE, col.names = c("FID", "IID"))
pdef <- fread(phenotype_file)

required <- c("FID","IID","sex","age","assessment_center","wgs_batch",
              paste0("PC", 1:20), "BMI", "height")
missing_cols <- setdiff(required, names(d))
if (length(missing_cols)) stop("Missing required columns: ", paste(missing_cols, collapse=", "))

d <- merge(d, keep, by = c("FID","IID"))
if (stratum == "female") d <- d[sex == 0]
if (stratum == "male") d <- d[sex == 1]

invnorm <- function(x) {
  ok <- is.finite(x)
  out <- rep(NA_real_, length(x))
  n <- sum(ok)
  if (n) out[ok] <- qnorm((rank(x[ok], ties.method="average") - 0.5) / n)
  out
}

pc_terms <- paste0("PC", 1:20)
base_terms <- c("age", "I(age^2)", "factor(assessment_center)",
                "factor(wgs_batch)", pc_terms)
if (stratum == "pooled") {
  base_terms <- c("sex", base_terms, "sex:age", "sex:I(age^2)")
}

out <- d[, .(FID, IID)]
for (i in seq_len(nrow(pdef))) {
  trait <- pdef$phenotype[i]
  cls <- pdef$class[i]
  if (!trait %in% names(d)) {
    warning("Skipping absent phenotype: ", trait)
    next
  }
  terms <- base_terms
  if (cls == "adiposity_bmi_height_adjusted") terms <- c(terms, "BMI", "height")
  f <- as.formula(paste(trait, "~", paste(terms, collapse = " + ")))
  fit <- lm(f, data = d, na.action = na.exclude)
  out[[trait]] <- invnorm(residuals(fit))
  message(trait, ": N = ", sum(is.finite(out[[trait]])))
}
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
fwrite(out, output, sep = "\t", na = "NA")
