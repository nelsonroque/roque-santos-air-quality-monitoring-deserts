
# Load EPA Station List file from EPA -----
station_list <- read_csv(EPA_SITE_FN) %>%
  mutate(
    FIPS = as.character(paste0(`State Code`, `County Code`)),
    is_station_closed = ifelse(is.na(`Site Closed Date`), 0, 1),
    is_station_open = ifelse(is.na(`Site Closed Date`), 1, 0)
  ) %>%
  mutate(FIPS_first2 = substr(FIPS, 1, 2)) %>%
  filter(`State Code` != "CC") %>%
  filter(FIPS_first2 < 78)

# average elevation of sites by state
station_list_elevation <- station_list %>%
  group_by(`State Name`) %>%
  summarise(
    avg_elevation = mean(`Elevation`, na.rm = TRUE),
    median_elevation = median(`Elevation`, na.rm = TRUE),
    max_elevation = max(`Elevation`, na.rm = TRUE),
    sd_elevation = sd(`Elevation`, na.rm = TRUE)
  )

station_counts <- station_list %>%
  group_by(`State Code`, FIPS) %>%
  summarise(
    n_open_stations = sum(is_station_open),
    n_closed_stations = sum(is_station_closed)
  ) %>%
  mutate(no_monitor = case_when(
    n_open_stations > 0 ~ FALSE,
    is.na(n_open_stations) ~ TRUE,
    TRUE ~ TRUE
  )) %>%
  mutate(no_monitor_label = case_when(
    n_open_stations > 0 ~ "Active Monitor",
    is.na(n_open_stations) ~ "No Monitor",
    TRUE ~ "No Monitor"
  )) %>%
  mutate(FIPS_first2 = substr(FIPS, 1, 2)) %>%
  filter(`State Code` != "CC") %>%
  filter(FIPS_first2 < 78)

# are all FIPS 5 digits?
any_incorrect_fips = station_counts %>%
  filter(nchar(FIPS) != 5)
# should be 0 rows :)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Compute metadata for site age plot
station_list_age_metadata_computed <- read_csv(EPA_SITE_FN) %>%
  janitor::clean_names() %>%
  mutate(site_age_weeks = difftime("2025-01-01",
                                   site_established_date,
                                   units = "weeks"
  )) %>%
  mutate(site_age_years = as.numeric(site_age_weeks) / 52) %>%
  mutate(is_site_closed = if_else(is.na(site_closed_date), "Open", "Closed")) %>%
  # filter(is_site_closed == "open") %>%
  mutate(is_metro = case_when(
    location_setting == "RURAL" ~ "Nonmetropolitan",
    location_setting != "RURAL" ~ "Metropolitan",
  )) %>%
  filter(location_setting %in% c("RURAL", "SUBURBAN", "URBAN AND CENTER CITY"))

# Compute median site age for each facet group
station_list_age_metadata_computed_median <- station_list_age_metadata_computed %>%
  group_by(is_metro, is_site_closed) %>%
  summarize(median_age = median(site_age_years, na.rm = TRUE), .groups = "drop")

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

