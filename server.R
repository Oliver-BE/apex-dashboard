library(tidyverse)
library(shiny)
library(ggplot2)
library(lubridate)
library(plotly)
source("./global.R")

# Server -----------------------------------------------------------------------
server <- function(input, output, session) {

  # Reactive objects -----------------------------------------------------------
  # reactive DF for raw data
  all_games <- reactive({
     
    # Read in the specified inputs from UI
    chosen_person <- input$chosen_person
    chosen_stat <- input$chosen_stat
    min_survival_time <-  input$min_survival_time 
    
    # don't filter by player if we're looking at everyone
    if(chosen_person == "All") {
      df <- apex_df %>%
        filter(`Survival Time (min)` >= min_survival_time)
      
      # don't filter by statistic if we're looking at all stats
      if(chosen_stat == "All") {
        df <- df
      }
      
      else {
        df <- df %>%
          select(Player, chosen_stat)
      }
    }
  
    # otherwise, filter by player
    else {
      df <- apex_df %>%
        filter(Player == chosen_person, `Survival Time (min)` >= min_survival_time)
      
      # don't filter by statistic if we're looking at all stats
      if(chosen_stat == "All") {
        df <- df
      }
      
      else {
        df <- df %>%
          select(Player, chosen_stat)
      }
    }

    return(df)
  })
  
  # reactive df for summary stats datatable
  summary_stats <- reactive ({
    chosen_person <- input$chosen_person
    
    if(chosen_person == "All") {
      df <- summary_stats_df
    }
    
    else {
      df <- summary_stats_df %>% 
        filter(Player == chosen_person)
    }
   
    return(df)
      
  })
  
  # reactive df for leaderboard datatable
  leaderboard <- reactive ({
    chosen_stat <- input$chosen_stat
    
    if(chosen_stat == "All") {
      df <- leaderboard_df
    }
    
    else {
      df <- leaderboard_df %>% 
        filter(Statistic == paste("Most", chosen_stat))
    }
    
    return(df)
    
  })
  
  # kills over time
  kills_over_time <- reactive({
    
    
  })
  
  # reactive pie chart
  donut_c <- reactive({
    donut_chart <- all_games() %>% 
      group_by(`Legend used`) %>% 
      select(`Legend used`) %>% 
      drop_na()
    
    donut_chart <- donut_chart %>% 
      summarize(count = n())
    
    donut_fig <- donut_chart %>% 
      plot_ly(labels = ~`Legend used`, values = ~count) %>% 
      add_pie(hole = 0.6) %>% 
      layout(title = paste("Legends Used by", input$chosen_person),  showlegend = T,
             xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
             yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    
    return(donut_fig)
  })
  
  # Outputs --------------------------------------------------------------------
  # all games datatable output
  output$all_games_dt <- DT::renderDataTable(DT::datatable(all_games()))
  
  # summary stats datatable output
  output$summary_stats_dt <- DT::renderDataTable(DT::datatable(summary_stats()))
  
  # kills over time line chart
  output$kills_over_time_fig <- renderPlotly(kills_over_time()) 
  
  # leaderboard datatable output
  output$leaderboard_dt <- DT::renderDataTable(DT::datatable(leaderboard()))
  
  # pie chart output
  output$donut_fig <- renderPlotly(donut_c()) 
}
