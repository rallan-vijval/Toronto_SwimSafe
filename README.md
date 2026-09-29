# SwimSafe Toronto

## Overview

This project analyzes Toronto's SwimSafe inspection data to examine how inspection outcomes and recorded infraction patterns vary across different types of swimming facilities.

The analysis uses publicly available data from the City of Toronto's Open Data portal. The raw dataset contains 17,891 records covering inspections from July 2024 to September 2026. Because a single inspection can generate multiple records for different observations or infractions, the raw data are aggregated to the inspection level, producing 9,967 inspection-level observations.

The analysis compares four facility types:

- Indoor Pool
- Outdoor Pool
- Spa Indoor
- Spa Outdoor

The main analysis examines inspection outcomes, recorded infraction types, infraction categories, and specific deficiencies.

## Research question

How do inspection outcomes and recorded infraction patterns vary across different types of swimming facilities in Toronto?

## Data

The data are obtained from the City of Toronto's SwimSafe dataset:

[City of Toronto SwimSafe](https://open.toronto.ca/dataset/swimsafe/)

The raw data are stored in `data/raw_data/`. The inspection-level dataset created from the raw data is stored in `data/analysis_data/`.

A small simulated dataset used for the reproducibility workflow is stored in `data/simulated_data/`.

## Project structure

- `data/raw_data/` contains the raw SwimSafe data obtained from Toronto Open Data.
- `data/analysis_data/` contains the inspection-level dataset created from the raw data.
- `data/simulated_data/` contains the simulated data generated for the reproducibility workflow.
- `scripts/` contains the R scripts used to simulate data, download the SwimSafe data, clean and aggregate the data, perform the analysis, and create visualizations.
- `other/charts/` contains the figures generated for the paper.
- `other/sketches/` contains sketches and planning materials used during the development of the analysis.
- `other/llm/` contains documentation of LLM use during the project.
- `paper/` contains the Quarto document, bibliography, and final PDF of the paper.
- `renv.lock` records the R package environment used for the analysis.

## Reproducibility

The analysis was conducted in R using the `tidyverse`, `ggplot2`, `tinytable`, `opendatatoronto`, and `here` packages.

To reproduce the analysis:

1. Clone or download this repository.
2. Open the `swimsafe-toronto.Rproj` project in RStudio.
3. Restore the project environment using `renv`.
4. Run the scripts in the `scripts/` directory in order.
5. Render `paper/paper.qmd` to generate the final paper.

The scripts use project-relative paths so that the analysis does not depend on a specific computer or file location.

## Statement on LLM usage

This project utilized ChatGPT to assist with data collection, analysis and writing processes. All records of usage can be found in the `other/llm` folder of this repository.