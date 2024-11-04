data <- readRDS(here::here("dataset/cleaned_data_N_revenue.rds"))

data

# Basic data exploration
str(data)
summary(data)


## Average Employment Trends by Race

library(ggplot2)
library(dplyr)
library(scales)

# Function to format numbers in millions
format_m <- function(x) {
  paste0(round(x/1000000, 1), "M")
}

# Employment trends by race
data %>%
  filter(!RACE_GROUP_LABEL %in% c("Total", "Unclassifiable", "Classifiable")) %>%
  group_by(YEAR, RACE_GROUP_LABEL) %>%
  summarise(avg_employment = mean(EMP), .groups = 'drop') %>%
  ggplot(aes(x = YEAR, y = avg_employment, color = RACE_GROUP_LABEL)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3, alpha = 0.8) +
  theme_minimal() +
  labs(title = "Average Employment Trends by Race",
       subtitle = "Excluding Total, Unclassifiable, and Classifiable categories",
       x = "Year",
       y = "Average Number of Employees (M)",
       color = "Race") +
  scale_y_continuous(labels = format_m) +
  theme(legend.position = "bottom",
        legend.text = element_text(size = 8),
        panel.grid.minor = element_blank())


