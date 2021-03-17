library(tidyverse)
library(shiny)
library(lubridate)
library(gsheet)

# Initial code ----------------------------------------------------------------- 
apex_df <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit#gid=13184181") %>%   
  drop_na() %>%
  mutate(survival_time_dt = strptime(`Survival Time`, format = "%M:%S"),
         `Survival Time (min)` = round(minute(survival_time_dt) + second(survival_time_dt) / 60, digits = 2)) %>% 
  select(-c(survival_time_dt)) %>%
  arrange(desc(Timestamp)) 

data(apex_df)