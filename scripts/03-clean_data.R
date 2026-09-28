# Clean and aggregate SwimSafe data
# ---------------------------------
library(tidyverse)

# Read raw data
swimsafe <- read_csv(
  "data/raw_data/SwimSafe.csv"
)

# Create one row per inspection
inspections <- swimsafe %>%
  group_by(estName, type, insDate) %>%
  summarise(
    facilityName = first(facilityName),
    
    insStatus = case_when(
      any(insStatus == "Closed") ~ "Closed",
      any(insStatus == "Conditional Pass") ~ "Conditional Pass",
      any(insStatus == "Pass") ~ "Pass",
      TRUE ~ NA_character_
    ),
    
    infractions = sum(infType != "None", na.rm = TRUE),
    minor = sum(infType == "M - Minor", na.rm = TRUE),
    significant = sum(infType == "S - Significant", na.rm = TRUE),
    crucial = sum(infType == "C - Crucial", na.rm = TRUE),
    
    categories = n_distinct(
      infCategory[infCategory != "None"]
    ),
    
    .groups = "drop"
  )

# Save analysis data
write_csv(
  inspections,
  "data/analysis_data/SwimSafe_inspections.csv"
)

