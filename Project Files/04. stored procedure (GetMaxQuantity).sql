CREATE PROCEDURE `GetMaxQuantity`()
SELECT 
	MAX(TotalQuantity) AS 'Maximum Quantity in Order' 
FROM orders