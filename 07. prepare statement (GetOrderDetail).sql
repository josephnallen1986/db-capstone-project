PREPARE GetOrderDetail FROM
'
    SELECT
		orders.OrderID
		,orders.TotalQuantity
		,orders.TotalCost
	FROM bookings
	INNER JOIN orders
		ON orders.BookingID = bookings.BookingID
	WHERE
		bookings.CustomerID = ?
';