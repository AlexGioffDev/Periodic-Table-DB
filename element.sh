PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
LOAD_INFORMATION() {
    if [[ -z $1 ]]
    then
        echo "Please provide an element as an argument."
    else
        INFO_ELEMENT $1
    fi
}

INFO_ELEMENT() {
    if [[ $1 =~ ^[1-9]+$ ]]
    then
        ELEMENT_INFO=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
    else
        ELEMENT_INFO=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
    fi

    if [[ -z $ELEMENT_INFO ]]
    then
        echo "I could not find that element in the database."
    else
        echo "$ELEMENT_INFO" | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_CELSIUS BOILING_CELSIUS
        do
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_CELSIUS celsius and a boiling point of $BOILING_CELSIUS celsius."
        done
    fi
}

LOAD_INFORMATION $1