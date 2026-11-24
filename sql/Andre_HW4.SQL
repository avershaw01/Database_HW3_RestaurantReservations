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
        