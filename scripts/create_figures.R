# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Load state boundaries (assuming `states_sf` contains state geometries)
states_sf <- merged %>%
  group_by(STFIPS) %>%
  summarise(geometry = st_union(geometry))  # Merge county geometries into states

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Create Figures -----

# Figure 1: Cumulative number of monitoring sites opened and closed over time
fig1_data <- station_list %>%
  mutate(
    `Site Established Date` = as.Date(`Site Established Date`, format="%Y-%m-%d"),
    `Site Closed Date` = as.Date(`Site Closed Date`, format="%Y-%m-%d"),
    `Established Year` = lubridate::year(`Site Established Date`),
    `Closed Year` = lubridate::year(`Site Closed Date`)
  ) %>%
  drop_na(`Established Year`) %>%
  mutate(`Closed Year` = replace_na(`Closed Year`, 9999))

# Define years range
years <- 1957:2024

# Compute cumulative counts for each year
cumulative_data <- tibble(Year = years) %>%
  rowwise() %>%
  mutate(
    `Stations Opened` = sum(fig1_data$`Established Year` <= Year, na.rm = TRUE),
    `Stations Closed` = sum(fig1_data$`Closed Year` <= Year & fig1_data$`Closed Year` != 9999, na.rm = TRUE),
    `Net Stations` = `Stations Opened` - `Stations Closed`,
    `Net Stations Increase` = `Net Stations` - lag(`Net Stations`, default = first(`Net Stations`))
  ) %>%
  mutate(legend_fix = -1) %>%
  mutate(major_legis = case_when(
    Year == 1970 ~ 1,
    Year == 1990 ~ 1,
    Year == 2016 ~ 1,
    Year == 2021 ~ 1,
    TRUE ~ NA_real_
  ))

major_legislation = c(1970,1990,2016,2021)

# Plot Figure 1
fig_1 = ggplot(cumulative_data, aes(x = Year)) +
  geom_line(aes(y = `Stations Opened`, color = "Stations Opened"), linewidth = 1.5) +
  geom_line(aes(y = `Stations Closed`, color = "Stations Closed"), linewidth = 1.5, linetype = "dashed") +
  # Add vertical lines for significant milestones
  geom_vline(xintercept=major_legislation, color = "black",linetype = "dotted") +
  labs(
    title = "",
    x = "Year",
    y = "Number of Sites",
    color = NULL
  ) +
  scale_color_manual(values = c("Stations Opened" = "seagreen",
                                "Stations Closed" = "seagreen")) +
  #scale_linetype_manual(values = c("Major Legislation" = "dotted")) +
  theme_bw() +
  theme(
    legend.position = "bottom",
    #legend.title = element_blank(),
    #axis.title = element_text(size = 14),
    legend.text = element_text(size = 12),
    axis.text = element_text(size = 12),
    plot.title = element_text(size = 14, hjust=0.5),
    legend.key.size.x = unit(2, "cm"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.5)
  ) +
  scale_y_continuous(labels = scales::comma)

fig_1

# Figure 2: County-level stats
# County-level presence of a monitoring site.
# Counties with an active monitoring site in 2024 are presented in green and
# those classified as monitoring deserts are presented in white.

fig_2 <- ggplot(merged, aes(fill = as.factor(no_monitor_label))) +
  # Plot county boundaries in gray
  geom_sf(data = merged, aes(fill = as.factor(no_monitor_label)),
          color = "black") +
  # Plot state boundaries in black
  geom_sf(data = states_sf, fill = NA, color = "black", size = 1) +
  scale_fill_manual(values = c("green4", "white")) +
  labs(
    x = NULL,
    y = NULL,
    caption = "",
    title = ""
  ) +
  theme_void() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    plot.title = element_text(size = 14),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 10)
  ) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))
fig_2

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


# Figure 3: County-level Stats (South Only)
# County-level presence of a monitoring site for the South.
# Counties with an active monitoring site in 2024 are presented in green and
# those classified as monitoring deserts are presented in white.
# County borders are shown in gray.
# State borders are shown in black.

# Create Figure
fig_3 <- ggplot(merged_subset_south,
                aes(fill = as.factor(no_monitor_label))) +
  # Plot county boundaries in gray
  geom_sf(data = merged_subset_south,
          aes(fill = as.factor(no_monitor_label)),
          color = "black") +
  # Plot state boundaries in black
  geom_sf(data = states_sf %>% filter(STFIPS %in% southern_states_fips),
          fill = NA, color = "black", size = 1) +
  scale_fill_manual(values = c("green4", "white")) +
  labs(
    x = NULL,
    y = NULL,
    caption = "",
    title = ""
  ) +
  theme_void() +
  theme(
    legend.title = element_blank(),
    legend.position = "bottom",
    plot.title = element_text(size = 14),
    plot.subtitle = element_text(size = 12),
    plot.caption = element_text(size = 10)
  ) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold"))

fig_3

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Plot with facet-specific median lines and text annotations
sup_fig1_medlabels <- ggplot(station_list_age_metadata_computed,
                             aes(site_age_years)) +
  geom_histogram(fill = "#16b300", color = "black") + # Green bars with black edges
  theme_bw() +
  facet_grid(is_metro ~ is_site_closed, scales = "free") +
  geom_vline(
    data = station_list_age_metadata_computed_median, aes(xintercept = median_age),
    linetype = "dashed", color = "black", linewidth = 1
  ) + # Thicker black vline
  geom_text(
    data = station_list_age_metadata_computed_median, aes(
      x = median_age, y = Inf,
      label = paste0("Median: ", round(median_age, 1), "")
    ),
    vjust = 1.5, hjust = 1.5, size = 4, color = "black", family = "sans",
    inherit.aes = FALSE, parse = FALSE
  ) + # Annotate median using ggtext
  labs(
    x = "Site Age (Years)",
    y = "Count",
    # title = "Distribution of Monitoring Site Ages by Location Setting",
    # subtitle = "Data from the EPA's Air Quality System (AQS) database",
    caption = "Source: https://aqs.epa.gov/aqsweb/airdata/download_files.html"
  ) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  theme(strip.text = element_text(face = "bold")) # Bold facet labels

fig_s1 <- ggplot(station_list_age_metadata_computed, aes(site_age_years)) +
  geom_histogram(fill = "#16b300", color = "black") + # Green bars with black edges
  theme_bw(base_size = 18) +
  facet_grid(is_metro ~ is_site_closed, scales = "free") +
  geom_vline(
    data = station_list_age_metadata_computed_median, aes(xintercept = median_age),
    linetype = "dashed", color = "black", linewidth = 1
  ) +
  labs(
    x = "Site Age (Years)",
    y = "Count",
    caption = "Source: https://aqs.epa.gov/aqsweb/airdata/download_files.html"
  ) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold")) +
  theme(strip.text = element_text(face = "bold", size = 16)) # Bold facet labels

fig_s1

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# save figures as 300 DPI
# FIG1 is in Python...
# Save figures with specified dimensions (e.g., 10 inches wide by 8 inches tall)
ggsave("figures/fig_1.pdf", fig_1, dpi = 300, width = 10, height = 8, units = "in")
ggsave("figures/fig_2.pdf", fig_2, dpi = 300, width = 10, height = 8, units = "in")
ggsave("figures/fig_3.pdf", fig_3, dpi = 300, width = 10, height = 8, units = "in")
ggsave("figures/fig_s1.pdf", fig_s1, dpi = 300, width = 10, height = 8, units = "in")

