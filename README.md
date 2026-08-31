# Genomic atlas of cardiac and adiposity imaging phenotypes

Code accompanying:

> Tsao, H. M., Smith, L., Richard, A. et al. (2026). **Genomic atlas of cardiac and adiposity imaging phenotypes.** medRxiv. https://www.medrxiv.org/content/10.64898/2026.07.28.26358969v1

Companion PheWeb2 browser repository: https://github.com/yoshiji-lab/Imaging-PheWeb2.git

This repository provides the analysis code and documentation for the cardiac-adiposity genomic atlas, spanning cohort and phenotype preparation, WGS association testing, locus interpretation, gene prioritization, tissue and cell-type contextualization, downstream phenotype analyses, clustering, and browser release documentation. The study analyzed 11 cardiac MRI traits and 31 DXA-derived adiposity traits in UK Biobank.

The repository is designed for transparent review and reuse of the documented analytical workflow. It includes executable workflow scripts, configuration templates, method-alignment notes, and a simulated demonstration dataset. It is **not** a distribution of controlled-access study data or complete private production infrastructure.

## Workflow Scope

1. Define the analysis cohort from consent, WGS availability, imaging availability, covariates, and prespecified sample-QC fields.
2. Prepare cardiac and adiposity imaging-derived phenotypes, including covariate residualization and rank-based inverse-normal transformation.
3. Apply WGS variant QC and run two-step quantitative-trait association testing with REGENIE.
4. Define independent association signals and annotate novelty against prior cardiac and adiposity imaging-genetics studies.
5. Quantify cross-trait structure through overlap, genetic correlation, colocalization, and locus-sharing analyses.
6. Prioritize candidate effector genes using FLAMES, Open Targets L2G, cS2G, rare-variant convergence, and complementary annotation sources.
7. Contextualize loci and genes using tissue, cell-type, epigenomic, and exemplar-locus analyses.
8. Evaluate downstream phenotype relevance, including All of Us PheWAS/PRS analyses and disease-informed clustering.
9. Assemble publication-ready tables, figures, and PheWeb2 browser documentation.

## Repository structure

```text
01.config/
    01.example.env                   User-editable paths and software settings
    02.phenotypes.tsv                The 42 study phenotype names and classes
02.scripts/
    01.sample_qc.sh                  Participant-level QC from a prepared sample table
    02.variant_qc.sh                 SNP and sample QC with PLINK 2
    03.prepare_phenotypes.R          Covariate adjustment and inverse-normalization
    04.regenie_step1.sh              LD pruning and REGENIE whole-genome prediction
    05.regenie_step2.sh              Single-variant association testing
    06.merge_check_results.sh        Merge chromosomes and perform basic checks
03.docs/
    01.inputs.md                     Required input schemas
    02.methods_alignment.md          Mapping between scripts and manuscript methods
    03.downstream_structure.md       Downstream analysis and manuscript assembly map
    04.pheweb2_browser.md            Companion PheWeb2 browser provenance and configuration
04.demo/
    README.md                        Simulated demonstration overview
    01.generate_simulated_data.R     Deterministic generator for the simulated dataset
    02.run_demo.sh                   Runs sample QC and phenotype preparation on simulated data
    03.simulated_samples.tsv         Simulated sample-QC table for 100 participants
    04.simulated_idp_covariates.tsv  Simulated phenotype/covariate table for 100 participants
    05.simulated_phenotypes.tsv      Simulated phenotype definitions
05. CITATION.cff
06. LICENSE
07. .gitignore
```

## Downstream analyses

The executable scripts in this release cover the cohort, phenotype, variant-QC, and association-testing components that require controlled-access inputs. The broader atlas also includes downstream interpretation and resource-building components: locus discovery and novelty annotation, cross-trait overlap and colocalization, gene prioritization, tissue and cell-type context, downstream phenotype analyses, clustering, exemplar loci, supplementary table generation, and browser preparation. See `03.docs/03.downstream_structure.md` for the publication-facing structure represented by the broader analysis repository.

The interactive summary-statistics browser was prepared as a companion PheWeb2 interface for stratified GWAS and PheWAS visualization. See `03.docs/04.pheweb2_browser.md` for PheWeb2 provenance and local configuration summary.

## System requirements

- Bash 4+
- PLINK 2: required for genotype QC and REGENIE input preparation; analyses used PLINK 2 within the UK Biobank Research Analysis Platform on DNAnexus workflow. Public repository: https://github.com/chrchang/plink-ng
- REGENIE: required for two-step quantitative-trait association testing; analyses used REGENIE within the UK Biobank Research Analysis Platform on DNAnexus workflow. Public repository: https://github.com/rgcgithub/regenie
- R: required for phenotype preparation; analyses used R within the UK Biobank Research Analysis Platform on DNAnexus workflow.
- R packages: `data.table` for `02.scripts/03.prepare_phenotypes.R`.
- Tested operating system/environment: UK Biobank Research Analysis Platform on DNAnexus for the controlled-access GWAS workflow. The simulated demonstration can be run in a standard Bash/R environment.
- Non-standard hardware requirements: none for the simulated demonstration workflow. Full WGS-scale analyses require appropriately resourced controlled-access compute within the UK Biobank Research Analysis Platform on DNAnexus.

The scripts assume GRCh38 PLINK 2 PGEN input and tab-delimited phenotype/covariate files. Python is not required by the released scripts in this repository. Manuscript analyses outside the released workflow used Python, LD Score Regression, HyPrColoc, FLAMES, CADD, GTEx v8, PheTK through the All of Us Researcher Workbench, PheWeb2, SuSiE, cS2G, Open Targets Platform GraphQL API, Variant Effect Predictor, EpiMAP 18-state ChromHMM annotations lifted to GRCh38, 1000 Genomes Project Phase 3 European-ancestry LD reference data, and custom R, Python, and shell scripts.

## Third-party software and resources

This project uses established public tools where possible. Third-party software remains subject to its own licenses and citation requirements.

- PLINK 2: https://github.com/chrchang/plink-ng
- REGENIE: https://github.com/rgcgithub/regenie
- FLAMES gene prioritization: https://github.com/Marijn-Schipper/FLAMES
- LD Score Regression: https://github.com/bulik/ldsc
- HyPrColoc: https://github.com/cnfoley/hyprcoloc
- SuSiE / `susieR`: https://github.com/stephenslab/susieR
- bNMF clustering: https://github.com/gwas-partitioning/bnmf-clustering.git
- PoPS: https://github.com/FinucaneLab/pops
- Open Targets L2G scoring pipeline: https://github.com/opentargets-archive/genetics-l2g-scoring
- Open Targets Platform documentation for L2G: https://github.com/opentargets/platform-docs
- PheTK: https://github.com/nhgritctran/PheTK
- Study-specific Imaging PheWeb2 browser: https://github.com/yoshiji-lab/Imaging-PheWeb2.git
- PheWeb2 UI: https://github.com/GaglianoTaliun-Lab/PheWeb2
- PheWeb2 API: https://github.com/GaglianoTaliun-Lab/PheWeb2-API
- Original PheWeb: https://github.com/statgen/pheweb
- Ensembl Variant Effect Predictor: https://github.com/Ensembl/ensembl-vep
- CADD scripts: https://github.com/kircherlab/CADD-scripts
- GTEx v8: https://gtexportal.org/
- Open Targets Platform: https://platform.opentargets.org/
- CADD scores and downloads: https://cadd.kircherlab.bihealth.org/
- EpiMAP annotations: https://compbio.mit.edu/epimap/
- 1000 Genomes Project: https://www.internationalgenome.org/

## Installation

Clone the repository and create a local configuration file:

```bash
git clone https://github.com/yoshiji-lab/cardiac-adiposity-genomic-atlas.git
cd cardiac-adiposity-genomic-atlas
cp 01.config/01.example.env 01.config/local.env
```

Edit `01.config/local.env` to point to approved inputs and software in the UK Biobank Research Analysis Platform on DNAnexus, or to equivalent approved local paths for simulated or non-controlled data. Required third-party software, including PLINK 2, REGENIE, R, and required R packages, must be available in that environment.

Typical installation/setup time: a few minutes to clone the repository and copy the configuration template. Provisioning the UK Biobank DNAnexus analysis environment, controlled-access data, and WGS-scale compute resources is project-specific and is not included in this repository setup time.

## Executable Workflow

```bash
# Edit 01.config/local.env, then:
bash 02.scripts/01.sample_qc.sh 01.config/local.env
bash 02.scripts/02.variant_qc.sh 01.config/local.env
Rscript 02.scripts/03.prepare_phenotypes.R \
  --input data/idp_covariates.tsv \
  --phenotypes 01.config/02.phenotypes.tsv \
  --output work/phenotypes.processed.tsv \
  --sample-keep work/sample_qc/keep.samples.txt
bash 02.scripts/04.regenie_step1.sh 01.config/local.env
bash 02.scripts/05.regenie_step2.sh 01.config/local.env
bash 02.scripts/06.merge_check_results.sh 01.config/local.env
```

The commands above run the controlled-access cohort, phenotype, variant-QC, and association-testing workflow when supplied with approved inputs. Downstream interpretation steps are documented in `03.docs/03.downstream_structure.md` and use topic-specific scripts and outputs from the broader analysis repository. Inspect generated counts and logs at every stage, and adapt resource requests and file naming to the approved computing environment.

## Demo

A simulated demonstration dataset is provided in `04.demo/`. It contains 100 artificial participants with simulated QC indicators, covariates, principal components, and two simulated imaging-derived phenotypes. The demonstration illustrates sample-QC filtering and phenotype residualization/inverse-normalization. It does not require UK Biobank or All of Us access and does not run PLINK 2 or REGENIE.

```bash
bash 04.demo/02.run_demo.sh
```

Required software: Bash and R with the `data.table` package. Expected outputs are written to `04.demo/output/`, including `sample_qc/keep.samples.txt` and `phenotypes.processed.tsv`. Successful execution prints the number of simulated samples passing QC and writes a processed phenotype table. Typical runtime for the simulated demo is under one minute in a standard Bash/R environment; full WGS-scale runs should be executed in the UK Biobank Research Analysis Platform on DNAnexus and runtime depends on allocated resources.

## Analysis definitions represented here

The pooled phenotype model includes sex, age, age squared, sex-by-age, sex-by-age squared, assessment center, WGS batch, and 20 genetic principal components. BMI/height-adjusted adiposity traits additionally include BMI and height. Sex-stratified analyses use the same framework but omit sex and sex-interaction terms. The processed residuals are rank-based inverse-normal transformed before association testing.

Step 1 uses autosomal LD-pruned variants with MAF >= 0.01, genotype missingness <= 0.01, HWE P > 1e-6, and pruning parameters of a 1,000-variant window, 200-variant step, and r2 < 0.2. Step 2 retains variants with MAC >= 20, genotype missingness <= 0.02, and HWE P > 1e-6. These settings reflect the supplied production scripts; verify that they match the final archived run and manuscript before release.

## Data privacy and availability

No individual-level or participant-level data are distributed in this repository. No individual-level UK Biobank or All of Us data are included. UK Biobank participant-level data are available only to approved researchers through the UK Biobank Access Management System; this study used UK Biobank application 73958. All of Us data remain subject to their controlled-access and data-use procedures through the Researcher Workbench.

Any example or demonstration data included in this repository are simulated and contain no real participant records. Only code, configuration templates, phenotype definitions, documentation, and permitted non-identifiable outputs are intended for public release. No controlled-access data, participant identifiers, credentials, project IDs, internal paths, private storage paths, job logs containing sample IDs, or derived individual-level results may be committed to this repository.

## Reproducibility and release checklist

Before making a public release:

- Confirm all thresholds and environment details against final UK Biobank DNAnexus job logs.
- Create an immutable GitHub release corresponding to the submitted manuscript.
- Archive that release with Zenodo and add the resulting DOI to the manuscript.
- Run a secret scan and confirm that no participant identifiers, credentials, project IDs, internal paths, logs, or derived individual-level data are tracked.
- Add a code availability link to the manuscript only after testing the public clone and confirming that the documented workflow matches the UK Biobank DNAnexus analysis environment.

This repository provides the released code and documentation for the major analysis workflow represented here. Complete end-to-end reproduction of the manuscript depends on authorized access to the underlying controlled-access datasets and appropriate controlled-access computing environments.

## License

Code is released under the MIT License. Third-party software remains subject to its own license terms.
