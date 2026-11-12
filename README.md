# Restaurant Reservations Database

Group project for CSC 4500 Database Homework 3.

Group members: Nathan, Andre, and Christian.

## What this project contains

### Main project files

- Java/RestaurantReservationApp.java — the Swing/JDBC desktop app.
It can add and list customers, dining tables, and reservations, and it provides a menu for Q1–Q6.
The app connects to the MySQL database RestaurantReservationDB. The query constants in this file are the
versions the menu actually runs.
- sql/FillDB.sql — creates RestaurantReservationDB, defines its three tables, and imports the three CSV files. This is the setup script intended for the current Java app.
- sql/CreateTable.SQL — an alternate schema-only script. It creates restaurant_db and an empty set of tables. It does not load the CSV data, and the current Java app does not connect to that database. Use this only if you specifically need the alternate empty schema; do not run it as part of the normal app setup.

### Data, diagrams, and presentation

- csv/Customer.csv — sample customer rows.
- csv/DiningTable.csv — sample dining-table rows.
- csv/ReservationTable.csv — sample reservation rows.
- documents/HW3_Instructions.pdf — assignment requirements.
- documents/Reservations_Chen_Diagram.pdf — Chen ER model and design notes.
- documents/Reservations_Crows_Foot_ERD.pdf — Crow's Foot ERD, data dictionary, and sample schema.
- Restaurant_Reservations_Presentation.pptx — group presentation slides.

### Java support and project files

- src/DatabaseConnectionTest.java — small JDBC connection check for restaurant_db; it is a separate test and uses its own connection settings.
- src/CustomerQueryTest.java — unfinished customer-query test; it is not the main application.
- lib/mysql-connector-j-26.7.0.jar — MySQL Connector/J library required by the Java program.
- .gitignore — excludes compiled output, local settings, and temporary files from Git.
- .gitattributes — Git text-file handling settings.
- .idea/ — IntelliJ project configuration. It is IDE metadata, not required source code.
- out/ — locally compiled IntelliJ output. It is generated and should not be edited by hand.

## Run the database and app locally

### Requirements

- MySQL Server and MySQL Workbench installed and running.
- IntelliJ IDEA or another Java IDE.
- The repository's MySQL Connector/J jar in lib/.

### 1. Configure the CSV paths in the import script

sql/FillDB.sql currently contains absolute LOAD DATA LOCAL INFILE paths from a different computer. Before running it, replace each of the three paths with the full path to the corresponding CSV file in your own checkout. Use forward slashes in the SQL path, for example:

    LOAD DATA LOCAL INFILE 'C:/your/path/Database_HW3_RestaurantReservations/csv/Customer.csv'

Do the same for DiningTable.csv and ReservationTable.csv.

### 2. Run the database setup

Open sql/FillDB.sql in MySQL Workbench and run it using your local MySQL connection. The script creates RestaurantReservationDB, creates Customer, DiningTable, and ReservationTable, then imports the CSV data.

Warning: FillDB.sql starts by dropping RestaurantReservationDB. Running it again deletes and rebuilds that database, including any records you added through the app. Back up any data you need before rerunning it.

The script enables LOCAL INFILE with SET GLOBAL local_infile = 1, which may require a MySQL account with permission to change server settings. MySQL Workbench and the server must allow local infile loading. If loading fails, enable local infile for both the server and the Workbench connection, then reconnect and rerun the import.

Verify the setup in Workbench:

    USE RestaurantReservationDB;
    SHOW TABLES;

    SELECT COUNT(*) AS customers FROM Customer;
    SELECT COUNT(*) AS dining_tables FROM DiningTable;
    SELECT COUNT(*) AS reservations FROM ReservationTable;

The included CSV files currently contain 50 customers, 30 dining tables, and 75 reservations.

### 3. Configure and run the Java app

1. In IntelliJ, open the repository as a project.
2. Add lib/mysql-connector-j-26.7.0.jar as a module dependency with Compile scope.
3. Open Java/RestaurantReservationApp.java and set DB_USER and DB_PASSWORD near the top to match your local MySQL account. Keep DB_URL pointed at RestaurantReservationDB.
4. Run RestaurantReservationApp. Use Manage records to add or view records and Explore reservations to run queries.

The app currently has blank Q1–Q6 query constants. It will not execute those assignment queries until the SQL is added to the corresponding constants. Q3–Q6 in the Queries draft can be used as a starting point; complete Q1 and Q2 and review all six queries in the active app before relying on the query menu.

## Query checklist

The assignment expects six queries for this three-person group:

- Q1 — reservations per table per month (GROUP BY and a join).
- Q2 — customer reservation history (user input and a join).
- Q3 — small, medium, or large party (CASE and table capacity).
- Q4 — open tables at a chosen time (date/time and party-size input, with a NOT IN subquery).
- Q5 — customers who booked every table in a selected section (division using double NOT EXISTS).
- Q6 — bookings larger than that customer's average (correlated AVG subquery).

For Q2, the app expects two ? parameters: last name first and phone second. For Q4, it expects party size first and date/time second. For Q5, it expects one parameter: section.

## Notes

- FillDB.sql and CreateTable.SQL create different database names and serve different purposes. The app uses RestaurantReservationDB, so use FillDB.sql for the normal CSV-backed setup.
- The setup script's CSV paths and the Java database credentials are local machine settings. Update them for your own computer; do not commit personal passwords.

