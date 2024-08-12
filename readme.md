<link href="https://cdn.jsdelivr.net/npm/prismjs@1.28.0/themes/prism.min.css" rel="stylesheet" />
<script src="https://cdn.jsdelivr.net/npm/prismjs@1.28.0/prism.min.js"></script>
<h1>Database Engineer Capstone - Little Lemon Database</h1>
<h4>Little Lemon Restaurant ER Diagram</h4>
<img src="https://github.com/josephnallen1986/db-capstone-project/blob/main/00.%20ER%20Diagram%20(LittleLemonDM).png?raw=true" alt="Little Lemon DB ER Diagram">
<h4>GetMaxQuantity - Stored Procedure</h4>
<pre><code class="language-sql">
CREATE PROCEDURE `CancelOrder`(IN OrderIDParameter INT)
BEGIN
	DELETE FROM orders WHERE OrderID = OrderIDParameter;
        SELECT CONCAT('Order ', OrderIDParameter, ' is cancelled') AS Confirmation;
END
</code></pre>
