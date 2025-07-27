DROP TABLE IF EXISTS retail_sales;
create table retail_sales
		(	
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(15),
			quantity INT,
			price_per_unit FLOAT,
			cogs FLOAT,	
			total_sale FLOAT
		);
		
SELECT * FROM retail_sales
LIMIT 10;

SELECT COUNT(*) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--DELETING THESE NULLS- DATA CLEANING
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--Data Exploration
--How many sales we have?
SELECT COUNT(*) AS total_sale
FROM retail_sales;
--How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) AS total_cust
FROM retail_sales;
--How many unique categories?
SELECT COUNT(DISTINCT category) AS total_cat
FROM retail_sales;

--Data Analyst 
--My analysis and findings
--1.SQL query to retrive all columns for sales made on '2022-11-05'
SELECT *
FROM retail_sales
WHERE sale_date='2022-11-05';

--2.SQL query to retrive all transactions where the category is 'Clothing' and quantity sold is more than 3 in the monnth of NOV-2022
SELECT *
FROM retail_sales
WHERE category='Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM')='2022-11'
	AND
	quantity>3

--3.SQL query to calculate the total sales for each category
SELECT category,SUM(total_sale) AS total_sale,COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category

--4.SQL query to find the avg age of customers who purchased items from "Beauty" category
SELECT ROUND(AVG(age),2) AS avg_age
FROM retail_sales
WHERE category='Beauty'

--5.SQL query to find all transactions where the total sale is greater than 1000
SELECT *
FROM retail_sales
WHERE total_sale>1000

--SQL query to find total no of transactions (transaction id) made by each gender in each category
SELECT gender,category,COUNT(transactions_id)
FROM retail_sales
GROUP BY 1,2  
ORDER BY 2    -- I did it!! Proud of me.

--SQL query to calculate the average sale for each month. Find out best selling month in each year.
SELECT year,month,avg_sale
FROM
	(
	SELECT EXTRACT(YEAR FROM sale_date) as year,   --IN MySQL to select year..it is YEAR(sale_date)
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
	FROM retail_sales
	GROUP BY 1,2
	--ORDER BY 1,3 DESC
	) as t1
WHERE rank=1

--SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id,SUM(total_sale) as sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--SQL query to find the no of unique customers who purchased items from each category
SELECT category,COUNT(DISTINCT customer_id) AS unique_cust
FROM retail_sales
GROUP BY category

--sql query to create each shift and no of orders (Morning <=12,Aftn between 12 and 17, Evening >17)
SELECT EXTRACT(HOUR FROM CURRENT_TIME) --my time
--As we cant group by 'shift' we use CTE-Common Table Expression...then we can group by shift
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT shift,COUNT(*) AS total_orders FROM hourly_sale
GROUP BY shift




