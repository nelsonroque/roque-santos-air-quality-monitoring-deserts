# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Merge external datasets together for analyses -----

merged <- paper_data_computed %>%
  left_join(station_counts, by = "FIPS") %>%
  left_join(rucc, by = "FIPS") %>%
  mutate(monitor_per_capita = case_when(
    is.na(n_open_stations) | is.na(B01001_001E) ~ 0,
    TRUE ~ n_open_stations / B01001_001E * 1000
  )) %>%
  mutate(STFIPS = as.numeric(substr(GEOID, 1, 2))) %>%
  mutate(no_monitor_label = case_when(
    n_open_stations > 0 ~ "Active Site",
    is.na(n_open_stations) ~ "Monitoring Desert",
    TRUE ~ "Monitoring Desert"
  )) %>%
  mutate(no_monitor = case_when(
    n_open_stations > 0 ~ FALSE,
    is.na(n_open_stations) ~ TRUE,
    TRUE ~ TRUE
  )) %>%
  mutate(has_monitor = case_when(
    n_open_stations > 0 ~ TRUE,
    is.na(n_open_stations) ~ FALSE,
    TRUE ~ FALSE
  )) %>%
  mutate(n_open_stations = ifelse(
    is.na(n_open_stations), 0, n_open_stations
  )) %>%
  mutate(n_closed_stations = ifelse(
    is.na(n_closed_stations), 0, n_closed_stations
  )) %>%
  left_join(counties)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# %>%
#   mutate(monitor_per_area = case_when(
#     is.na(n_open_stations) | is.na(ALAND) ~ 0,
#     TRUE ~ n_open_stations / ALAND * 1000
#   ))

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Print to check
head(merged)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Inspect dataset to make sure NA for closed -> 0 ----
# (i.e., if county has no stations, the value should be 0 not NA)
counties_with_stations_count <- merged %>%
  select(
    FIPS,
    n_open_stations,
    n_closed_stations,
    contains("monitor")
  )

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
