--// DATA CLEANING //--
SELECT * FROM Sales_Data$

--// CHECK DUPLICATES //--
SELECT DISTINCT * FROM Sales_Data$

--// CHECK NULL VALUES //--
SELECT * FROM Sales_Data$
WHERE Customer_id IS NULL]

--// CHECK OUTLIERS//--
SELECT QUANTITY FROM SALES_DATA$
GROUP BY QUANTITY
--// OR //--
DELETE FROM Sales_Data$
WHERE QUANTITY > 5 OR QUANTITY < 1; 

--// FIX DATE FORMAT --//
SELECT convert(varchar, TRY_CONVERT(DATE,INVOICE_DATE,23),110) AS Invoice_Date
FROM Sales_Data$

--// Got Null values in date column//--
SELECT invoice_date
FROM Sales_data$
WHERE TRY_CONVERT(DATE, invoice_date, 105) IS NOT NULL -- This checks for DD-MM-YYYY format
  AND TRY_CONVERT(DATE, invoice_date, 23) IS NULL;  -- This checks that it’s not already in YYYY-MM-DD format

--// CHANGE CASE //--
UPDATE Sales_Data$
SET Customer_ID = UPPER(Customer_ID)

--// CHANGE CASE FOR COLUMN NAMES --//

EXEC sp_rename 'Sales_Data$.invoice_no','Invoice_No', 'COLUMN';
EXEC sp_rename 'Sales_Data$.customer_id', 'Customer_ID', 'COLUMN';
EXEC sp_rename 'Sales_Data$.category', 'Category', 'COLUMN';
EXEC sp_rename  'Sales_Data$.quantity', 'Quantity', 'COLUMN';
EXEC sp_rename  'Sales_Data$.price', 'Price', 'COLUMN';
EXEC sp_rename  'Sales_Data$.invoice_date', 'Invoice_Date', 'COLUMN';
EXEC sp_rename  'Sales_Data$.shopping_mall','Mall', 'COLUMN';


--// FIND SECOND HIGHEST ORDER //--
SELECT Max(Price) AS SecondHighestOrderPrice
FROM Sales_Data$
WHERE Price < (SELECT MAX(Price) FROM Sales_Data$)

--// Find Sales for each Category --//
SELECT Category, MAX(Price) AS Price FROM Sales_Data$
GROUP BY Category
ORDER BY MAX(Price) DESC

--// who did more shopping male or female Customer  //--

SELECT Gender,ROUND(SUM(Price),2) AS Total_Price 
FROM customer_data$
JOIN Sales_Data$
ON customer_data$.Customer_ID = Sales_Data$.Customer_ID
GROUP BY Gender
ORDER BY Total_Price DESC

--//Total Revenue//--
SELECT ROUND(SUM(Price),2) AS Total_Revenue
FROM SALES_DATA$

--//CUMULATIVE SALES(RUNNING TOTAL) 
SELECT invoice_no,invoice_date,customer_id, price,
SUM(price) OVER (ORDER BY invoice_date) AS cumulative_sales
FROM sales_data$;

--// RANK SALES //-- 
SELECT price,
DENSE_RANK() OVER (ORDER BY price DESC) AS Rank_sales
FROM sales_data$
GROUP BY PRICE;

-- CUMULATIVE SALES PER CUSTOMER //--
SELECT INVOICE_NO, INVOICE_date, customer_id,PRICE,SUM(PRICE)  
OVER 
(PARTITION BY customer_id ORDER BY INVOICE_date) AS cumulative_sales_per_customer
FROM sales_DATA$;

-- DIFFERENT CATOGERY SALES VS GENDER--
SELECT CATEGORY, GENDER, ROUND(SUM(PRICE*QUANTITY),2)AS QUANTITY                         
FROM SALES_DATA$
JOIN CUSTOMER_DATA$
ON SALES_DATA$.CUSTOMER_ID = CUSTOMER_DATA$.CUSTOMER_ID
GROUP BY CATEGORY, GENDER
ORDER BY QUANTITY DESC


--// SALES BY CATEGORY AND SHOPPING MALL//-
SELECT MALL, CATEGORY, ROUND(SUM(PRICE*QUANTITY),2) AS QUANTITY               
FROM SALES_DATA$
GROUP BY MALL, CATEGORY
ORDER BY QUANTITY DESC


 --// SALES BY SHOPPING MALL//--
SELECT MALL, ROUND(SUM(PRICE*QUANTITY),2) AS QUANTITY                       
FROM SALES_DATA$
GROUP BY MALL
ORDER BY QUANTITY DESC

--// Can you write a query to calculate the total sales (sum of price * quantity) made by each customer,
--and also identify the most frequent shopping mall where each customer makes purchases?//--

SELECT 
    sd.CUSTOMER_ID,
    SUM(sd.PRICE * sd.QUANTITY) AS TOTAL_SALES,
    (SELECT TOP 1 MALL
     FROM SALES_DATA$ sd2
     WHERE sd2.CUSTOMER_ID = sd.CUSTOMER_ID
     GROUP BY sd2.MALL
     ORDER BY COUNT(sd2.MALL) DESC, SUM(sd2.PRICE * sd2.QUANTITY) DESC) AS MOST_FREQUENT_MALL
FROM SALES_DATA$ sd
GROUP BY sd.CUSTOMER_ID
ORDER BY TOTAL_SALES DESC;





