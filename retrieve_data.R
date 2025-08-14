library(cfbfastR)
library(tidyverse)

Sys.setenv(CFBD_API_KEY = "DB6+nyKUOlLJ2/KBGQQLUDPdfYMa2ZSB1MZGRoUz3/NN+nI0oU3+NHh3O90PwrPI")

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

logistic_regression <- glm(
  home_win ~ total_home_EPA, 
  family = "binomial",
  data = result
)

pred_df <- result %>% ungroup() %>% 
  mutate(
    predicted_prob = predict(logistic_regression, type = "response"),
    predicted_home_win = if_else(predicted_prob > 0.5, 1, 0)
  )

confusionMatrix(
  factor(pred_df$predicted_home_win),
  factor(pred_df$home_win)
)

okst <- pbp %>% filter(home == "Oklahoma")
