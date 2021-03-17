library(tidyverse)
library(shiny)
library(lubridate)
library(googlesheets4)

# Initial code ----------------------------------------------------------------- 
gs4_deauth()

apex_df <- as.data.frame(read_sheet("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit?usp=sharing")) %>%
  select(-c(...9, ...12, ...13, `Email Address`, `Game Number`,
            `Select the only loba`)) %>%
  drop_na() %>%
  # mutate(Timestamp = parse_date_time(Timestamp, orders = "%m/%d/%y %H:%M:%S")) %>%
  arrange(desc(Timestamp))

data(apex_df)