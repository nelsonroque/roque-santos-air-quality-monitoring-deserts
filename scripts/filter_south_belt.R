southern_states <- c("Alabama", "Arkansas", "Florida", "Georgia",
                       "Louisiana","Oklahoma","Maryland",
                       "Mississippi", "North Carolina", "South Carolina",
                       "Tennessee", "Texas", "Virginia")

length(southern_states)

southern_states_fips <- fips_to_state %>%
  filter(state_name %in% southern_states) %>%
  pull(STFIPS)

# Filter data for selected states
merged_subset_south <- merged %>%
  filter(STFIPS %in% southern_states_fips)

