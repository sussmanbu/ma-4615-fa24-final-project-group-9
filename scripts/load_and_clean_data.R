# This file is purely as an example.
# Note, you may end up creating more than one cleaned data set and saving that
# to separate files in order to work on different aspects of your project



#loan_data <- read_csv(here::here("dataset", "loan_refusal.csv"))
library(tidyverse)
all_data <- bind_rows(
  X2017 %>% mutate(year = 2017),
  X2018 %>% mutate(year = 2018),
  X2019 %>% mutate(year = 2019),
  X2020 %>% mutate(year = 2020),
  X2021 %>% mutate(year = 2021)
)

head(all_data)
summary(all_data)
all_data %>%
  count(year)

names(all_data)

## CLEAN the data
loan_data_clean <- loan_data |>
  pivot_longer(2:5, names_to = "group", values_to = "refusal_rate")

write_rds(loan_data_clean, file = here::here("dataset", "loan_refusal_clean.rds"))


