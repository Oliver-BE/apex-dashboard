################## LOAD PACKAGES ####################
library(tidyverse)
library(shiny)
library(shinythemes)  
library(shinycssloaders) 


# UI  --------------------------------------------------------------------------
ui <- fluidPage(
  # theme = shinytheme("flatly"),
  shinythemes::themeSelector(),

  navbarPage(title = "Apex Dashboard"),

  # Row 1 (inputs)
  fluidRow( 
    column(
      width = 2,
      img(
        src = "apex_logo.png", height = 50
      ),
      align = "center"
    ), 
    
    column(
      width = 3,
      selectInput(
        inputId = "chosen_person",
        label = "Choose your Apex legend: ",
        choices = c(
          "Oliver" = "Oliver",
          "Nat" = "Nat",
          "Isaac" = "Isaac",
          "Connor" = "Connor",
          "Compare All" = "compare_all"
        ),
        selected = "oliver"
      )
    ),
    column(
      width = 2,
      selectInput(
        inputId = "chosen_stat",
        label = "Choose a statistic: ",
        choices = c(
          "Damage" = "damage",
          "Kills" = "kills",
          "Assists" = "assists",
          "Knocks" = "knocks",
          "Survival Time" = "survival_time",
          "Squad Placement" = "squad_place" 
        ),
        selected = "damage"
      )
    ), 
    column(
      width = 5,
      sliderInput(
        inputId = "min_survival_time",
        label = "Filter by minimum survival time (in minutes)",
        min = 0, max = 15, value = 0, step = 0.5,
        ticks = TRUE
      )
    )
  ),

  hr(),

  # Row 3 (text output and plots)
  fluidRow(  
    # column to output plots (as tabs)
    column(
      width = 12,
      shinycssloaders::withSpinner(
        tabsetPanel(
          type = "tabs",
          tabPanel(
            "Player Card",
            br(),
            shinycssloaders::withSpinner(
              # print("add summary stats, photo, bio, main, etc. (make it
              #       look like an apex card")
              DT::dataTableOutput(
                outputId = "player_card"
              )
            )
          ),
          tabPanel(
            "Other plot",
            shinycssloaders::withSpinner(
              print("Hi")
              # plotOutput("")
            )
          ),
          tabPanel(
            "Play Statistics",
            shinycssloaders::withSpinner(
              print("Hi")
              # plotOutput("")
            )
          )
        )
      ),
      style = "padding:10px 10px 10px 10px;"
    ),
    
  ) # end row 3
) # end UI
