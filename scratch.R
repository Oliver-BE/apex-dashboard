apex_df <- gsheet2tbl("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit#gid=13184181") %>%   
  drop_na() %>%
  mutate(survival_time_dt = strptime(`Survival Time`, format = "%M:%S"),
         `Survival Time` = minute(survival_time_dt) + second(survival_time_dt) / 60) %>% 
  select(-c(survival_time_dt)) %>%
  arrange(desc(Timestamp))

glimpse(apex_df)
