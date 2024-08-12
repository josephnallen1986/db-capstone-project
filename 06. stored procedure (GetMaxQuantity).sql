CREATE PROCEDURE `CancelOrder`(IN OrderIDParameter INT)
BEGIN
	DELETE FROM orders WHERE OrderID = OrderIDParameter;
        SELECT CONCAT('Order ', OrderIDParameter, ' is cancelled') AS Confirmation;
END