# Restaurant Reservations Database

Group project for CSC 4500 Database Homework 3.

Group members: Nathan, Andre, and Christian.

## Repository guide

### Database and Java application

- `Java/RestaurantReservationApp.java` — Swing/JDBC app for adding and viewing customers, tables, and reservations, and running Q1–Q6. It connects to `RestaurantReservationDB`. Its Java query constants are the versions used by the app.
- `sql/FillDB.sql` — normal database setup for this app. It creates `RestaurantReservationDB` and its tables, then imports the three CSV files. It is a setup/import script, not the place to keep the Workbench versions of the assignment queries.
- `sql/CreateTable.SQL` — alternate schema-only script. It creates an empty `restaurant_db` and does not import CSV data. The current app does not use this database, so do not run this as part of the normal setup.
- `Queries` — older Java source draft without a `.java` extension. It has Q3–Q6 but leaves Q1 and Q2 blank. The active app is in `Java/RestaurantReservationApp.java`. Once any needed material has been copied and checked, the draft is not needed to run the app.

### Assignment queries

Keep the MySQL Workbench versions of Q1–Q6 in a separate file, for example `sql/Queries.sql`. That file does not exist in the repository yet; add it when preparing the query submission. Do not append the queries to `FillDB.sql`: that script drops and rebuilds the database when run, and its job is to create and populate the database.

The Java app uses `?` placeholders for user inputs. In a Workbench query file, replace those placeholders with test values or use MySQL session variables, so the query can run directly in Workbench. Keep the Java versions in `RestaurantReservationApp.java` using their `?` placeholders.

### Data, diagrams, and presentation

- `csv/Customer.csv` — sample customer rows.
- `csv/DiningTable.csv` — sample dining-table rows.
- `csv/ReservationTable.csv` — sample reservation rows.
- `documents/HW3_Instructions.pdf` — assignment requirements.
- `documents/Reservations_Chen_Diagram.pdf` — Chen ER model and design notes.
- `documents/Reservations_Crows_Foot_ERD.pdf` — Crow's Foot ERD, data dictionary, and sample schema.
- `documents/Restaurant_Reservations_Presentation.pptx` — group presentation slides.

### Java support and project files

- `src/DatabaseConnectionTest.java` — small JDBC connection check for `restaurant_db`; separate from the main app and uses its own connection settings.
- `src/CustomerQueryTest.java` — unfinished customer-query test; not the main application.
- `lib/mysql-connector-j-26.7.0.jar` — MySQL Connector/J library required by the Java program.
- `.gitignore` — excludes compiled output, local settings, and temporary files from Git.
- `.gitattributes` — Git text-file handling settings.
- `.idea/` — IntelliJ project configuration; IDE metadata, not required source code.
- `out/` — generated IntelliJ build output. It is not source code and can be recreated by building the project.

## Run the database and app locally

### Requirements

- MySQL Server and MySQL Workbench installed and running.
- IntelliJ IDEA or another Java IDE.
- The repository's MySQL Connector/J jar in `lib/`.

### 1. Configure the CSV paths in the import script

`sql/FillDB.sql` currently contains absolute `LOAD DATA LOCAL INFILE` paths from a different computer. Before running it, replace each of the three paths with the full path to the matching CSV file in your checkout. Use forward slashes in the SQL path, for example:

    LOAD DATA LOCAL INFILE 'C:/your/path/Database_HW3_RestaurantReservations/csv/Customer.csv'

Do the same for `DiningTable.csv` and `ReservationTable.csv`.

### 2. Create and populate the database

Open `sql/FillDB.sql` in MySQL Workbench and run it using your local MySQL connection. This one script creates the database and tables, then imports all three CSV files. You do not need to run `CreateTable.SQL` as well.

Warning: `FillDB.sql` starts by dropping `RestaurantReservationDB`. Running it again deletes and rebuilds that database, including records added through the app. Back up any data you need before rerunning it.

The script enables `LOCAL INFILE` with `SET GLOBAL local_infile = 1`, which may require a MySQL account with permission to change server settings. MySQL Workbench and the server must allow local infile loading. If loading fails, enable local infile for both the server and Workbench connection, then reconnect and rerun the import.

Verify the setup in Workbench:

    USE RestaurantReservationDB;
    SHOW TABLES;

    SELECT COUNT(*) AS customers FROM Customer;
    SELECT COUNT(*) AS dining_tables FROM DiningTable;
    SELECT COUNT(*) AS reservations FROM ReservationTable;

The included CSVs contain 50 customers, 30 dining tables, and 75 reservations.

### 3. Run assignment queries in MySQL Workbench

Create `sql/Queries.sql` and put the six Workbench-ready query statements there. The query comment section at the end of `FillDB.sql` is only a set of placeholders; it does not contain executable Q1–Q6 statements.

Run each query separately in Workbench and save the required screenshots and technical/non-technical descriptions in the assignment's requested Word document(s). For query parameters, use concrete test values or MySQL variables in this Workbench file. For example, Q2 can use a last name and phone in its WHERE clause; Q4 can use a party size and date/time; Q5 can use a section name. The Java app separately binds those values through `?` markers.

### 4. Configure and run the Java app

1. In IntelliJ, open the repository as a project.
2. Add `lib/mysql-connector-j-26.7.0.jar` as a module dependency with Compile scope.
3. Open `Java/RestaurantReservationApp.java` and set `DB_USER` and `DB_PASSWORD` near the top to match your local MySQL account. Keep `DB_URL` pointed at `RestaurantReservationDB`.
4. Run `RestaurantReservationApp`. Use Manage records to add or view records and Explore reservations to run the Java versions of Q1–Q6.

The six Java query constants are populated. For Q2, the app binds the search text to both placeholders (last name, then phone). For Q4, it binds party size first and date/time second. For Q5, it binds the selected section.

## Query checklist

The assignment expects six queries for this three-person group:

- Q1 — reservations per table per month (GROUP BY and a join).
- Q2 — customer reservation history (user input and a join).
- Q3 — small, medium, or large party (CASE and table capacity).
- Q4 — open tables at a chosen time (date/time and party-size input, with a NOT IN subquery).
- Q5 — customers who booked every table in a selected section (division using double NOT EXISTS).
- Q6 — bookings larger than that customer's average (correlated AVG subquery).

## Submission note

The repository contains the app Java source and the database setup/import SQL. The assignment also asks for query SQL file(s), Word document(s) with query descriptions and screenshots, and the group video. Keep the Workbench query file separate from the destructive database setup script.

## Notes

- `FillDB.sql` and `CreateTable.SQL` create different database names and serve different purposes. Use `FillDB.sql` for the normal CSV-backed setup with the Java app.
- The setup script's CSV paths and the Java database credentials are local machine settings. Update them for your own computer; do not commit personal passwords.

