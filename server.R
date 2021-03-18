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
  
donut_chart <- apex_df %>% group_by(`Legend used`) %>% 
  select(`Legend used`) %>% 
  drop_na()
donut_chart <- donut_chart %>% summarize(count = n())
donut_fig <- donut_chart %>% plot_ly(labels = ~`Legend used`, values = ~count) %>% 
  add_pie(hole = 0.6) %>% 
  layout(title = "Legends Used",  showlegend = T,
                      xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                      yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))

  output$donut_fig <- renderPlotly(donut_fig) 
  # player card output
  # print out data table
  output$all_games <- DT::renderDataTable(DT::datatable(apex_data()))
}
