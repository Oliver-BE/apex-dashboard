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
        filter(`Survival Time (min)` >= min_survival_time) %>% 
        arrange(desc(Timestamp)) %>% 
        select(-c(Timestamp_raw))
      
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
        filter(Player == chosen_person, `Survival Time (min)` >= min_survival_time) %>% 
        arrange(desc(Timestamp)) %>% 
        select(-c(Timestamp_raw))
      
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
    min_survival_time <-  input$min_survival_time 
    
    if(chosen_person == "All") {
      df <- apex_df %>% 
        filter(`Survival Time (min)` >= min_survival_time)
    }
    
    else {
      df <- apex_df %>% 
        filter(Player == chosen_person, `Survival Time (min)` >= min_survival_time)
    }
    
    df <- df %>% 
      group_by(Player) %>% 
      summarize(`Num Games Played` = n(),
                `Num Wins` = sum(ifelse(`Squad Placed` == 1, TRUE, FALSE)),
                `Total Damage` = sum(Damage),
                `Total Kills` = sum(Kills),
                `Total Assists` = sum(Assists),
                `Total Knocks` = sum(Knocks),
                `Total Survival Time` = sum(`Survival Time (min)`),
                `KDR` = round(`Total Kills` / `Num Games Played`, 2),
                `Damage Per Game` = round(`Total Damage` / `Num Games Played`, 0),
                `Damage Per Minute` = round(`Total Damage` / `Total Survival Time`, 1)) %>% 
      arrange(desc(`Num Games Played`))
    
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
  
  # over time line chart
  over_time <- reactive({
    
    chosen_person <- input$chosen_person
    chosen_stat <- input$chosen_stat
    
    # if "all" stats are chosen, this plot won't work (default to Damage)
    if(chosen_stat == "All") {
      updateSelectInput(session, inputId = "chosen_stat", selected = "Damage")
    }
    
    # if comparing all players, don't filter by player
    if(chosen_person == "All") {
      oliver_df <- apex_df %>% 
        filter(Player == "Oliver") %>% 
        mutate(`Game Number` = row_number())
      oliver_df <- cbind(oliver_df, "Cumulative Damage" = cumsum(oliver_df$Damage))
      
      connor_df <- apex_df %>% 
        filter(Player == "Connor") %>% 
        mutate(`Game Number` = row_number())
      connor_df <- cbind(connor_df, "Cumulative Damage" = cumsum(connor_df$Damage))
      
      isaac_df <- apex_df %>% 
        filter(Player == "Isaac") %>% 
        mutate(`Game Number` = row_number())
      isaac_df <- cbind(isaac_df, "Cumulative Damage" = cumsum(isaac_df$Damage))
      
      nat_df <- apex_df %>% 
        filter(Player == "Nat") %>% 
        mutate(`Game Number` = row_number())
      nat_df <- cbind(nat_df, "Cumulative Damage" = cumsum(nat_df$Damage))
      
      thomas_df <- apex_df %>% 
        filter(Player == "Thomas") %>% 
        mutate(`Game Number` = row_number())
      thomas_df <- cbind(thomas_df, "Cumulative Damage" = cumsum(thomas_df$Damage))
      
      df <- rbind(oliver_df, connor_df, isaac_df, nat_df, thomas_df)  
      
      fig <- plot_ly(df, x = ~`Timestamp_raw`, y = ~`Cumulative Damage`,
                     color = ~Player,
                     type = 'scatter', mode = 'lines') %>% 
              layout(title = paste(chosen_stat, "over time by", chosen_person),
                     showlegend = T,
                     xaxis = list(title = "Date"),
                     yaxis = list(title = paste("Cumulative", chosen_stat))) 
    }
    
    else {
      df <- apex_df %>% 
        filter(Player == chosen_person) %>% 
        mutate(`Game Number` = row_number())
      
      # sum up whatever stat we are looking at 
      df <- cbind(df, "Cumulative" = cumsum(df[[chosen_stat]]))
      new_column_name <- paste0("Cumulative_", chosen_stat)
      # rename "Cumulative" column (unfortunately can't do this in one step above)
      colnames(df)[colnames(df) == "Cumulative"] <- new_column_name
      print(new_column_name)
      glimpse(df)
      
      fig <- plot_ly(df, x = ~`Timestamp_raw`, y = ~new_column_name, 
                     type = 'scatter', mode = 'lines')  %>% 
              layout(title = paste(chosen_stat, "over time by", chosen_person),
                     xaxis = list(title = "Date"),
                     yaxis = list(title = paste("Cumulative", chosen_stat))) 
    }
     
    return(fig)
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
  output$over_time_fig <- renderPlotly(over_time()) 
  
  # leaderboard datatable output
  output$leaderboard_dt <- DT::renderDataTable(DT::datatable(leaderboard()))
  
  # pie chart output
  output$donut_fig <- renderPlotly(donut_c()) 
}
