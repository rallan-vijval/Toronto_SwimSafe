# Download Toronto SwimSafe data
# --------------------------------
install.packages('opendatatoronto')
library(opendatatoronto)
library(dplyr)

# Toronto Open Data package ID for SwimSafe
package_id <- "e36df4b9-f772-49ab-a87b-f90b869b7a44"

# Find all resources associated with the dataset
resources <- list_package_resources(package_id)

# Keep CSV and GeoJSON datastore resources
datastore_resources <- resources %>%
  filter(tolower(format) %in% c("csv", "geojson"))

# Download the first datastore resource
swimsafe <- datastore_resources %>%
  filter(name == "Swimsafe - 4326.csv") %>%
  get_resource()

# Save raw data
write.csv(
  swimsafe,
  "data/raw_data/SwimSafe.csv",
  row.names = FALSE
)
