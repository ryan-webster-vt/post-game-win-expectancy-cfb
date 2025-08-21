library(cfbfastR)
library(tidyverse)
library(lubridate)

readRenviron("C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//.Renviron") # nolint
Sys.setenv(CFBD_API_KEY = Sys.getenv("API_KEY"))

today <- Sys.Date()

current_week <- cfbfastR::cfbd_calendar(2025) %>%
     filter(season_type == "regular" & start_date <= today) %>%
     arrange(desc(start_date)) %>%
     slice(1) %>%
     pull(week) %>%
     as.numeric()

pbp_week <- load_cfb_pbp(2025) %>%
     filter(week == current_week)

write.csv(pbp_week, "C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//new_df.csv")