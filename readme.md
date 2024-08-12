# Database Engineer Capstone - Little Lemon Database

## Little Lemon Restaurant ER Diagram
![Little Lemon DB ER Diagram](https://github.com/josephnallen1986/db-capstone-project/blob/main/Project%20Files/00.%20ER%20Diagram%20(LittleLemonDM).png?raw=true)


## GetMaxQuantity - Stored Procedure

```sql
CREATE PROCEDURE `GetMaxQuantity`()
SELECT 
    MAX(TotalQuantity) AS 'Maximum Quantity in Order' 
FROM orders
```
## ManageBooking / AddValidBooking Stored Procedure
```sql
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
```
## AddBooking Stored Procedure
```sql
DELIMITER //

CREATE PROCEDURE AddBooking (
    IN booking_date_param DATE,
    IN table_number_param INT,
    IN customer_id_param INT,
    IN staff_id_param INT
)

BEGIN
    DECLARE booking_exists INT;

    START TRANSACTION;

    SELECT COUNT(bookings.BookingID) INTO booking_exists
    FROM bookings
    WHERE
        BookingDate = booking_date_param
        AND TableNumber = table_number_param;

    IF booking_exists > 0 THEN
        ROLLBACK;
        SELECT CONCAT('Table ',table_number_param,' is already booked - booking cancelled') AS 'Confirmation';
    ELSE            
        INSERT INTO bookings (BookingDate, TableNumber, CustomerID, StaffID)
        VALUES (booking_date_param, table_number_param, customer_id_param, staff_id_param);

        COMMIT;
        SELECT 'New booking added' AS 'Confirmation';        
    END IF;
END //

DELIMITER ;
```
## UpdateBooking Stored Procedure
```sql
DELIMITER //

CREATE PROCEDURE UpdateBooking(IN booking_id_param INT, IN booking_date_param DATE)
BEGIN
    UPDATE bookings
    SET 
        BookingDate = booking_date_param
    WHERE
        BookingID = booking_id_param;
        
    SELECT CONCAT('Booking ',booking_id_param,' Updated') AS 'Confirmation';        
        
END //

DELIMITER ;
```
## CancelBooking Stored Procedure
```sql
DELIMITER //

CREATE PROCEDURE CancelBooking(IN booking_id_param INT)
BEGIN
    DELETE 
    FROM bookings
    WHERE
        BookingID = booking_id_param;
        
    SELECT CONCAT('Booking ',booking_id_param,' cancelled') AS 'Confirmation';        
        
END //

DELIMITER ;
```
## Tableau Public Worksheets and Dashboard
[dp-capstone-project](https://public.tableau.com/views/LittleLemonDB_17234778829910/SalesDashboar?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Python Exercises
```python
import mysql.connector as connector
import json

# Establish a connection and create a Cursor

with open('global_variables.json') as global_variables_file:
    global_variables = json.load(global_variables_file)

db = global_variables['db']
host = global_variables['host']
user = global_variables['user']
password = global_variables['password']

try:
    connection = connector.connect(
        host=host,
        user=user,
        password=password
    )
    print("Connected to MySQL!")
        
except connector.Error as error:
    print("Error while connecting to MySQL:", error)    

cursor = connection.cursor()    

# Query and Print Tables in DB
show_tables_query = "SHOW TABLES"
cursor.execute(f"USE {db}")
cursor.execute(show_tables_query)
results = cursor.fetchall()
for table in results:
    print(table)

# Query and Print Customers With TotalCost Over $60
db_query = """
SELECT DISTINCT
    customerdetails.CustomerName,
    customerdetails.Email,
    customerdetails.ContactNumber
FROM customerdetails
INNER JOIN bookings
    ON bookings.CustomerID = customerdetails.CustomerID
INNER JOIN orders
    ON orders.BookingID = bookings.BookingID
WHERE
    orders.TotalCost >= 60
"""

cursor.execute(db_query)
results = cursor.fetchall()
for customer in results:
    print(customer)
    
