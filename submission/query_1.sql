INSERT INTO bootcamp.nba_game_details
-- The following CTE will enumerate duplicate records by aggregating the number
-- of rows for each unique combination of game_id, team_id, and player_id.
WITH deduped AS (
SELECT
  *,
  ROW_NUMBER() OVER (PARTITION BY game_id, team_id, player_id) AS row_number
FROM bootcamp.nba_game_details
)
-- The following query will insert the first row of each unique combination of
-- game_id, team_id, and player_id into the bootcamp.nba_game_details table.
-- This can be run as an INSERT OVERWRITE to replace the existing table.
-- The deduplicated table has 668,339 records (originally 668,628).
SELECT
  game_id,
  team_id,
  team_abbreviation,
  team_city,
  player_id,
  player_name,
  nickname,
  start_position,
  comment,
  min,
  fgm,
  fga,
  fg_pct,
  fg3m,
  fg3a,
  fg3_pct,
  ftm,
  fta,
  ft_pct,
  oreb,
  dreb,
  reb,
  ast,
  stl,
  blk,
  to,
  pf,
  pts,
  plus_minus
FROM deduped
WHERE row_number = 1