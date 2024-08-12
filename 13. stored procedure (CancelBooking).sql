DELIMITER //

CREATE PROCEDURE CancelBooking(IN booking_id_param INT)
BEGIN
	DELETE 
    FROM bookings
    WHERE
		BookingID = booking_id_param;
        
	SELECT CONCAT('Booking ',booking_id_param,' cancelled') AS 'Confrimation';        
        
END //

DELIMITER ;

