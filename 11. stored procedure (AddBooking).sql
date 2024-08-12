DELIMITER //

CREATE PROCEDURE AddBooking (
    IN booking_date_param DATE,
    IN table_number_param INT,
    IN customer_id_param INT,
    IN staff_id_param INT
)

BEGIN
	DECLARE booking_exists INT;
	DECLARE customer_id_param INT;

    START TRANSACTION;

    SELECT COUNT(bookings.BookingID) INTO booking_exists
    FROM bookings
    WHERE
		BookingDate = booking_date_param
		AND TableNumber = table_number_param;

    IF booking_exists > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Table ',table_number_param,' is already booked - booking cancelled') AS 'Confrimation';
    ELSE            
        INSERT INTO bookings (BookingDate, TableNumber, CustomerID, StaffID)
        VALUES (booking_date_param, table_number_param, customer_id_param, staff_id_param);

        COMMIT;
        SELECT 'New booking added' AS 'Confrimation';        
    END IF;
END //

DELIMITER ;