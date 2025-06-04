#!/bin/bash
# IMPORTANT: This shebang MUST be the very first line of your script, exactly as shown.

# --- Database Connection Configuration ---
# PSQL variable to connect to the 'salon' database with the 'freecodecamp' user.
# -t: Turn off printing of column names and row count footers.
# --no-align: Don't align fields, which is good for scripting as it avoids padding.
# -c: Execute a single command string.
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

# --- Functions ---

# Function to display the main menu and handle service selection
MAIN_MENU() {
  # If an argument is passed, display it as a message (e.g., an error message)
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\n~~~~~ MY SALON ~~~~~"
  echo -e "Welcome to My Salon, how can I help you?"

  # Dynamically get and display services from the database
  # We're formatting the output directly in the SQL query to ensure "1) Cut" format
  SERVICES=$($PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id")
  echo "$SERVICES" | while read SERVICE_LINE
  do
    echo "$SERVICE_LINE"
  done

  # Prompt user for service selection
  read SERVICE_ID_SELECTED

  # Validate service ID
  # Check if SERVICE_ID_SELECTED is a number
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    # If not a number, show menu again with an error message
    MAIN_MENU "That is not a valid service ID. Please enter a number."
  else
    # Check if the selected service ID exists in the database
    SERVICE_EXISTS=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")

    if [[ -z $SERVICE_EXISTS ]]
    then
      # If service does not exist, show menu again with an error message
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      # If service exists, proceed to appointment booking
      APPOINTMENT_MENU $SERVICE_ID_SELECTED
    fi
  fi
}

# Function to handle appointment booking
APPOINTMENT_MENU() {
  SERVICE_ID=$1

  # Get service name based on the selected service ID
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID")

  # Prompt for customer phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # Check if customer exists in the database using their phone number
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  LOCAL_CUSTOMER_NAME="" # Initialize a variable to hold the customer's name

  # If customer doesn't exist
  if [[ -z $CUSTOMER_ID ]]
  then
    # Prompt for new customer's name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME_INPUT # Use a temporary variable for input to avoid conflict

    # Store the new customer's name
    LOCAL_CUSTOMER_NAME=$CUSTOMER_NAME_INPUT

    # Insert new customer into the customers table
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$LOCAL_CUSTOMER_NAME')")

    # Get the newly created customer's ID
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  else
    # If customer exists, retrieve their name
    LOCAL_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  fi

  # Prompt for appointment time
  # Use the stored LOCAL_CUSTOMER_NAME for the prompt
  echo -e "\nWhat time would you like your $SERVICE_NAME, $LOCAL_CUSTOMER_NAME?"
  read SERVICE_TIME

  # Insert appointment into the appointments table
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID, '$SERVICE_TIME')")

  # Check if the appointment was successfully added
  if [[ $INSERT_APPOINTMENT_RESULT == "INSERT 0 1" ]]
  then
    # Output the success message exactly as required
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $LOCAL_CUSTOMER_NAME."
    # IMPORTANT: The script will naturally exit here because MAIN_MENU is not in a loop.
    # Do NOT add an 'exit' command here, as it might interfere with how tests run.
  else
    echo -e "\nFailed to book appointment. Please try again."
  fi
}

# --- Initial Call to Main Menu ---
# Start the script by displaying the main menu
MAIN_MENU
