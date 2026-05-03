CREATE DATABASE SQL_P1;
--creating table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transaction_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sales FLOAT
)

SELECT * FROM retail_sales LIMIT 10;
--DATA cleaning
--null values
SELECT * FROM retail_sales
WHERE (transactions_id IS NULL 
OR 	sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL 
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sales IS NULL)

--deleting records with null values
DELETE FROM retail_sales
WHERE (transactions_id IS NULL 
OR 	sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL 
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sales IS NULL)

--DATA EXPLORATION
--how many sales we have?
SELECT COUNT(*) FROM retail_sales as total_sales

--how many unique customers are there?
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales

--unique categories are there?
SELECT DISTINCT category
FROM retail_sales

--Data analysis and solving business key problems
--Q1. Write a sql query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--/Q2. Write a sql query to retrieve all transactions where the category is clothing and the quantity sold is more than 3 in the month of nov 2022
SELECT * FROM retail_sales 
WHERE category='Clothing' AND quantity >3 AND TO_CHAR(sale_date, 'YYYY-MM')= '2022-11'

--Write a sql query to calculate total sales for each category
SELECT category,
SUM(total_sales) AS total_sale_per_category
FROM retail_sales
GROUP BY category

--Q4. Write a sql query to find the average age of customers who purchased item from 'beauty'
SELECT ROUND(AVG(age),2) as average_age
FROM retail_sales
WHERE category='Beauty'


--Q5. Write a sql query to find all the transactions where the total sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sales >1000


--Q6.Write a sql query to find the total number of transactions made by each gender in each category
SELECT 
category,
gender,
COUNT(*) as total_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category ASC

--Q7. Write a sql query to calculate average for each month. find best selling month in each year
SELECT 
	year,
	month
FROM
(SELECT 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	AVG(total_sales) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sales) DESC) as rank 
FROM retail_sales
GROUP BY year, month
) as t1
WHERE rank = 1


--Q8. Write a sql query to find the top 5 customers based on highest total sales
SELECT 
	customer_id,
	SUM(total_sales)
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sales) DESC
LIMIT 5


--Q9. Write a sql query to find number of unique customers who purchased item from each category

SELECT 
COUNT(DISTINCT customer_id) as unique_customer_count,
category
FROM retail_sales
GROUP BY category


--Q10. Write a sql query to create each shift and number of orders (example- Morning<12, Afternoon BETWEEN 12 and 17, evening >17)
SELECT 
	COUNT(transactions_id) as number_of_orders,
	shift
FROM
(SELECT *,
CASE 
	WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
	ELSE 'EVENING'
END as shift 
FROM retail_sales) as t1
GROUP BY shift








