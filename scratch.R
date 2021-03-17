apex_df <- as.data.frame(read_sheet("https://docs.google.com/spreadsheets/d/1v40AgpaoRrA3v5eEjztB5Rw_OGKRHw3L56hhJdzdqAs/edit?usp=sharing")) %>% 
  select(-c(...9, ...11, `Email Address`, `Game Number`))  %>% 
  drop_na()

