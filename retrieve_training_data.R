library(cfbfastR)
library(tidyverse)

readRenviron(file.path(getwd(), ".Renviron")) 
Sys.setenv(CFBD_API_KEY = Sys.getenv("API_KEY"))

pbp <- map_dfr(2021:2024, load_cfb_pbp)

epas <- pbp %>% 
  group_by(game_id) %>% 
  arrange(game_play_number) %>% 
  slice_tail(n = 1) %>% 
  select(game_id, home, away, total_home_EPA, total_away_EPA) %>% 
  ungroup()

game_results <- map_dfr(2021:2024, ~ espn_cfb_schedule(.x) %>% mutate(season = .x)) %>%
  filter(type == "regular") %>%
  mutate(game_id = as.numeric(game_id)) %>%
  select(season, game_id, home_win)


result <- inner_join(epas, game_results, by = "game_id")

write_csv(result, file.path(getwd(), "df.csv"))

