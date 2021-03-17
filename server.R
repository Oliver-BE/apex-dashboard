library(tidyverse)
library(shiny)
library(ggplot2)
library(lubridate)
library(googlesheets4)

# Server -----------------------------------------------------------------------
server <- function(input, output, session) {

  # reactive DF for raw data
  apex_data <- reactive({
     
    # Read in the specified inputs from UI
    chosen_person <- input$chosen_person
    chosen_stat <- input$chosen_stat
    min_survival_time <- input$min_survival_time
     
    #df <- read.csv("dummy_data.csv") %>%  
    
    # don't filter by player if we're looking at everyone
    if(input$chosen_person == "compare_all") {
      df <- apex_df #%>%
        #filter(`Survival Time` >= min_survival_time)
    }

    else {
      df <- apex_df %>%
        filter(Player == chosen_person)#, `Survival Time` >= min_survival_time)
    }

    return(df)
  })

  # player card output
  # print out data table
  output$player_card <- DT::renderDataTable(DT::datatable(apex_data()))
}