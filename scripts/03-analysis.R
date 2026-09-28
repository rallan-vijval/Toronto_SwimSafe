# SwimSafe analysis
# -----------------

library(tidyverse)

# Read analysis data
inspections <- read_csv(
  "data/analysis_data/swimsafe_inspections.csv"
)

# Read raw data for analyses that use individual recorded infractions
swimsafe <- read_csv(
  "data/raw_data/swimsafe.csv"
)


# ---------------------------------------------------------
# 1. Inspection outcomes by facility type
# ---------------------------------------------------------

inspection_outcomes <- inspections %>%
  count(type, insStatus) %>%
  group_by(type) %>%
  mutate(
    n_total = sum(n),
    percent = 100 * n / n_total
  ) %>%
  ungroup()

inspection_outcomes


# ---------------------------------------------------------
# 2. Non-pass inspections by facility type
# ---------------------------------------------------------

non_pass_by_type <- inspections %>%
  group_by(type) %>%
  summarise(
    inspections = n(),
    non_pass = sum(insStatus != "Pass"),
    non_pass_percent = 100 * non_pass / inspections
  )

non_pass_by_type


# ---------------------------------------------------------
# 3. Recorded infraction severity by facility type
# ---------------------------------------------------------

severity_by_type <- inspections %>%
  group_by(type) %>%
  summarise(
    minor = sum(minor),
    significant = sum(significant),
    crucial = sum(crucial)
  ) %>%
  pivot_longer(
    cols = c(minor, significant, crucial),
    names_to = "severity",
    values_to = "n"
  ) %>%
  group_by(type) %>%
  mutate(
    percent = 100 * n / sum(n)
  ) %>%
  ungroup()

severity_by_type


# ---------------------------------------------------------
# 4. Infraction categories by facility type
# ---------------------------------------------------------

category_by_type <- swimsafe %>%
  filter(infCategory != "None") %>%
  count(type, infCategory, name = "n") %>%
  group_by(type) %>%
  mutate(
    percent = 100 * n / sum(n)
  ) %>%
  ungroup()

category_by_type


# Top five categories for each facility type
top_categories <- category_by_type %>%
  group_by(type) %>%
  slice_max(
    order_by = n,
    n = 5,
    with_ties = FALSE
  ) %>%
  arrange(type, desc(n))

top_categories


# ---------------------------------------------------------
# 5. Specific deficiencies
# ---------------------------------------------------------

top_deficiencies <- swimsafe %>%
  filter(
    defDesc != "None",
    !is.na(defDesc)
  ) %>%
  count(type, defDesc, name = "n") %>%
  group_by(type) %>%
  slice_max(
    order_by = n,
    n = 5,
    with_ties = FALSE
  ) %>%
  arrange(type, desc(n))

top_deficiencies