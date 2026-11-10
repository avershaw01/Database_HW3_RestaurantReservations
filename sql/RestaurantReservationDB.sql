-- Restaurant reservation setup for MySQL 8.0.16+.
-- Re-running this script REPLACES RestaurantReservationDB and its records.
-- Imports the three CSV files from your local Windows folder.
-- Enable LOCAL INFILE in your MySQL client connection before running.
DROP DATABASE IF EXISTS RestaurantReservationDB;
CREATE DATABASE RestaurantReservationDB CHARACTER SET utf8mb4;
USE RestaurantReservationDB;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Phone VARCHAR(25),
    Email VARCHAR(255),
    CHECK (CustomerID > 0)
);

CREATE TABLE DiningTable (
    TableID INT PRIMARY KEY,
    TableNumber INT NOT NULL UNIQUE,
    Capacity INT NOT NULL,
    Section VARCHAR(50) NOT NULL,
    CHECK (TableID > 0),
    CHECK (TableNumber > 0),
    CHECK (Capacity > 0)
);

CREATE TABLE ReservationTable (
    ReservationID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TableID INT NOT NULL,
    ResDateTime DATETIME NOT NULL,
    PartySize INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TableID) REFERENCES DiningTable(TableID),
    CHECK (ReservationID > 0),
    CHECK (PartySize > 0)
);

-- No booking duration is supplied. Q4 uses an exact date/time comparison.
-- No additional capacity or booking uniqueness rule is imposed on CSV data.
-- Requires permission to change global server settings.
SET GLOBAL local_infile = 1;

START TRANSACTION;

LOAD DATA LOCAL INFILE 'C:/Users/Chris/OneDrive/Documents/CSC4500- Database/Homework/GUI Project/csv/Customer.csv'
INTO TABLE Customer
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, FirstName, LastName, Phone, @last_value)
SET Email = TRIM(TRAILING '\r' FROM @last_value);
SHOW WARNINGS;

LOAD DATA LOCAL INFILE 'C:/Users/Chris/OneDrive/Documents/CSC4500- Database/Homework/GUI Project/csv/DiningTable.csv'
INTO TABLE DiningTable
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(TableID, TableNumber, Capacity, @last_value)
SET Section = TRIM(TRAILING '\r' FROM @last_value);
SHOW WARNINGS;

LOAD DATA LOCAL INFILE 'C:/Users/Chris/OneDrive/Documents/CSC4500- Database/Homework/GUI Project/csv/ReservationTable.csv'
INTO TABLE ReservationTable
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ReservationID, CustomerID, TableID, ResDateTime, @last_value)
SET PartySize = TRIM(TRAILING '\r' FROM @last_value);
SHOW WARNINGS;

COMMIT;

-- ASSIGNMENT QUERIES: intentionally empty.
-- Workbench: use literal values or @variables when testing your queries.
-- Java: use the documented ? markers in Q1_SQL through Q6_SQL.

-- Q1: Reservations per table per month
-- GROUP BY; join DiningTable and ReservationTable. No inputs.
-- Paste your query below.


-- Q2: Customer reservation history
-- Last name or phone. Java binds the search text to TWO ? markers.
-- Paste your query below.


-- Q3: Small / medium / large parties
-- CASE on PartySize; join table Capacity. No inputs.
-- Paste your query below.


-- Q4: Open tables at a chosen date/time
-- NOT IN subquery. Java ? order: party size, then ResDateTime.
-- Paste your query below.


-- Q5: Customers who booked every table in a section
-- Double NOT EXISTS. Java binds section to ONE ? marker.
-- Current CSV data has no customer who booked every table in any section.
-- Add qualifying test reservations if your assignment requires Q5 to return rows.
-- Paste your query below.


-- Q6: Bookings above the customer's own average
-- Correlated subquery using AVG(PartySize). No inputs.
-- Paste your query below.


