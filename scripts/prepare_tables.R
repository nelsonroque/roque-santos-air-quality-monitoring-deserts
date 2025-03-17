# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Compute tables -----

# State-level rates for monitoring deserts
# are included in SI Appendix, Table S1.
#  Percent of counties by state that are considered
# an Air Quality Monitoring Desert in September 2024
# SOMETHING NOT RIGHT HERE

### State counts
options(digits=3)
tbl_s1_nomonitor <- merged %>%
  st_set_geometry(NULL) %>%
  group_by(STFIPS) %>%
  summarize(
    county_coverage = sum(no_monitor),
    total_count = n(),
    rate = county_coverage / total_count*100
  ) %>%
  filter(STFIPS < 65) %>%
  inner_join(fips_to_state) %>%
  select(state_name, state_code, county_coverage, total_count, rate)

tbl_s1_hasmonitor <- merged %>%
  st_set_geometry(NULL) %>%
  group_by(STFIPS) %>%
  summarize(
    county_coverage = sum(has_monitor),
    total_count = n(),
    rate = county_coverage / total_count*100
  ) %>%
  filter(STFIPS < 65) %>%
  inner_join(fips_to_state) %>%
  select(state_name, state_code, county_coverage, total_count, rate)

knitr::kable(tbl_s1_nomonitor) %>% kableExtra::kable_classic(.)
knitr::kable(tbl_s1_hasmonitor) %>% kableExtra::kable_classic(.)

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Produce Supplemental Table 2 -----
tbl_s2 = sjPlot::tab_model(model_no_pop, model_w_pop,
                           show.intercept = F,
                  pred.labels = c(
                                  "Nonmetropolitan County",
                                  "% Extractive Actitivities",
                                  "% Living in Poverty",
                                  "% Working-Age Adults",
                                  "% Adults 25 + without HS Diploma",
                                  "% Hispanic",
                                  "% Non-Hispanic Black",
                                  "Total Population (log scale)"),
                  dv.labels = c("Model 1", "Model 2"),
                  string.pred = "Characteristic",
                  string.ci = "95% CI",
                  string.p = "p-value")

tbl_s2

# get tidy model results table ----
model_no_pop_tidy = broom::tidy(model_no_pop,
                                exponentiate = T) %>%
  mutate(model = "Model 1") %>%
  mutate(model_description = "Model without population")

model_w_pop_tidy = broom::tidy(model_w_pop,
                               exponentiate = T) %>%
  mutate(model = "Model 2") %>%
  mutate(model_description = "Model with population")

models_tidy = bind_rows(model_no_pop_tidy, model_w_pop_tidy)
