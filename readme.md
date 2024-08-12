<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/prismjs@1.28.0/themes/prism.min.css" rel="stylesheet" />
</head>
<body>
<h1>Database Engineer Capstone - Little Lemon Database</h1>
<h4>Little Lemon Restaurant ER Diagram</h4>
	<img src="https://github.com/josephnallen1986/db-capstone-project/blob/main/Project%20Files/00.%20ER%20Diagram%20(LittleLemonDM).png?raw=true" alt="Little Lemon DB ER Diagram" width="500">
<h4>GetMaxQuantity - Stored Procedure</h4>
<pre><code class="language-sql">
CREATE PROCEDURE `GetMaxQuantity`()
SELECT 
    MAX(TotalQuantity) AS 'Maximum Quantity in Order' 
FROM orders
</code></pre>
<h4>ManageBooking / AddValidBooking Stored Procedure</h4>
<pre><code class="language-sql">
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
</code></pre>
<h4>Tableau Workbooks and Dashboard</h4>
<div class='tableauPlaceholder' id='viz1723484394233' style='position: relative'><noscript><a href='#'><img alt=' ' src='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Li&#47;LittleLemonDB_17234778829910&#47;SalesDashboar&#47;1_rss.png' style='border: none' /></a></noscript><object class='tableauViz'  style='display:none;'><param name='host_url' value='https%3A%2F%2Fpublic.tableau.com%2F' /> <param name='embed_code_version' value='3' /> <param name='site_root' value='' /><param name='name' value='LittleLemonDB_17234778829910&#47;SalesDashboar' /><param name='tabs' value='yes' /><param name='toolbar' value='yes' /><param name='static_image' value='https:&#47;&#47;public.tableau.com&#47;static&#47;images&#47;Li&#47;LittleLemonDB_17234778829910&#47;SalesDashboar&#47;1.png' /> <param name='animate_transition' value='yes' /><param name='display_static_image' value='yes' /><param name='display_spinner' value='yes' /><param name='display_overlay' value='yes' /><param name='display_count' value='yes' /><param name='language' value='en-US' /></object></div>                <script type='text/javascript'>                    var divElement = document.getElementById('viz1723484394233');                    var vizElement = divElement.getElementsByTagName('object')[0];                    if ( divElement.offsetWidth > 800 ) { vizElement.style.minWidth='1000px';vizElement.style.maxWidth='100%';vizElement.style.minHeight='850px';vizElement.style.maxHeight=(divElement.offsetWidth*0.75)+'px';} else if ( divElement.offsetWidth > 500 ) { vizElement.style.minWidth='1000px';vizElement.style.maxWidth='100%';vizElement.style.minHeight='850px';vizElement.style.maxHeight=(divElement.offsetWidth*0.75)+'px';} else { vizElement.style.width='100%';vizElement.style.minHeight='750px';vizElement.style.maxHeight=(divElement.offsetWidth*1.77)+'px';}                     var scriptElement = document.createElement('script');                    scriptElement.src = 'https://public.tableau.com/javascripts/api/viz_v1.js';                    vizElement.parentNode.insertBefore(scriptElement, vizElement);                </script>
<h4>AddBooking Stored Procedure</h4>
<pre><code class="language-sql">
DELIMITER //

CREATE PROCEDURE AddBooking (
    IN booking_date_param DATE,
    IN table_number_param INT,
    IN customer_id_param INT,
    IN staff_id_param INT
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
        SELECT CONCAT('Table ',table_number_param,' is already booked - booking cancelled') AS 'Confrimation';
    ELSE            
        INSERT INTO bookings (BookingDate, TableNumber, CustomerID, StaffID)
        VALUES (booking_date_param, table_number_param, customer_id_param, staff_id_param);

        COMMIT;
        SELECT 'New booking added' AS 'Confrimation';        
    END IF;
END //

DELIMITER ;
</code></pre>
<h4>UpdateBooking Stored Procedure</h4>
<pre><code class="language-sql">
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
</code></pre>    
<h4>CancelBooking Stored Procedure</h4>
<pre><code class="language-sql">
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
<h4>CancelBooking Stored Procedure</h4>
<pre><code class="language-python">

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
    
</code></pre>    
<script src="https://cdn.jsdelivr.net/npm/prismjs@1.28.0/prism.min.js"></script>
</body>
</html>
