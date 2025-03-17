# List of required packages
required_packages <- c(
  "tidycensus", "tidyverse", "tigris", "sf", "ggplot2", "viridis",
  "ggpubr", "ggthemes", "curl", "readr", "readxl"
)

# Identify packages that are not installed
missing_packages <- required_packages[!(required_packages %in% installed.packages()[,"Package"])]

# Install missing packages
if (length(missing_packages) > 0) {
  install.packages(missing_packages, dependencies = TRUE)
}
