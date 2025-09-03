library(cfbfastR)
library(tidyverse)
library(lubridate)

readRenviron(file.path(getwd(), ".Renviron")) 
Sys.setenv(CFBD_API_KEY = Sys.getenv("API_KEY"))

today <- Sys.Date()

current_week <- cfbfastR::cfbd_calendar(2025) %>%
     filter(season_type == "regular" & start_date <= today) %>%
     arrange(desc(start_date)) %>%
     slice(1) %>%
     pull(week) %>%
     as.numeric()

game_ids <- cfbfastR::espn_cfb_schedule(2025) %>%
     filter(type == "regular" & game_date <= today) %>%
     select(game_id)

pbp <- map_dfr(game_ids$game_id, function(game_id) {
  tryCatch(
    cfbd_pbp_data(game_id, epa_wpa = TRUE),
    error = function(e) NULL
  )
})

out <- cfbfastR::espn_cfb_pbp(401756846, epa_wpa = TRUE)

out <- cfbfastR::load_cfb_pbp(seasons = 2025, week = 1)

write_csv(result, file.path(getwd(), "new_df.csv"))
