#### Preamble ####
# Purpose: Simulate the SwimSafe Data
# Author: Vijval Rallan
# Date: 28 September 2026
# Contact: vijval.rallan@mail.utoronto.ca
# License: MIT
# Pre-requisites: Review the plan and sketches for the analysis in the "other/sketches" folder
# Any other information needed? N/A


# Simulate a small SwimSafe-like dataset for testing
# This is not used for the results in the paper.

library(tidyverse)
library(here)

set.seed(123)

simulated_data <- tibble(
  unique_id = 1:30,
  
  facilityName = sample(
    c(
      "Simulated Community Centre",
      "Simulated Recreation Centre",
      "Simulated Aquatic Centre",
      "Simulated Wellness Centre"
    ),
    30,
    replace = TRUE
  ),
  
  estName = sample(
    c(
      "Simulated Facility A",
      "Simulated Facility B",
      "Simulated Facility C",
      "Simulated Facility D"
    ),
    30,
    replace = TRUE
  ),
  
  type = sample(
    c(
      "Indoor Pool",
      "Outdoor Pool",
      "Spa Indoor",
      "Spa Outdoor"
    ),
    30,
    replace = TRUE
  ),
  
  insStatus = sample(
    c("Pass", "Conditional Pass", "Closed"),
    30,
    replace = TRUE,
    prob = c(0.70, 0.20, 0.10)
  ),
  
  insDate = sample(
    seq(
      as.Date("2025-01-01"),
      as.Date("2025-12-31"),
      by = "day"
    ),
    30,
    replace = TRUE
  ),
  
  infCategory = sample(
    c(
      "None",
      "Water quality and chemistry",
      "Maintenance/provision of pool/spa, deck and equipment",
      "Tests, records and inspections"
    ),
    30,
    replace = TRUE
  ),
  
  defDesc = sample(
    c(
      "None",
      "Pool pH",
      "Pool alkalinity",
      "Maintenance of pool/spa deck equipment and first aid kit"
    ),
    30,
    replace = TRUE
  ),
  
  infType = sample(
    c(
      "None",
      "M - Minor",
      "S - Significant",
      "C - Crucial"
    ),
    30,
    replace = TRUE
  ),
  
  actionDesc = sample(
    c(
      "None",
      "Corrective action required"
    ),
    30,
    replace = TRUE
  )
)

dir.create(
  here::here("data", "simulated_data"),
  recursive = TRUE,
  showWarnings = FALSE
)

write_csv(
  simulated_data,
  here::here(
    "data",
    "simulated_data",
    "swimsafe_simulated.csv"
  )
)