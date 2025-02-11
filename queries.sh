#!/bin/bash

# Define the PSQL variable for connecting to the worldcup database
PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# 1. Total number of goals in all games from winning teams:
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

# 2. Total number of goals in all games from both teams combined:
echo "$($PSQL "SELECT SUM(winner_goals + opponent_goals) FROM games;")"

# 3. Average number of goals in all games from the winning teams (formatted to exactly 3 decimal places):
echo "$($PSQL "SELECT to_char(AVG(winner_goals), 'FM9.999') FROM games;")"

# 4. Average number of goals in all games from the winning teams rounded to two decimal places:
echo "$($PSQL "SELECT ROUND(AVG(winner_goals),2) FROM games;")"

# 5. Average number of goals in all games from both teams (formatted to exactly 4 decimal places):
echo "$($PSQL "SELECT to_char(AVG(winner_goals + opponent_goals), 'FM9.9999') FROM games;")"

# 6. Most goals scored in a single game by one team:
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games;")"

# 7. Number of games where the winning team scored more than two goals:
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2;")"

# 8. Winner of the 2018 tournament:
echo "$($PSQL "SELECT name FROM teams JOIN games ON teams.team_id = games.winner_id WHERE year=2018 AND round='Final';")"

# 9. List of teams that played in the 2014 Eighth-Final round (as a comma-separated list):
echo "$($PSQL "SELECT string_agg(name, ', ') FROM (SELECT name FROM teams WHERE team_id IN (SELECT winner_id FROM games WHERE year=2014 AND round='Eighth-Final') OR team_id IN (SELECT opponent_id FROM games WHERE year=2014 AND round='Eighth-Final') ORDER BY name) AS sub;")"

# 10. List of unique winning team names in the whole tournament, ordered alphabetically (as a comma-separated list):
echo "$($PSQL "SELECT string_agg(name, ', ') FROM (SELECT DISTINCT(name) FROM teams WHERE team_id IN (SELECT winner_id FROM games) ORDER BY name) AS sub;")"

# 11. Year and team name of all the champions (winners of the final round) in the format "year|team":
echo "$($PSQL "SELECT year || '|' || name FROM games JOIN teams ON games.winner_id = teams.team_id WHERE round='Final' ORDER BY year;")"
