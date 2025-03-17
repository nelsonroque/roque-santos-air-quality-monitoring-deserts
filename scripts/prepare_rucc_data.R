# Load RUCA 2013 codes -----
rucc <- readxl::read_excel("data/ruralurbancodes2013.xls") %>%
  mutate(rural = case_when(
    RUCC_2013 > 3 ~ 1,
    TRUE ~ 0
  )) %>%
  mutate(
    rural_label = factor(case_when(
      RUCC_2013 > 3 ~ "Rural",
      TRUE ~ "Metropolitan"
    ), levels = c("Metropolitan", "Rural")) # Ensures "Metropolitan" is reference
  ) %>%
  mutate(FIPS_length = str_length(FIPS)) %>%
  mutate(FIPS = ifelse(FIPS == "46113", "46102",FIPS)) %>%
  mutate(FIPS = ifelse(FIPS == "02270","02158", FIPS))
