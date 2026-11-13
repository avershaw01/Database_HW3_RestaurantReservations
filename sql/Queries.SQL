-- Workbench versions of Q1-Q6 for RestaurantReservationDB.
-- Change the sample values below before running the input-based queries.
-- These use MySQL session variables instead of Java's ? placeholders.
USE RestaurantReservationDB;

SET @q2_search = 'Lee';
SET @q4_party_size = 4;
SET @q4_res_datetime = '2026-12-06 11:00:00';
SET @q5_section = 'Bar';

-- Q1: Reservations per table per month
SELECT d.TableNumber, d.Section,
       DATE_FORMAT(r.ResDateTime, '%Y-%m') AS ResMonth,
       COUNT(*) AS Reservations,
       SUM(r.PartySize) AS TotalGuests
FROM DiningTable d
JOIN ReservationTable r ON r.TableID = d.TableID
GROUP BY d.TableNumber, d.Section,
         DATE_FORMAT(r.ResDateTime, '%Y-%m')
ORDER BY ResMonth, d.TableNumber;

-- Q2: Customer reservation history
-- The same search value is compared against last name and phone, like the Java app.
SELECT c.FirstName, c.LastName, c.Phone,
       r.ResDateTime, d.TableNumber, d.Section,
       r.PartySize
FROM Customer c
JOIN ReservationTable r ON r.CustomerID = c.CustomerID
JOIN DiningTable d ON d.TableID = r.TableID
WHERE c.LastName = @q2_search OR c.Phone = @q2_search
ORDER BY r.ResDateTime;

-- Q3: Small, medium, and large parties
SELECT ReservationTable.ReservationID,
       ReservationTable.PartySize,
       DiningTable.TableNumber,
       DiningTable.Capacity,
       CASE
           WHEN ReservationTable.PartySize <= 2 THEN 'Small'
           WHEN ReservationTable.PartySize <= 4 THEN 'Medium'
           ELSE 'Large'
       END AS PartyCategory
FROM ReservationTable
JOIN DiningTable
    ON ReservationTable.TableID = DiningTable.TableID
ORDER BY ReservationTable.ReservationID;

-- Q4: Open tables for a party size at an exact date/time
SELECT DiningTable.TableID,
       DiningTable.TableNumber,
       DiningTable.Capacity,
       DiningTable.Section
FROM DiningTable
WHERE DiningTable.Capacity >= @q4_party_size
  AND DiningTable.TableID NOT IN (
      SELECT ReservationTable.TableID
      FROM ReservationTable
      WHERE ReservationTable.ResDateTime = @q4_res_datetime
  )
ORDER BY DiningTable.Capacity, DiningTable.TableNumber;

-- Q5: Customers who booked every table in the chosen section
SELECT Customer.CustomerID, Customer.FirstName,
       Customer.LastName
FROM Customer
WHERE NOT EXISTS (
    SELECT 1
    FROM DiningTable
    WHERE DiningTable.Section = @q5_section
      AND NOT EXISTS (
          SELECT 1
          FROM ReservationTable
          WHERE ReservationTable.CustomerID =
                Customer.CustomerID
            AND ReservationTable.TableID = DiningTable.TableID
      )
);

-- Q6: Bookings above that customer's own average party size
SELECT ReservationTable.ReservationID,
       Customer.CustomerID,
       Customer.FirstName,
       Customer.LastName,
       ReservationTable.TableID,
       ReservationTable.ResDateTime,
       ReservationTable.PartySize
FROM ReservationTable
JOIN Customer
    ON ReservationTable.CustomerID = Customer.CustomerID
WHERE ReservationTable.PartySize > (
    SELECT AVG(CustomerReservations.PartySize)
    FROM ReservationTable AS CustomerReservations
    WHERE CustomerReservations.CustomerID =
          ReservationTable.CustomerID
)
ORDER BY Customer.CustomerID, ReservationTable.ResDateTime;

