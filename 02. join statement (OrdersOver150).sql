SELECT
	customerdetails.CustomerID
	,customerdetails.CustomerName
    ,orders.OrderID
    ,orders.TotalCost
    ,menu.MenuName
    ,course.ItemName AS 'Course'
    ,starter.ItemName AS 'Starter'
FROM bookings
INNER JOIN customerdetails
	ON customerdetails.CustomerID = bookings.CustomerID
INNER JOIN orders
	ON orders.BookingID = bookings.BookingID
INNER JOIN orderitems
	ON orderitems.OrderID = orders.OrderID    
INNER JOIN menu
	ON menu.MenuID = orderitems.MenuID	
LEFT JOIN menuitems AS course
	ON course.MenuID = menu.MenuID
    AND course.ItemType = 'Course'
LEFT JOIN menuitems AS starter
	ON starter.MenuID = menu.MenuID
    AND starter.ItemType = 'Starter'
WHERE 
	1 = 1
    AND orders.TotalCost > 150
ORDER BY 
	orders.TotalCost DESC;


