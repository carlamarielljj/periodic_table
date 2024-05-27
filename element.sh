#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if no input
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  INPUT=$1
  if [[ ! $INPUT =~ ^[0-9]+$ ]]
  then
    INPUT_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$INPUT' OR name='$INPUT';")
  else
    INPUT_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$INPUT;")
  fi

  if [[ -z $INPUT_ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    NUMBER=$INPUT_ELEMENT
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$INPUT_ELEMENT;")
    NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$INPUT_ELEMENT;")
  
    ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$NUMBER;")
    MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$NUMBER;")
    BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$NUMBER;")
    TYPE=$($PSQL "SELECT type FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$NUMBER;")


    echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
fi