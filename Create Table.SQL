-- Restaurant Reservations database (CSC 4500 HW3)
-- MySQL 8.0.16+ (CHECK constraints are enforced from that version on)
-- Create order matters: parent tables first, then the bridge table.

CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

DROP TABLE IF EXISTS ReservationTable;
DROP TABLE IF EXISTS DiningTable;
DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
    CustomerID   INT          AUTO_INCREMENT PRIMARY KEY,
    FirstName    VARCHAR(40)  NOT NULL,
    LastName     VARCHAR(40)  NOT NULL,
    Phone        VARCHAR(15)  NOT NULL,
    Email        VARCHAR(80)  UNIQUE
);

CREATE TABLE DiningTable (
    TableID      INT          AUTO_INCREMENT PRIMARY KEY,
    TableNumber  INT          NOT NULL UNIQUE,
    Capacity     INT          NOT NULL CHECK (Capacity BETWEEN 1 AND 20),
    Section      VARCHAR(20)  NOT NULL CHECK (Section IN ('Main', 'Patio', 'Bar'))
);

CREATE TABLE ReservationTable (
    ReservationID INT         AUTO_INCREMENT PRIMARY KEY,
    CustomerID    INT         NOT NULL,
    TableID       INT         NOT NULL,
    ResDateTime   DATETIME    NOT NULL,
    PartySize     INT         NOT NULL CHECK (PartySize > 0),
    CONSTRAINT fk_res_customer FOREIGN KEY (CustomerID)
        REFERENCES Customer (CustomerID) ON DELETE CASCADE,
    CONSTRAINT fk_res_table FOREIGN KEY (TableID)
        REFERENCES DiningTable (TableID) ON DELETE RESTRICT,
    CONSTRAINT uq_table_time UNIQUE (TableID, ResDateTime)
);

CREATE INDEX idx_res_datetime       ON ReservationTable (ResDateTime);
CREATE INDEX idx_customer_lastname  ON Customer (LastName);
