library(tidyverse)
library(dplyr)

data <- readRDS(here::here("dataset", "Population by race and sex per year.rds"))
N_revenue <- readRDS(here::here("dataset", "cleaned_data_N_revenue.rds"))
W_revenue <- readRDS(here::here("dataset", "cleaned_data_W_revenue.rds"))

unique(data$race)
unique(N_revenue$RACE_GROUP_LABEL)
new <- N_revenue |>
  mutate(race = toupper(RACE_GROUP_LABEL),
         sex = toupper(SEX_LABEL),
         year = YEAR) |>
  left_join(data, by = c("race", "sex", "year"))
