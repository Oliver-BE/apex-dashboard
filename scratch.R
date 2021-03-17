raw_apex_df <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit#gid=13184181") 

# get rid of rows with all NAs 
apex_df <- filter(raw_apex_df, rowSums(is.na(raw_apex_df)) != ncol(raw_apex_df)) %>% 
  mutate(survival_time_dt = strptime(`Survival Time`, format = "%M:%S"),
        `Survival Time (min)` = round(minute(survival_time_dt) + second(survival_time_dt) / 60, digits = 2)) %>% 
  select(-c(X9, X10, survival_time_dt, `Survival Time`)) %>%
  arrange(desc(Timestamp)) 

glimpse(apex_df)
