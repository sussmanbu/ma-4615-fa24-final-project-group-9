# This file is purely as an example.
# Note, you may end up creating more than one cleaned data set and saving that
# to separate files in order to work on different aspects of your project

library(tidyverse)

# This part loads the data.

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
# Since they are exactly matched, it would be proper to only leave one column for 
# information, and remove one to make the data easier to deal with
all_data <- select(all_data, -c(NAICS2017))

# The same goes for Sex and Sex_label, ETH_group and ETH_group_label, Race_group and
# Race_group label, Vet_group and Vet_group_label and YIBSZFI and YIBSZFI_label.
unique(SEX_LABEL)
unique(paste(SEX_LABEL, SEX))
unique(ETH_GROUP_LABEL)
unique(paste(ETH_GROUP_LABEL, ETH_GROUP))
unique(RACE_GROUP_LABEL)
unique(paste(RACE_GROUP_LABEL, RACE_GROUP))
unique(VET_GROUP_LABEL)
unique(paste(VET_GROUP_LABEL, VET_GROUP))
unique(YIBSZFI_LABEL)
unique(paste(YIBSZFI_LABEL, YIBSZFI))

all_data <- select(all_data, -c(SEX, ETH_GROUP, RACE_GROUP, VET_GROUP, YIBSZFI))

# Now we are going into the supposedly numerical data. However, taking a closer look, 
# we can see in many rows, there are values represented by S and D, which upon looking up,
# have a near meaning to NA values. So they also needed to be cleared out.
all_data[c("FIRMPDEMP", "FIRMPDEMP_S", "RCPPDEMP", 
           "RCPPDEMP_S", "EMP", "EMP_S", "PAYANN", "PAYANN_S")] <- 
  lapply(all_data[c("FIRMPDEMP", "FIRMPDEMP_S", "RCPPDEMP", 
                    "RCPPDEMP_S", "EMP", "EMP_S", "PAYANN", "PAYANN_S")],
         as.numeric)
filter(all_data, is.na(FIRMPDEMP))
filter(all_data, is.na(RCPPDEMP))
filter(all_data, is.na(EMP))
filter(all_data, is.na(PAYANN))

# Taking a look of those filtered data, we found that there are 24113 rows of data that
# contains completely no numerical data, which implies them wouldn't be very helpful
# for most of the studies we are going to conduct. However,
# there are also 26696 rows that only don't have the column RCPPDEMP and RCPPDEMP_S,
# which are the revenue and revenue standard error for the firms. Those rows
# will still be useful when conducting other studies, just not useful when we are trying to
# know the relation between revenue and others, so two tables are made here.
# One remove the revenue column and leave those rows with na revenue,
# the other keep the revenue column and remove the rows with na revenue.

data_W_revenue <- filter(all_data, !is.na(FIRMPDEMP)) |>
  select(-c(RCPPDEMP, RCPPDEMP_S))
colSums(is.na(data_W_revenue))

data_N_revenue <- filter(all_data, !is.na(RCPPDEMP))
colSums(is.na(data_N_revenue))

# As shown, both data left no na values inside itself, and they shall be output
# and saved as rds.
saveRDS(data_W_revenue, file = here::here("dataset", "cleaned_data_W_revenue.rds"))
saveRDS(data_N_revenue, file = here::here("dataset", "cleaned_data_N_revenue.rds"))
