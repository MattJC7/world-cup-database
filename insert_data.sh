#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.



echo $($PSQL "TRUNCATE games, teams")

#Add teams information
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
#Get team ID from teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
#If not found
    if [[ -z $WINNER_ID ]]
    then
#Insert team into table
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into team, $WINNER
      fi
    fi
#Get new team ID
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
  fi

#Repeat above for opponents
  if [[ $OPPONENT != 'opponent' ]]
  then
#Get team ID from teams
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
#If not found
    if [[ -z $OPPONENT_ID ]]
    then
#Insert team into table
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_TEAM_RESULT == 'INSERT 0 1' ]]
      then
        echo Inserted into team, $OPPONENT
      fi
    fi
#Get new team ID
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
  fi

#Insert data into games table
if [[ $YEAR != 'year' && $ROUND != 'round' && $WINNER != 'winner' && $OPPONENT != 'opponent' && $WINNER_GOALS != 'winner_goals' && $OPPONENT_GOALS != 'opponent_goals' ]]
then
  INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_GAMES_RESULT == 'INSERT 0 1' ]]
  then
    echo Inserted into games table game from World Cup $YEAR. The winner was $WINNER and the loser was $OPPONENT. The score was $WINNER_GOALS : $OPPONENT_GOALS.
  fi
fi 
done
