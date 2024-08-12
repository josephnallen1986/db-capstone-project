DELIMITER //

CREATE PROCEDURE AddValidBooking (
    IN booking_date_param DATE,
    IN table_number_param INT,
    IN customer_name_param VARCHAR(100) 
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
        SELECT CONCAT('Table ',table_number_param,' is already booked - booking cancelled') AS status;
    ELSE
		INSERT INTO customerdetails (CustomerName)
			SELECT customer_name_param
			WHERE NOT EXISTS (
				SELECT 1
				FROM customerdetails
				WHERE CustomerName = customer_name_param
			);        
        	
		SELECT 
			CustomerID
		INTO customer_id_param
        FROM customerdetails
        WHERE 
			CustomerName = customer_name_param;
            
        INSERT INTO bookings (BookingDate, TableNumber, CustomerID)
        VALUES (booking_date_param, table_number_param, customer_id_param);

        COMMIT;
        SELECT CONCAT('Table ',table_number_param,' booking successful') AS status;        
    END IF;
END //

DELIMITER ;