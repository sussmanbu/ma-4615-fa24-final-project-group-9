# Importing necessary packages and data

library(tidyverse)
library(dplyr)

data <- readRDS(here::here("dataset", "Population by race and sex per year.rds"))
N_revenue <- readRDS(here::here("dataset", "cleaned_data_N_revenue.rds"))
W_revenue <- readRDS(here::here("dataset", "cleaned_data_W_revenue.rds"))

# Changing the second data set to a similar condition to the 
# original data sets we have. The equally male and female is calculated by dividing 
# total population with same category by 2. And the Total in race is computed
# by summing all the population with same category up.

data$sex <- toupper(data$sex)
data_combined <- bind_rows(data,
                  data |>
                    group_by(sex, year) |>
                    summarise(across(Total, sum), .groups = "drop") |>
                    mutate(race = "TOTAL")
                  )
data_combined <- bind_rows(data_combined,
            data_combined |>
              group_by(race, year) |>
              summarise(across(Total, sum) / 4, .groups = "drop") |>
              mutate(sex = "EQUALLY MALE/FEMALE")
            )

# This is to combine the data together. 
# Those races are put away because they are already included in other race categories
# and we don't have the exact population of those races in the second dataset.

race_list <- unique(data_combined$race)
N_revenue_combined <- N_revenue |>
  filter(!RACE_GROUP_LABEL %in% c("Asian Indian", "Chinese", "Japanese",
                                  "Filipino", "Korean", "Vietnamese",
                                  "Other Asian", "Native Hawaiian","Guanmanian  or Chamorro",
                                  "Samoan", "Other Pacific Islander")) |>
  mutate(race = ifelse(toupper(RACE_GROUP_LABEL) %in% race_list, 
                       toupper(RACE_GROUP_LABEL),
                       "SOME OTHER RACE"),
         sex = toupper(SEX_LABEL),
         year = YEAR) |>
  left_join(data_combined, by = c("race", "year"), relationship = "many-to-many") |>
  filter(!is.na(Total), sex.x == sex.y) |>
  mutate(Population = Total) |>
  subset(select = -c(sex.x, sex.y, race, year, Total))

W_revenue_combined <- W_revenue |>
  filter(!RACE_GROUP_LABEL %in% c("Asian Indian", "Chinese", "Japanese",
                                  "Filipino", "Korean", "Vietnamese",
                                  "Other Asian", "Native Hawaiian","Guanmanian  or Chamorro",
                                  "Samoan", "Other Pacific Islander")) |>
  mutate(race = ifelse(toupper(RACE_GROUP_LABEL) %in% race_list, 
                       toupper(RACE_GROUP_LABEL),
                       "SOME OTHER RACE"),
         sex = toupper(SEX_LABEL),
         year = YEAR) |>
  left_join(data_combined, by = c("race", "year"), relationship = "many-to-many") |>
  filter(!is.na(Total), sex.x == sex.y) |>
  mutate(Population = Total) |>
  subset(select = -c(sex.x, sex.y, race, year, Total))

# The following code is to save the new combined datas
saveRDS(N_revenue_combined, here::here("dataset", "cleaned_data_N_revenue_combined.rds"))
saveRDS(W_revenue_combined, here::here("dataset", "cleaned_data_W_revenue_combined.rds"))
