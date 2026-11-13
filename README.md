# Restaurant Reservations Database

Group project for CSC 4500 Database Homework 3.

Group members: Nathan, Andre, and Christian.

## Repository guide

### Database and Java application

- `Java/RestaurantReservationApp.java` — Swing/JDBC app for adding and viewing customers, tables, and reservations, and running Q1–Q6. It connects to `RestaurantReservationDB`. Its Java query constants are the versions used by the app.
- `sql/FillDB.SQL` — normal database setup for this app. It creates `RestaurantReservationDB` and its tables, then imports the three CSV files. It is a setup/import script, not the place to keep assignment queries.
- `sql/Queries.SQL` — Workbench-ready versions of Q1–Q6. It uses editable MySQL session variables for inputs, rather than the Java app’s `?` placeholders.
- `sql/CreateTable.SQL` — alternate schema-only script. It creates an empty `restaurant_db` and does not import CSV data. The current app does not use this database, so do not run it as part of the normal setup.
- `Queries` — older Java source draft without a `.java` extension. It has Q3–Q6 but leaves Q1 and Q2 blank. The active app is in `Java/RestaurantReservationApp.java`. Once any needed material has been copied and checked, the draft is not needed to run the app.

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

`sql/FillDB.SQL` currently contains absolute `LOAD DATA LOCAL INFILE` paths from a different computer. Before running it, replace each of the three paths with the full path to the matching CSV file in your checkout. Use forward slashes in the SQL path, for example:

    LOAD DATA LOCAL INFILE 'C:/your/path/Database_HW3_RestaurantReservations/csv/Customer.csv'

Do the same for `DiningTable.csv` and `ReservationTable.csv`.

### 2. Create and populate the database

Open `sql/FillDB.SQL` in MySQL Workbench and run it using your local MySQL connection. This one script creates the database and tables, then imports all three CSV files. You do not need to run `CreateTable.SQL` as well.

Warning: `FillDB.SQL` starts by dropping `RestaurantReservationDB`. Running it again deletes and rebuilds that database, including records added through the app. Back up any data you need before rerunning it.

The script enables `LOCAL INFILE` with `SET GLOBAL local_infile = 1`, which may require a MySQL account with permission to change server settings. MySQL Workbench and the server must allow local infile loading. If loading fails, enable local infile for both the server and Workbench connection, then reconnect and rerun the import.

Verify the setup in Workbench:

    USE RestaurantReservationDB;
    SHOW TABLES;

    SELECT COUNT(*) AS customers FROM Customer;
    SELECT COUNT(*) AS dining_tables FROM DiningTable;
    SELECT COUNT(*) AS reservations FROM ReservationTable;

The included CSVs contain 50 customers, 30 dining tables, and 75 reservations.

### 3. Run assignment queries in MySQL Workbench

Open `sql/Queries.SQL` after the database setup has completed. The file contains all six query statements and can be run as a script. Before running it, edit the sample values near the top:

- `@q2_search` — a customer's last name or phone number.
- `@q4_party_size` and `@q4_res_datetime` — the party size and exact date/time for Q4.
- `@q5_section` — a section such as `Main`, `Patio`, or `Bar`.

The values are MySQL session variables used to make the script runnable in Workbench. The Java app uses `?` placeholders and binds the corresponding values when you choose a query in the app. Q4 checks bookings at the exact date/time entered; the database does not store booking duration.

The Q5 query may return no rows with the original CSV data because no customer has booked every table in a section. Add suitable test reservations if you need to demonstrate a nonempty result, and remove them or rebuild the database afterward if they are only for a demo.

### 4. Configure and run the Java app

1. In IntelliJ, open the repository as a project.
2. Add `lib/mysql-connector-j-26.7.0.jar` as a module dependency with Compile scope.
3. Open `Java/RestaurantReservationApp.java` and set `DB_USER` and `DB_PASSWORD` near the top to match your local MySQL account. Keep `DB_URL` pointed at `RestaurantReservationDB`.
4. Run `RestaurantReservationApp`. Use Manage records to add or view records and Explore reservations to run the Java versions of Q1–Q6.

For Q2, the app binds the same search text to the last-name and phone placeholders. For Q4, it binds party size first and date/time second. For Q5, it binds the selected section.

## Query checklist

The assignment expects six queries for this three-person group:

- Q1 — reservations per table per month (`GROUP BY` and a join).
- Q2 — customer reservation history (user input and a join).
- Q3 — small, medium, or large party (`CASE` and table capacity).
- Q4 — open tables at a chosen time (date/time and party-size input, with a `NOT IN` subquery).
- Q5 — customers who booked every table in a selected section (division using double `NOT EXISTS`).
- Q6 — bookings larger than that customer's average (correlated `AVG` subquery).

## Submission note

The assignment also asks for query SQL file(s), Word document(s) with query descriptions and screenshots, and the group video. `sql/Queries.SQL` is the shared Workbench query script; follow the assignment's individual submission instructions for which query SQL and Word files each member must submit. Keep the Workbench query script separate from the destructive database setup script.

## Notes

- `FillDB.SQL` and `CreateTable.SQL` create different database names and serve different purposes. Use `FillDB.SQL` for the normal CSV-backed setup with the Java app.
- The setup script's CSV paths and the Java database credentials are local machine settings. Update them for your own computer; do not commit personal passwords.

