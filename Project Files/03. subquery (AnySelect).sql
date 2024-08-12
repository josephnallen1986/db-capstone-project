SELECT DISTINCT menu.MenuName
FROM menu
INNER JOIN orderitems
	ON orderitems.MenuID = menu.MenuID
WHERE orderitems.OrderID= ANY (
	SELECT 
		orders.OrderID 
	FROM orders 
    WHERE 
    TotalQuantity > 2
);
