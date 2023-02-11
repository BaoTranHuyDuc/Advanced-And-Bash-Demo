#!/bin/bash
echo -e "\nHey man, book somthing\n"
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

LIST_OF_SERVICE() {
  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}
LIST_OF_SERVICE
echo Give me a service
read SERVICE_ID_SELECTED
SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
echo $SELECTED_SERVICE
if [[ -z $SELECTED_SERVICE ]]
then
  LIST_OF_SERVICE
else
  echo "Phone number?"
  read CUSTOMER_PHONE
  SELECTED_CUSTOMER=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $SELECTED_CUSTOMER ]]
  then
    echo "Name?"
    read CUSTOMER_NAME
    echo "Service time?"
    read SERVICE_TIME
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID_FOR_APPOINTMENT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_FOR_APPOINTMENT, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo "I have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    echo "Service time?"
    read SERVICE_TIME
    CUSTOMER_ID_FOR_APPOINTMENT=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID_FOR_APPOINTMENT, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    echo "I have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
fi
