################## LOAD PACKAGES ####################
library(tidyverse)
library(shiny)
library(shinythemes)  
library(shinycssloaders) 


# UI  --------------------------------------------------------------------------
ui <- fluidPage(
  # set theme
  theme = shinytheme("yeti"),
  # shinythemes::themeSelector(),
  
  # set favicon
  tags$head(tags$link(rel="shortcut icon", href="./www/favicon.ico")),

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
          "Compare All" = "compare_all",
          "Oliver" = "Oliver",
          "Nat" = "Nat",
          "Isaac" = "Isaac",
          "Connor" = "Connor"
        ),
        selected = "compare_all"
      )
    ),
    column(
      width = 2,
      selectInput(
        inputId = "chosen_stat",
        label = "Choose a statistic: ",
        choices = c(
          "All" = "all",
          "Damage" = "Damage",
          "Kills" = "Kills",
          "Assists" = "Assists",
          "Knocks" = "Knocks",
          "Survival Time" = "Survival Time",
          "Squad Placement" = "Squad Placed" 
        ),
        selected = "all"
      )
    ), 
    column(
      width = 5,
      sliderInput(
        inputId = "min_survival_time",
        label = "Filter by minimum survival time (in minutes):",
        min = 0, max = 20, value = 0, step = 0.5,
        ticks = TRUE
      )
    )
  ),

  hr(),
  plotlyOutput("donut_fig") %>% withSpinner(),#color = "#228B22"),
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
            "All Games",
            br(),
            shinycssloaders::withSpinner(
              # print("add summary stats, photo, bio, main, etc. (make it
              #       look like an apex card")
              DT::dataTableOutput(
                outputId = "all_games"
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
