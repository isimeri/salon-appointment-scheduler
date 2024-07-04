#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -tc"

echo -e "\n~~~~~ Welcome to Bruh Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo "$1"
  fi

  SERVICES_LIST=$($PSQL "select * from services")
  echo -e "Pick one of the services we provide:"
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    if [[ $SERVICE_ID =~ ^[0-9]+$ ]]
    then
      echo -e "$SERVICE_ID) $SERVICE_NAME"
    fi
  done
  echo -e "4) exit"
  
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) CUT_FUNCTION ;;
    2) WASH_FUNCTION ;;
    3) DYE_FUNCTION ;;
    4) EXIT_FUNCTION ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}


CUT_FUNCTION() {
  GET_USER_INFO
  # echo '1cut'
}

WASH_FUNCTION() {
  GET_USER_INFO
  # echo '2wahs'
}

DYE_FUNCTION() {
  GET_USER_INFO
  # echo '3dye'
}

EXIT_FUNCTION() {
  echo -e "Thanks for stopping by."
}

GET_USER_INFO() {
  echo -e "What is your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$(echo "$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")" | sed -E 's/^ +| +$//g')
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "What is your name?"
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  fi

  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")

  echo -e "When do you want to set an appointment?"
  read SERVICE_TIME
  APPOINTMENT_INSERT=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")

SERVICE_NAME=$(echo "$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")" | sed -E 's/^ +| +$//g')
  echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}
MAIN_MENU