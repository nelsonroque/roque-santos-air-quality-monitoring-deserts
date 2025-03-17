
# Model Fitting -----
# Model 1: without pop
model_no_pop <- glm(
  no_monitor ~ rural_label +
    pct_extractive +
    pct_poverty +
    pct_workage +
    pct_lessthan_hs +
    pct_hispanic +
    pct_black,
  data = merged,
  family = "binomial"
)

model_w_pop <- glm(
  no_monitor ~ rural_label +
    pct_extractive +
    pct_poverty +
    pct_workage +
    pct_lessthan_hs +
    pct_hispanic +
    pct_black +
    log10(B01001_001E),
  data = merged,
  family = "binomial"
)

merged_skim_report = skimr::skim(merged)
merged_skim_report

merged %>% filter(is.na(rural)) %>%
  select(FIPS, STFIPS, `State Code`)

