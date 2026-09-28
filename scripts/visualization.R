# SwimSafe visualizations
# -----------------------

library(tidyverse)

# Read raw data
swimsafe <- read_csv(
  "data/raw_data/swimsafe.csv"
)

# Read analysis data
inspections <- read_csv(
  "data/analysis_data/SwimSafe_inspections.csv"
)

# ---------------------------------------------------------
# Figure 1: Facility locations
# ---------------------------------------------------------
facility_locations <- swimsafe |>
  distinct(estName, type, geometry) |>
  mutate(
    coordinates = str_extract_all(
      geometry,
      "-?[0-9]+\\.[0-9]+"
    ),
    longitude = map_dbl(coordinates, ~ as.numeric(.x[1])),
    latitude = map_dbl(coordinates, ~ as.numeric(.x[2]))
  )

figure_facility_locations <- ggplot(
  facility_locations,
  aes(
    x = longitude,
    y = latitude,
    color = type
  )
) +
  geom_point(
    alpha = 0.45,
    size = 1.4
  ) +
  coord_fixed() +
  labs(
    title = "Swimming facilities represented in the SwimSafe data",
    x = "Longitude",
    y = "Latitude",
    color = "Facility type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

figure_facility_locations

ggsave(
  "other/charts/figure_1_facility_locations.png",
  figure_facility_locations,
  width = 8,
  height = 6,
  dpi = 300
)

# ---------------------------------------------------------
# Figure 2: Inspection timeline
# ---------------------------------------------------------

inspection_timeline <- inspections |>
  mutate(
    month = as.Date(format(insDate, "%Y-%m-01"))
  ) |>
  count(month, name = "inspections")

figure_inspection_timeline <- ggplot(
  inspection_timeline,
  aes(
    x = month,
    y = inspections
  )
) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 1.5) +
  labs(
    title = "Monthly number of recorded inspections",
    x = "Month",
    y = "Number of inspections"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold")
  )

figure_inspection_timeline

ggsave(
  "other/charts/figure_2_inspection_timeline.png",
  figure_inspection_timeline,
  width = 8,
  height = 5,
  dpi = 300
)

# Calculate inspection outcomes
inspection_outcomes <- inspections %>%
  count(type, insStatus) %>%
  group_by(type) %>%
  mutate(
    percent = 100 * n / sum(n)
  ) %>%
  ungroup()


# ---------------------------------------------------------
# Figure 3: Inspection outcomes by facility type
# ---------------------------------------------------------
figure_3 <- ggplot(
  inspection_outcomes,
  aes(x = type, y = percent, fill = insStatus)
) +
  geom_col() +
  labs(
    title = "Inspection outcomes vary across swimming facility types",
    x = "Facility type",
    y = "Percentage of inspections",
    fill = "Inspection outcome"
  ) +
  scale_y_continuous(
    limits = c(0, 100),
    expand = c(0, 0)
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

figure_3

# Save Figure 3
ggsave(
  "other/charts/figure_3_inspection_outcomes.png",
  plot = figure_1,
  width = 8,
  height = 5,
  dpi = 300
)

# ---------------------------------------------------------
# Figure 4: Infraction severity by facility type
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

figure_4 <- ggplot(
  severity_by_type,
  aes(x = type, y = percent, fill = severity)
) +
  geom_col() +
  labs(
    title = "Recorded infraction severity varies across facility types",
    x = "Facility type",
    y = "Percentage of recorded infractions",
    fill = "Infraction type"
  ) +
  coord_cartesian(
    ylim = c(0, 100),
    expand = FALSE
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

figure_4

ggsave(
  "other/charts/figure_4_infraction_types.png",
  plot = figure_2,
  width = 8,
  height = 5,
  dpi = 300
)

# ---------------------------------------------------------
# Figure 5: Main infraction categories by facility type
# ---------------------------------------------------------

category_by_type <- swimsafe %>%
  filter(infCategory != "None") %>%
  count(type, infCategory, name = "n") %>%
  group_by(type) %>%
  mutate(
    percent = 100 * n / sum(n)
  ) %>%
  ungroup()

# Identify the five most common categories overall
top_five_categories <- category_by_type %>%
  group_by(infCategory) %>%
  summarise(
    total = sum(n),
    .groups = "drop"
  ) %>%
  slice_max(
    order_by = total,
    n = 5,
    with_ties = FALSE
  ) %>%
  pull(infCategory)

# Keep those five categories
figure_5_data <- category_by_type %>%
  filter(infCategory %in% top_five_categories)

figure_5_data <- figure_5_data %>%
  mutate(
    category_short = case_when(
      infCategory == "4. MAINTENANCE/PROVISION OF POOL/SPA, DECK AND EQUIPMENT" ~
        "Maintenance & equipment",
      infCategory == "7. TESTS, RECORDS AND INSPECTIONS" ~
        "Tests & records",
      infCategory == "1. WATER QUALITY AND CHEMISTRY" ~
        "Water quality & chemistry",
      infCategory == "5. CIRCULATION & MECHANICAL SYSTEMS" ~
        "Circulation & mechanical",
      infCategory == "3. POOL AND SPA SAFETY, WATER CLARITY AND CHEMICAL  STORAGE/HANDLING" ~
        "Safety, clarity & chemical handling"
    )
  )

# Figure 5
figure_5 <- ggplot(
  figure_5_data,
  aes(
    x = reorder(category_short, percent),
    y = percent
  )
) +
  geom_col() +
  coord_flip() +
  facet_wrap(~ type, ncol = 2) +
  labs(
    title = "Main infraction categories vary across facility types",
    x = "Infraction category",
    y = "Percentage of recorded infractions"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold"),
    axis.text.y = element_text(size = 8)
  )

figure_5

ggsave(
  "other/charts/figure_5_infraction_categories.png",
  plot = figure_3,
  width = 9,
  height = 6,
  dpi = 300
)


