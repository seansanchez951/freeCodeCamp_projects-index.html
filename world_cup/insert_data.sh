#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# command to truncate databases
echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
 if [[ $WINNER != winner ]]
 then
  # get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  # if not found
  if [[ -z $TEAM_ID ]]
  then
    # insert major
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then 
      echo "Inserted into teams, $WINNER"
    fi

    # get new team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

  fi

 fi

if [[ $OPPONENT != opponent ]]
 then
  # get team_id
  TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  # if not found
  if [[ -z $TEAM_ID ]]
  then
    # insert major
    INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
    then 
      echo "Inserted into teams, $OPPONENT"
    fi

    # get new team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  fi

fi

# below is inserting games table
# column names: game_id, year, round, winner_id, opponent_id, winner_goals, opponent_goals
# NOTE: winner_id and opponent_id should be taken from teams table

# we need SQL queries to get team_id's from the winner and opponent
WINNER_ID_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
OPPONENT_ID_RESULT=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

if [[ -n $WINNER_ID_RESULT || -n $OPPONENT_ID_RESULT ]]
then
  if [[ $YEAR != year ]]
  then
  INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  VALUES('$YEAR', '$ROUND', '$WINNER_ID_RESULT', '$OPPONENT_ID_RESULT', '$WINNER_GOALS', '$OPPONENT_GOALS')")
    if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo "Inserted into games, $YEAR"
    fi
  fi

  
fi

done 