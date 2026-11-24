--Andre Vershaw | BEFORE UPDATE trigger
--Trigger ensures that changing a reservation time doesn't
--cut into an hour of another reservation.

--Procedure takes the number of guests and a desired date/time,
--Returns available tables (using same 60-minute rule)

USE RestaurantReservationDB;
DROP TRIGGER IF EXISTS trig_reservationTimeCheck_before_update;
DELIMITER //


CREATE TRIGGER trig_reservationTimeCheck_before_update
BEFORE UPDATE ON ReservationTable
FOR EACH ROW
BEGIN
    IF NOT (OLD.ResDateTime <=> NEW.ResDateTime)
        AND EXISTS (
            SELECT 1
            FROM ReservationTable AS other_reservation
            WHERE other_reservation.TableID = NEW.TableID
                AND other_reservation.ReservationID <> OLD.ReservationID
                AND other_reservation.ResDateTime > DATE_SUB(NEW.ResDateTime, INTERVAL 1 HOUR)
                AND other_reservation.ResDateTime < DATE_ADD(NEW.ResDateTime, INTERVAL 1 HOUR)
        )
    THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Update rejected: another reservation for this table starts within one hour.';
    END IF;
END//
DELIMETER ;




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