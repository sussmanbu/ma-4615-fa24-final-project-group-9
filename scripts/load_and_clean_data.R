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
missing_values <- colSums(is.na(all_data))
print(missing_values)
all_data <- all_data[, -which(names(all_data) == "...24")]

# Convert YEAR to numeric if it's not already
all_data$YEAR <- as.numeric(all_data$YEAR)

# Convert categorical variables to factors
categorical_vars <- c("SEX", "SEX_LABEL", "ETH_GROUP", "ETH_GROUP_LABEL", 
                      "RACE_GROUP", "RACE_GROUP_LABEL", "VET_GROUP", 
                      "VET_GROUP_LABEL", "NAICS2017", "NAICS2017_LABEL")
all_data[categorical_vars] <- lapply(all_data[categorical_vars], as.factor)

##years column
unique(all_data$YEAR)











