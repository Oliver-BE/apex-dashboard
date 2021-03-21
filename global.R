library(tidyverse)
library(shiny)
library(lubridate)
library(gsheet)

# Initial code ----------------------------------------------------------------- 
raw_apex_df <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit#gid=13184181") 

# initial cleaning: get rid of rows with all NAs, clean up survival time, etc. 
apex_df <- filter(raw_apex_df, rowSums(is.na(raw_apex_df)) != ncol(raw_apex_df)) %>% 
  mutate(Timestamp_raw = parse_date_time(Timestamp, orders = "mdy HMS", tz = "EST"),
         Timestamp = as.character(Timestamp_raw),
         survival_time_dt = strptime(`Survival Time`, format = "%M:%S"),
         `Survival Time (min)` = round(minute(survival_time_dt) + second(survival_time_dt) / 60, digits = 2)) %>% 
  select(-c(X9, X10, survival_time_dt, `Survival Time`, Timestamp_raw)) %>%
  arrange(desc(Timestamp))  

# summary stats df
summary_stats_df <- apex_df %>% 
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

# leaderboard df
leaderboard_df <- rbind(top_n(apex_df, 1, Damage) %>% 
                          mutate(Statistic = "Most Damage"),
                        top_n(apex_df, 1, Kills) %>% 
                          mutate(Statistic = "Most Kills"),
                        top_n(apex_df, 1, Assists) %>% 
                          mutate(Statistic = "Most Assists"),
                        top_n(apex_df, 1, Knocks) %>% 
                          mutate(Statistic = "Most Knocks"))

data(apex_df)
data(summary_stats_df)
data(leaderboard_df)