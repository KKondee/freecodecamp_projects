#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE teams, games;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  # Don't read first line
  if [[ $YEAR != year ]]
  then

    # Get team names
    TEAM1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # if team1 not found
    if [[ -z $TEAM1 ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      TEAM1=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi

    # if team2 not found
    if [[ -z $TEAM2 ]]
    then
      echo $($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      TEAM2=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
  
    #Get games
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) \
                        VALUES ($YEAR, '$ROUND', $TEAM1, $TEAM2, $WGOALS, $OGOALS)")
  fi
done