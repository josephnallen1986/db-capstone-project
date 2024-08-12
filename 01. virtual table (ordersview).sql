CREATE VIEW `ordersview` AS
    SELECT 
        `orders`.`OrderID` AS `OrderID`,
        `orderitems`.`Quantity` AS `Quantity`,
        `orderitems`.`Price` AS `Price`,
        `orders`.`TotalCost` AS `TotalCost`,
        `orders`.`TotalQuantity` AS `TotalQuantity`
    FROM
        (`orders`
        JOIN `orderitems` ON ((`orderitems`.`OrderID` = `orders`.`OrderID`)))
    WHERE
        (`orderitems`.`Quantity` > 2)