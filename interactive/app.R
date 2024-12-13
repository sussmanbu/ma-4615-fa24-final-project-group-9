#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


library(shiny)
library(tidyverse)
data <- readRDS(here::here("dataset/cleaned_data_W_revenue_combined.rds")) |>
  mutate(average_income = PAYANN / EMP * 1000) |>
  filter(
    VET_GROUP_LABEL == "Total",
    NAICS2017_LABEL == "Total for all sectors",
    ETH_GROUP_LABEL == "Total",
    SEX_LABEL == "Total",
  )

# Define UI for application that draws a histogram
ui <- fluidPage(

  # App title ----
  titlePanel("The change of income for employees in certain groups throughout recent years"),
  actionButton("show_Race", "Show/Hide Race choice"),
  conditionalPanel(
    condition = "input.show_Race % 2 == 1",  # Shows this panel when button 1 is clicked
    fluidRow(
      selectInput("Race", "Choose the races",
                  unique(data$RACE_GROUP_LABEL),
                  selected = "Total",
                  multiple = TRUE)
    )
  ),
  actionButton("show_Age", "Show/Hide Years in industry choice"),
  conditionalPanel(
    condition = "input.show_Age % 2 == 1",  # Shows this panel when button 2 is clicked
    fluidRow(
      selectInput("Age", "Choose the Years in industry",
                  unique(data$YIBSZFI_LABEL),
                  selected = "Firms with less than 2 years in business",
                  multiple = TRUE),
    )
  ),   
  mainPanel(
    plotOutput(outputId = "distPlot"),
    style = "width: 800px; height: 500px" 
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$distPlot <- renderPlot({
    data |>
      filter(
        RACE_GROUP_LABEL %in% input$Race,
        YIBSZFI_LABEL %in% input$Age
      ) |>
      subset(select = c(average_income, YEAR, RACE_GROUP_LABEL, YIBSZFI_LABEL)) |>
      group_by(RACE_GROUP_LABEL) |>
      ggplot() +
      geom_line(aes(x = YEAR, y = average_income, color = RACE_GROUP_LABEL, linetype = YIBSZFI_LABEL)) +
      labs(color = 'Race category', 
           linetype = "Years in business") +
      ylab("Average income / $")
  })  
}

# Run the application 
shinyApp(ui = ui, server = server)
