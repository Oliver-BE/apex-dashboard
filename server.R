library(tidyverse)
library(shiny)
library(ggplot2)
library(lubridate)
source("./global.R")

# Server -----------------------------------------------------------------------
server <- function(input, output, session) {

  # reactive DF for raw data
  apex_data <- reactive({
     
    # Read in the specified inputs from UI
    chosen_person <- input$chosen_person
    chosen_stat <- input$chosen_stat
    min_survival_time <-  input$min_survival_time 
    
    # don't filter by player if we're looking at everyone
    if(chosen_person == "compare_all") {
      df <- apex_df %>%
        filter(`Survival Time (min)` >= min_survival_time)
      
      # don't filter by statistic if we're looking at all stats
      if(chosen_stat == "all") {
        df <- df
      }
      
      else {
        df <- df %>%
          select(Player, chosen_stat)
      }
    }

    else {
      df <- apex_df %>%
        filter(Player == chosen_person, `Survival Time (min)` >= min_survival_time)
      
      # don't filter by statistic if we're looking at all stats
      if(chosen_stat == "all") {
        df <- df
      }
      
      else {
        df <- df %>%
          select(Player, chosen_stat)
      }
    }
    

    return(df)
  })

  # player card output
  # print out data table
  output$all_games <- DT::renderDataTable(DT::datatable(apex_data()))
}