# Install any packages that are missing in your environment
source("scripts/install_missing_packages.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Load necessary libraries
source("scripts/load_libs.R")

`%nin%` <- Negate(`%in%`) # Create a negation of the %in% operator

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Set tigris options for caching and spatial data handling
options(tigris_class = "sf", tigris_use_cache = TRUE)

# Get your Census API Key Here:
#https://api.census.gov/data/key_signup.html
census_api_key(
  key = "XXXXXXX", install = T,
  overwrite = T
)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Prepare Data
EPA_SITE_FN = "data/aqs_sites_03_16_25.csv"

source("scripts/prepare_epa_data.R")
source("scripts/prepare_rucc_data.R")
source("scripts/download_census_data.R")
source("scripts/prepare_census_data.R")
source("scripts/merge_datasets.R")
source("scripts/filter_south_belt.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Run models ----
source("scripts/run_models.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Prepare figures ----
source("scripts/create_figures.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Prepare tables ---
source("scripts/prepare_tables.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Compute all stats throughout the paper
source("scripts/compute_stats.R")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

