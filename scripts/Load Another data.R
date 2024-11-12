# This part is to load necessary packages.

library(tidyverse)
library(sf)
library(tidycensus)

# In short, this is to load the data from US census about the population of each
# race and sex in each year. The following data is used to load that specific data 
# from 2017.
year <- 2017

# Since a key is required for the US census, this part is to load the variables 
# in order to get actual data from US census.
vars_df <- load_variables(year, "acs5", cache = TRUE) |>
  filter(str_detect(concept, "^SEX BY AGE \\(.* ALONE\\)"))|> 
  filter(label %in% 
           c("Estimate!!Total:","Estimate!!Total:!!Male:","Estimate!!Total:!!Female:",
             "Estimate!!Total","Estimate!!Total!!Male","Estimate!!Total!!Female"))|>
  mutate(
    variable = name,
    sex = if_else(
      str_detect(label, "Male"),
      "Male", 
      if_else(
        str_detect(label, "Female"),
        "Female", 
        "Total"
      )
    ),
    race = str_extract(concept, "\\((.*) ALONE\\)", group = 1),
    .keep = "none"
  )

# And this data is the actual data in 2017 for the population of each race and sex.
race_df <- get_acs(
  geography = "state", 
  variables = vars_df |> pull(variable),
  year = year,
  geometry = TRUE
)|>
  left_join(vars_df) |>
  pivot_wider(names_from = c("sex", "race"), values_from = "estimate") |>
  subset(select = -c(GEOID, NAME, variable, moe)) |>
  st_drop_geometry() |>
  pivot_longer(cols = everything(), names_to = "Category", values_to = "val") |>
  group_by(Category) |>
  summarise(Total = sum(val, na.rm = T)) |>
  mutate(year = year,
         sex = sub("\\_.*", "", Category),
         race = sub('.*_', "", Category)
         ) |>
  subset(select = -c(Category))

# After the data is collected, they are all binded into the final dataset.
final <- race_df



# I used the same code for all the following years so the comments won't be repeated.
# the finished data is stored in the data set doc as Population by race and sex per year.rds.
year <- 2018
vars_df <- load_variables(year, "acs5", cache = TRUE) |>
  filter(str_detect(concept, "^SEX BY AGE \\(.* ALONE\\)"))|> 
  filter(label %in% 
           c("Estimate!!Total:","Estimate!!Total:!!Male:","Estimate!!Total:!!Female:",
             "Estimate!!Total","Estimate!!Total!!Male","Estimate!!Total!!Female"))|>
  mutate(
    variable = name,
    sex = if_else(
      str_detect(label, "Male"),
      "Male", 
      if_else(
        str_detect(label, "Female"),
        "Female", 
        "Total"
      )
    ),
    race = str_extract(concept, "\\((.*) ALONE\\)", group = 1),
    .keep = "none"
  )

race_df <- get_acs(
  geography = "state", 
  variables = vars_df |> pull(variable),
  year = year,
  geometry = TRUE
)|>
  left_join(vars_df) |>
  pivot_wider(names_from = c("sex", "race"), values_from = "estimate") |>
  subset(select = -c(GEOID, NAME, variable, moe)) |>
  st_drop_geometry() |>
  pivot_longer(cols = everything(), names_to = "Category", values_to = "val") |>
  group_by(Category) |>
  summarise(Total = sum(val, na.rm = T)) |>
  mutate(year = year,
         sex = sub("\\_.*", "", Category),
         race = sub('.*_', "", Category)
  ) |>
  subset(select = -c(Category))

final <- rbind(final, race_df)




year <- 2019
vars_df <- load_variables(year, "acs5", cache = TRUE) |>
  filter(str_detect(concept, "^SEX BY AGE \\(.* ALONE\\)"))|> 
  filter(label %in% 
           c("Estimate!!Total:","Estimate!!Total:!!Male:","Estimate!!Total:!!Female:",
             "Estimate!!Total","Estimate!!Total!!Male","Estimate!!Total!!Female"))|>
  mutate(
    variable = name,
    sex = if_else(
      str_detect(label, "Male"),
      "Male", 
      if_else(
        str_detect(label, "Female"),
        "Female", 
        "Total"
      )
    ),
    race = str_extract(concept, "\\((.*) ALONE\\)", group = 1),
    .keep = "none"
  )

race_df <- get_acs(
  geography = "state", 
  variables = vars_df |> pull(variable),
  year = year,
  geometry = TRUE
)|>
  left_join(vars_df) |>
  pivot_wider(names_from = c("sex", "race"), values_from = "estimate") |>
  subset(select = -c(GEOID, NAME, variable, moe)) |>
  st_drop_geometry() |>
  pivot_longer(cols = everything(), names_to = "Category", values_to = "val") |>
  group_by(Category) |>
  summarise(Total = sum(val, na.rm = T)) |>
  mutate(year = year,
         sex = sub("\\_.*", "", Category),
         race = sub('.*_', "", Category)
  ) |>
  subset(select = -c(Category))

final <- rbind(final, race_df)



year <- 2020
vars_df <- load_variables(year, "acs5", cache = TRUE) |>
  filter(str_detect(concept, "^SEX BY AGE \\(.* ALONE\\)"))|> 
  filter(label %in% 
           c("Estimate!!Total:","Estimate!!Total:!!Male:","Estimate!!Total:!!Female:",
             "Estimate!!Total","Estimate!!Total!!Male","Estimate!!Total!!Female"))|>
  mutate(
    variable = name,
    sex = if_else(
      str_detect(label, "Male"),
      "Male", 
      if_else(
        str_detect(label, "Female"),
        "Female", 
        "Total"
      )
    ),
    race = str_extract(concept, "\\((.*) ALONE\\)", group = 1),
    .keep = "none"
  )

race_df <- get_acs(
  geography = "state", 
  variables = vars_df |> pull(variable),
  year = year,
  geometry = TRUE
)|>
  left_join(vars_df) |>
  pivot_wider(names_from = c("sex", "race"), values_from = "estimate") |>
  subset(select = -c(GEOID, NAME, variable, moe)) |>
  st_drop_geometry() |>
  pivot_longer(cols = everything(), names_to = "Category", values_to = "val") |>
  group_by(Category) |>
  summarise(Total = sum(val, na.rm = T)) |>
  mutate(year = year,
         sex = sub("\\_.*", "", Category),
         race = sub('.*_', "", Category)
  ) |>
  subset(select = -c(Category))

final <- rbind(final, race_df)



year <- 2021
vars_df <- load_variables(year, "acs5", cache = TRUE) |>
  filter(str_detect(concept, "^SEX BY AGE \\(.* ALONE\\)"))|> 
  filter(label %in% 
           c("Estimate!!Total:","Estimate!!Total:!!Male:","Estimate!!Total:!!Female:",
             "Estimate!!Total","Estimate!!Total!!Male","Estimate!!Total!!Female"))|>
  mutate(
    variable = name,
    sex = if_else(
      str_detect(label, "Male"),
      "Male", 
      if_else(
        str_detect(label, "Female"),
        "Female", 
        "Total"
      )
    ),
    race = str_extract(concept, "\\((.*) ALONE\\)", group = 1),
    .keep = "none"
  )

race_df <- get_acs(
  geography = "state", 
  variables = vars_df |> pull(variable),
  year = year,
  geometry = TRUE
)|>
  left_join(vars_df) |>
  pivot_wider(names_from = c("sex", "race"), values_from = "estimate") |>
  subset(select = -c(GEOID, NAME, variable, moe)) |>
  st_drop_geometry() |>
  pivot_longer(cols = everything(), names_to = "Category", values_to = "val") |>
  group_by(Category) |>
  summarise(Total = sum(val, na.rm = T)) |>
  mutate(year = year,
         sex = sub("\\_.*", "", Category),
         race = sub('.*_', "", Category)
  ) |>
  subset(select = -c(Category))

final <- rbind(final, race_df)

saveRDS(final, file = here::here("dataset", "Population by race and sex per year.rds"))
