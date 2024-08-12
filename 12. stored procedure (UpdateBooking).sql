DELIMITER //

CREATE PROCEDURE UpdateBooking(IN booking_id_param INT, IN booking_date_param DATE)
BEGIN
	UPDATE bookings
    SET 
		BookingDate = booking_date_param
	WHERE
		BookingID = booking_id_param;
        
	SELECT CONCAT('Booking ',booking_id_param,' Updated') AS 'Confrimation';        
        
END //

DELIMITER ;

