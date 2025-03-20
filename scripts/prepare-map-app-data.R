map_app_df <- merged %>%
  select(FIPS,
         `State Code`,
         `State`,
         County_Name,
         n_open_stations,
         no_monitor,
         rural, RUCC_2013,
         ALAND,
         B01001_001E) %>%
  janitor::clean_names()

map_app_clean <- map_app_df %>%
  mutate(population = b01001_001e) %>%
  select(-b01001_001e) %>%
  st_transform(4326) %>%
  mutate(centroid = st_centroid(geometry)) %>%
  mutate(
    longitude = map_dbl(centroid, ~st_coordinates(.x)[1]),
    latitude = map_dbl(centroid, ~st_coordinates(.x)[2])
  ) %>%
  select(-centroid)

# Remove the temporary column
  #st_drop_geometry() %>%
  # per capita (per 1000 people)
  mutate(n_open_per_capita = format((n_open_stations / population)*1000, scientific=FALSE)) %>%
  # per land area
  mutate(n_open_per_land = format(n_open_stations / aland, scientific=FALSE)) %>%
  left_join(fips_to_state) %>%
  rename(state_abb = state,
         state = state_name,
         stations = n_open_stations) %>%
  select(fips, contains("state"), fips, everything())

# Common demographic scaling approaches:
# Per 1,000: Used for more common occurrences (birth rates, death rates)
# Per 10,000: Good middle ground for moderately rare facilities/events
# Per 100,000: Used for rare events (disease incidence, specialized facilities)

state_avg <- map_app_clean %>%
  group_by(state) %>%
  summarise(
    stateAvg = mean(stations, na.rm = TRUE)
  ) %>%
  mutate(nationalAvg = mean(stateAvg, na.rm = TRUE))

map_app_clean_w_avgs = map_app_clean %>%
  left_join(state_avg, by = "state") %>%
  mutate(name = paste0(county_name, ", ", state_abb))

# Install if needed: install.packages("jsonlite")
library(jsonlite)

# Write to JSON with pretty formatting (indented)
write_json(map_app_clean_w_avgs, "map-app/roque_andrews_santos_2025_aqmd_county_air_quality_data.json", pretty = TRUE)
