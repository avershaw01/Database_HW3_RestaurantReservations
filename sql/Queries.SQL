--Q1
SELECT d.TableNumber, d.Section,
       DATE_FORMAT(r.ResDateTime, '%Y-%m') AS ResMonth,
       COUNT(*) AS Reservations,
       SUM(r.PartySize) AS TotalGuests
FROM DiningTable d
         JOIN ReservationTable r ON r.TableID = d.TableID
GROUP BY d.TableNumber, d.Section,
         DATE_FORMAT(r.ResDateTime, '%Y-%m')
ORDER BY ResMonth, d.TableNumber;
--Q2
SELECT c.FirstName, c.LastName, c.Phone,
       r.ResDateTime, d.TableNumber, d.Section,
       r.PartySize
FROM Customer c
         JOIN ReservationTable r ON r.CustomerID = c.CustomerID
         JOIN DiningTable d ON d.TableID = r.TableID
WHERE c.LastName = ? OR c.Phone = ?
ORDER BY r.ResDateTime;
--Q3
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
ORDER BY ReservationTable.ReservationID
--Q4
SELECT DiningTable.TableID,
       DiningTable.TableNumber,
       DiningTable.Capacity,
       DiningTable.Section
FROM DiningTable
WHERE DiningTable.Capacity >= ?
  AND DiningTable.TableID NOT IN (
    SELECT ReservationTable.TableID
    FROM ReservationTable
    WHERE ReservationTable.ResDateTime = ?
)
ORDER BY DiningTable.Capacity, DiningTable.TableNumber
--Q5
SELECT Customer.CustomerID, Customer.FirstName,
       Customer.LastName
FROM Customer
WHERE NOT EXISTS (
    SELECT 1
    FROM DiningTable
    WHERE DiningTable.Section = ?
      AND NOT EXISTS (
        SELECT 1
        FROM ReservationTable
        WHERE ReservationTable.CustomerID =
              Customer.CustomerID
          AND ReservationTable.TableID = DiningTable.TableID
    )
)
--Q6
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
