library(tidyverse)
library(shiny)
library(googlesheets4)

# Initial code ----------------------------------------------------------------- 
gs4_deauth()

apex_df <- as.data.frame(read_sheet("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit?usp=sharing")) %>%
 select(-c(...9, ...11, `Email Address`, `Game Number`))

data(apex_df)