# Salon Appointment Scheduler (freeCodeCamp Relational Database Certification Project)

## Project Overview

This project is a command-line Bash script that interacts with a PostgreSQL database to manage customer appointments for a salon. It's a required project for the freeCodeCamp Relational Database (Bash & PostgreSQL) certification.

The script allows users to:
* View a list of available salon services.
* Book appointments by providing their phone number, name (if they are a new customer), and desired time.
* The system intelligently identifies existing customers based on their phone number.

## Technologies Used

* **Bash Scripting:** For the interactive command-line interface.
* **PostgreSQL:** As the relational database to store customer, service, and appointment data.

## Features

* **Service Selection:** Displays a dynamic list of services from the database.
* **Customer Management:**
    * Checks if a customer exists by phone number.
    * Prompts for a new customer's name and adds them to the database if their phone number is not found.
* **Appointment Booking:** Records appointments with customer, service, and time details.
* **Confirmation Message:** Provides a clear confirmation message after a successful appointment booking.
* **Input Validation:** Basic validation for service ID selection.

## Database Schema

The project uses three tables in PostgreSQL:

1.  **`services`**
    * `service_id` (SERIAL PRIMARY KEY)
    * `name` (VARCHAR(50) UNIQUE NOT NULL) - e.g., 'Cut', 'Color'

2.  **`customers`**
    * `customer_id` (SERIAL PRIMARY KEY)
    * `phone` (VARCHAR(20) UNIQUE NOT NULL)
    * `name` (VARCHAR(50) NOT NULL)

3.  **`appointments`**
    * `appointment_id` (SERIAL PRIMARY KEY)
    * `customer_id` (INT NOT NULL, FOREIGN KEY REFERENCES `customers`)
    * `service_id` (INT NOT NULL, FOREIGN KEY REFERENCES `services`)
    * `time` (VARCHAR(20) NOT NULL) - e.g., '10:30', '11am'

## How to Run (Local Setup - for testing/review)

To set up and run this project locally (e.g., in a Linux environment with PostgreSQL installed, or a Gitpod-like environment):

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/Shreya1111-cse/salon-appointment-scheduler.git](https://github.com/Shreya1111-cse/salon-appointment-scheduler.git)
    cd salon-appointment-scheduler
    ```

2.  **Create the PostgreSQL database:**
    ```bash
    psql --username=freecodecamp --dbname=postgres # Or your PostgreSQL superuser
    # Inside psql prompt:
    CREATE DATABASE salon;
    \q
    ```

3.  **Load the database schema and initial data:**
    ```bash
    psql --username=freecodecamp --dbname=salon < salon.sql
    ```

4.  **Make the script executable:**
    ```bash
    chmod +x salon.sh
    ```

5.  **Run the script:**
    ```bash
    ./salon.sh
    ```

## Example Usage

~~~~~ MY SALON ~~~~~
Welcome to My Salon, how can I help you?
1) Cut
2) Color
3) Perm
4) Style
5) Trim
1

What's your phone number?
555-555-5555

I don't have a record for that phone number, what's your name?
Fabio

What time would you like your Cut, Fabio?
10:30

I have put you down for a Cut at 10:30, Fabio.


