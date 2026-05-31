The file named 'plant_code.R' is the code for my significance article.
The file named 'plant_data.csv' is the raw data.
# iNaturalist Campus Plant Records Analysis
This repository contains the R code used for my Significance style article project on plant observations from the University of Auckland City Campus iNaturalist dataset.

# Project overview
The project explores how iNaturalist plant records represent campus flora, and how these records are shaped by cultivation, plant visibility, seasonality, and observer effort. The analysis focuses on plant observation records rather than direct measures of plant abundance.

# Data
The input data file is:
`plant_data.csv`
This file was exported from iNaturalist and contains plant observation records associated with the University of Auckland City Campus. The original data file was kept unchanged. A reduced analysis dataset was created in R by selecting variables related to observation date, taxonomic identity, identification quality, and cultivation status.

# R packages required
The analysis uses the following R packages:
library(tidyverse)
library(lubridate)

# Analysis workflow
The R script follows these main steps:
1. Import the original iNaturalist data.
2. Select useful columns for analysis.
3. Remove records without observation dates.
4. Create new variables, including:
`year`
`month`
`cultivation_status`
5. Summarise records by cultivation status, taxon, month, and year.
6. Produce four figures for the article.

# Figures produced
The code generates four main figures:
Figure 1: Cultivated and non-cultivated plant observations
Figure 2: Most frequently recorded plant taxa
Figure 3: Monthly pattern of plant observations
Figure 4: Yearly pattern of plant observations
These figures are used to support the main interpretation that campus plant records reflect both plant life and human activity.

# Important interpretation note
The counts in this analysis are counts of iNaturalist observation records. They should not be interpreted as direct counts of individual plants or true plant abundance. A plant may be recorded more often because it is visible, familiar, cultivated, easy to identify, or located where people often walk.

# Reproducibility
To reproduce the analysis, place `plant_data.csv` in the same folder as the R script, then run the script from top to bottom in R or RStudio.
