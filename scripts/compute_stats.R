options(digits = 2) # Set number of digits to display)

# Compute stats scattered throughout the paper -----

# ✅
# Our estimates suggests that more than 50 million people or 15.38%
# (do we round to 15.3?) of the
# population live in air quality monitoring deserts.
pop_unmonitored_monitored <- merged %>%
  st_drop_geometry() %>%  # Drops the geometry column
  group_by(no_monitor) %>%
  summarize(
    total_pop = sum(B01001_001E)
  ) %>%
  mutate(perc = (total_pop / sum(total_pop))*100)
pop_unmonitored_monitored

# ✅
# Of the 20,815 monitoring sites that have been active since 1957,
# only 23.2% or 4,821 remain open.
sc_open_closed = station_list %>%
  count(is_station_open) %>%
  mutate(perc = n / sum(n))

sc_open_closed

sum(sc_open_closed$n) # total count (20815)

# ✅
# Our results indicate that 1848 or 58.8%, of US counties are an
# air quality monitoring desert
merged %>%
  st_drop_geometry() %>%  # Drops the geometry column
  group_by(no_monitor) %>%
  summarize(
    total_counties = n()) %>%
  mutate(perc = (total_counties / sum(total_counties))*100)

# ✅
# covering about 40% of the nation’s land area
land_area_deserts = merged %>%
  group_by(no_monitor) %>%
  summarise(sum_land = sum(ALAND, na.rm=T)) %>%
  mutate(perc = sum_land / sum(sum_land, na.rm=T))

# ✅
# Our analysis indicates that 15994
# of the 20815 monitoring sites
station_list %>%
  count(is_station_closed) %>%
  mutate(perc = n / sum(n))

# ✅
# We determined that 4,821 sites remained active within the US as
# of the month of the data release.
sum(station_list$is_station_open, na.rm = TRUE)

# The presence of monitoring deserts may be reflective of the non-adjacency to
# metropolitan areas (rurality), or low population size or density.
# Arizona, California, Massachusetts, Oregon, and Washington have less than 20% of
# their counties classified as a monitoring desert.

# Both Connecticut† and Delaware have full coverage with all counties
# having a monitoring site.
tbl_s1 %>% filter(state_name %in% c(
  "Connecticut", "Delaware"
)) %>%
  arrange(-rate) %>%
  knitr::kable(.) %>% kableExtra::kable_styling()

# On the other hand, states like
# Arkansas, Iowa, Kansas, Nebraska and South Dakota have approximately
# 80% or more of their counties classified as
# an air quality monitoring desert.
# ---
# At the state-level, more than 75% of the counties in
# Arkansas, Georgia, Mississippi, Texas and Virginia are
# classified as air quality monitoring deserts.
tbl_s1_filt = tbl_s1 %>%
  filter(state_name %in% c(
  "Arkansas", "Iowa", "Kansas", "Nebraska", "South Dakota", "Georgia",
  "Mississippi", "Texas", "Virginia"
)) %>%
  arrange(-rate)

mean(tbl_s1_filt$rate, na.rm=T)

tbl_s1_filt %>%
  knitr::kable(.) %>% kableExtra::kable_styling()

# Maryland, 25%
tbl_s1 %>% filter(state_name %in% c(
  "Maryland"
)) %>%
  arrange(-rate) %>%
  knitr::kable(.) %>% kableExtra::kable_styling()

# Overall, 1,848 counties (59.05%) lacked an air quality monitoring site.
# We observe substantial regional differences with the West and Northeast
# having fewer air quality monitoring deserts than the Great Plains, the
# Heartlands, and the South.

merged %>%
  count(no_monitor)

1848/3141 # total counties

# In Fig. 3, we focus on the Southern region and
# the presence of monitoring deserts. We found that 822 or
# 67% of the 1219
# counties contained in this region are classified as an air quality monitoring
# desert. By focusing on the Southern region, we can appreciate how the monitoring
# deserts are concentrated within what is known as the “Southern Black Belt” or
# the “Black Belt” (33). In contrast to states considered to be part of the South,
# we note that Maryland has 25% of the counties classified as air quality
# monitoring deserts. At the state-level, more than 75% of the counties in
# Arkansas, Georgia, Mississippi, Texas and Virginia are classified as
# air quality monitoring deserts.
south_states_counts = merged_subset_south %>%
  st_drop_geometry() %>%  # Drops the geometry column
  count(no_monitor) %>%
  mutate(perc = n / sum(n))

south_states_counts
sum(south_states_counts$n)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
