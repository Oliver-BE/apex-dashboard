library(tidyverse)
library(shiny)

# Initial code ----------------------------------------------------------------- 
apex_df <- as.data.frame(read_sheet("https://docs.google.com/spreadsheets/u/1/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit#gid=13184181")) %>% 
  select(-c(...9, ...11, `Email Address`, `Game Number`))  

data(apex_df)