#!/bin/bash

# Define the PSQL variable for connecting to the worldcup database
PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# Truncate the tables so you can re-run the script safely (do not echo any extra text)
$PSQL "TRUNCATE TABLE games, teams;"

# Read games.csv line by line (skip the header line)
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # Skip the header line (where YEAR equals "year")
  if [[ $YEAR != "year" ]]
  then
    # Get the team_id for the winning team
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    # If not found, insert the winning team and retrieve its team_id
    if [[ -z $WINNER_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$WINNER')"
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # Get the team_id for the opponent team
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # If not found, insert the opponent team and retrieve its team_id
    if [[ -z $OPPONENT_ID ]]
    then
      $PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')"
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi

    # Insert the game record using the correct IDs and data from the CSV
    $PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)"
  fi
done
