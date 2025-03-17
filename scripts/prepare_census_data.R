# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Load FIPS-to-State mapping
fips_to_state <- fips_codes %>%
  select(state_code, state_name) %>%
  distinct() %>%
  mutate(STFIPS = as.numeric(state_code))  # Ensure matching data type

# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# Compute derived variables
paper_data_computed <- paper_data %>%
  mutate(
    pct_poverty = B17001_002E / B17001_001E *100, # Poverty rate
    pct_black = B03002_004E / B03002_001E * 100, # % Non-Hispanic Black
    pct_hispanic = B03002_012E / B03002_001E * 100,
    pct_under18years = (B01001_003E + B01001_004E + B01001_005E + B01001_006E +
                          B01001_027E + B01001_028E + B01001_029E + B01001_030E) / B01001_001E * 100,
    pct_65andolder = (B01001_020E + B01001_021E + B01001_022E + B01001_023E +
                        B01001_024E + B01001_025E + B01001_044E + B01001_045E +
                        B01001_046E + B01001_047E + B01001_048E + B01001_049E) / B01001_001E * 100,
    pct_immobile_1yr = (B07003_004E + B07003_007E) / B07003_001E * 100,
    pct_lessthan_hs = (B15002_002E + B15002_003E + B15002_004E + B15002_005E +
                         B15002_006E + B15002_007E + B15002_008E + B15002_009E +
                         B15002_010E + B15002_011E + B15002_012E + B15002_013E +
                         B15002_014E + B15002_015E + B15002_016E) / B15002_001E * 100,
    pct_extractive = C24050_002E / C24050_001E * 100,
    pct_manufacturing = C24050_004E / C24050_001E * 100,
    pct_service = C24050_029E / C24050_001E * 100,
    pct_government = C24050_014E / C24050_001E * 100,
    pct_female_headed_hh = (B25011_013E + B25011_037E) / B25011_001E * 100,
    pct_unemployed = (B17005_006E + B17005_011E + B17005_017E + B17005_022E) / B17005_001E * 100,
    log_poverty = log(pct_poverty / (1 - pct_poverty)),
    noncit = (B05001_006E / B05001_001E) * 100
  ) %>%
  mutate(pct_workage = 100 - (pct_under18years + pct_65andolder)) %>%
  mutate(FIPS = as.character(GEOID))
