DELIMITER //
CREATE PROCEDURE CheckBooking(IN booking_date_param DATE, IN table_number_param INT)
BEGIN
	SELECT 
		CASE
			WHEN COUNT(bookings.BookingID) > 0 THEN CONCAT('Table ',table_number_param,' is already booked')
			ELSE CONCAT('Table ',table_number_param,' is available')
		END AS 'Booking status'
    FROM bookings
    WHERE
		BookingDate = booking_date_param
        AND TableNumber = table_number_param;
END //

DELIMITER ;


