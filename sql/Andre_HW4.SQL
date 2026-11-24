--Andre Vershaw | BEFORE UPDATE trigger
--Trigger ensures that changing a reservation time doesn't
--cut into an hour of another reservation.

--Procedure takes the number of guests and a desired date/time,
--Returns available tables (using same 60-minute rule)

USE RestaurantReservationDB;

DELIMITER //

CREATE TRIGGER trig_reservationTimeCheck_before_update
BEFORE UPDATE ON ReservationTable
FOR EACH ROW
BEGIN
    IF NOT (OLD.ResDateTime <=> NEW.ResDateTime) THEN




--Procedure
DELIMITER //
CREATE PROCEDURE proc_checkTableAvail(
    IN req_dateTime DATETIME,
    IN req_party INT,
    OUT res_numAvailable INT
)
BEGIN
    IF req_dateTime IS NULL OR req_party IS NULL OR req_party <= 0 THEN SET MESSAGE_TEXT = 'Error in requested date/time and/or party size`;'
    END IF;

    SELECT COUNT(*)
    INTO res_numAvailable
    FROM DiningTable AS