# This file is purely as an example.
# Note, you may end up creating more than one cleaned data set and saving that
# to separate files in order to work on different aspects of your project

library(tidyverse)

# This part loads the datas.

X2017 <- read_csv(here::here("dataset", "2017.csv"))
X2018 <- read_csv(here::here("dataset", "2018.csv"))
X2019 <- read_csv(here::here("dataset", "2019.csv"))
X2020 <- read_csv(here::here("dataset", "2020.csv"))
X2021 <- read_csv(here::here("dataset", "2021.csv"))

# This part turns the tables into a single one and
# removes some of those useless parts of the data.

# The headers for each table is removed because instead of 
# describing an actual object, it provides a description of 
# data in each column. 
# This could be useful when reading the table,
# but is completely useless and actually annoying when trying to analyse the data
all_data <- bind_rows(
  X2017[-1,],
  X2018[-1,],
  X2019[-1,],
  X2020[-1,],
  X2021[-1,]
) |> 
  # The following three columns are removed since they all maintain the same value
  # through the data. GEO_ID is always 001, which represents the US, Name is always 
  # united states, and ...24 is always NA
  select(-c(GEO_ID, NAME, ...24))


attach(all_data)

head(all_data)
summary(all_data)
names(all_data)

# Checking the missing values
# After checking, there are no current missing values in the data
# after removing ...24 column.
# but there might be other symbols representing NA in the data.
missing_values <- colSums(is.na(all_data))
print(missing_values)


# Convert YEAR to numeric if it's not already
all_data$YEAR <- as.numeric(all_data$YEAR)

# Convert categorical variables to factors
categorical_vars <- c("SEX", "SEX_LABEL", "ETH_GROUP", "ETH_GROUP_LABEL", 
                      "RACE_GROUP", "RACE_GROUP_LABEL", "VET_GROUP", 
                      "VET_GROUP_LABEL", "NAICS2017", "NAICS2017_LABEL")
all_data[categorical_vars] <- lapply(all_data[categorical_vars], as.factor)

# Checking data status again
summary(all_data)

# Checking years columns
unique(all_data$YEAR)

# Checking the NAICS2017_LABEL and NAICS2017 columns
unique(NAICS2017_LABEL)
unique(paste(NAICS2017_LABEL, NAICS2017))










