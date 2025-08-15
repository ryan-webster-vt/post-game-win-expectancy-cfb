library(cfbfastR)
library(tidyverse)

readRenviron("C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//.Renviron")
Sys.setenv(CFBD_API_KEY = Sys.getenv("API_KEY"))

pbp <- cfbfastR::load_cfb_pbp(2024)

epas <- pbp %>% 
  group_by(game_id) %>% 
  arrange(game_play_number) %>% 
  slice_tail(n = 1) %>% 
  select(game_id, home, away, total_home_EPA, total_away_EPA) %>% 
  ungroup()

game_results <- cfbfastR::espn_cfb_schedule(2024) %>% 
  filter(type == "regular") %>% 
  mutate(game_id = as.numeric(game_id)) %>% 
  select(game_id, home_win)

result <- inner_join(epas, game_results, by = "game_id")

write_csv(result, "C://Users//rpwju//OneDrive//Desktop//post-game-win-expectancy-cfb//df.csv")

print("Data Retrieval Complete!")

