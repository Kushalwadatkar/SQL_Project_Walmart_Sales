
-- Database Creation

    CREATE DATABASE IF NOT EXISTS walmartsales;

    CREATE TABLE IF NOT EXISTS sales(
    invoice_id VARCHAR(30) PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,    
    customer_type VARCHAR(30) NOT NULL,    
    gender VARCHAR(10) NOT NULL,    
    product_line VARCHAR(100) NOT NULL,   
    unit_price DECIMAL(10, 2) NOT NULL, 
    quantity INT NOT NULL,            
    VAT FLOAT(6, 4) NOT NULL,    
    total DECIMAL(10, 5) NOT NULL, 
    date DATETIME NOT NULL,           
    time TIME NOT NULL,      
    payment_method VARCHAR(30) NOT NULL, 
    cogs DECIMAL(10, 2) NOT NULL, 
    gross_margin_percent FLOAT(11, 9),   
    gross_income DECIMAL(10, 4)NOT NULL, 
    rating FLOAT(2, 1)
    );

-- Data Cleaning ----------------------------------------------------------------------------------------------------------------

SELECT * FROM walmartsales.sales; 

-- Add time_of_day Column -------------------------------------------------------------------------------------------------------

SELECT time
FROM sales;

SELECT time,
	(   
        CASE
		    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
            WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
            ELSE "Evening"
	    END
    ) AS time_of_date
FROM sales;
	
ALTER TABLE sales  ADD COLUMN time_of_day VARCHAR(30);

UPDATE sales
SET time_of_day = (
    CASE
        WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);

-- Add day_time Column -----------------------------------------------------------------------------------------------------------

SELECT  date
FROM sales;
	
SELECT date, dayname(date)
FROM sales;

ALTER TABLE sales  ADD COLUMN day_name VARCHAR(30);

UPDATE sales
SET day_name = dayname(date);

-- Add month_name Column ----------------------------------------------------------------------------------------------------------

SELECT date, monthname(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = monthname(date);

-----------------------------------------------------------------------------------------------------------------------------------
                                            PROBLEM STATEMENTS (QURIES)
-----------------------------------------------------------------------------------------------------------------------------------

1. How many unique cities does the data have?
	SELECT distinct city
	FROM sales;

2. In which city is each branch? 
	SELECT distinct branch,city
    FROM sales;
    
3. How many unique product lines does the data have?
	SELECT count(DISTINCT product_line)
    FROM sales;
    
4. What is the most common payment method?
	SELECT payment_method,
	COUNT(payment_method) AS cnt
    FROM sales
    Group By payment_method
    Order By cnt DESC;
    
5. What is the most selling product line?
    SELECT product_line,
    COUNT(product_line) AS cnt
    FROM sales
    Group By product_line
    Order BY cnt DESC;
    
6. What is the total revenue by month?
	SELECT month_name AS month,
    SUM(total) AS total_revenue
    FROM sales
    Group By month_name
    Order BY total_revenue;
    
7. What month had the largest COGS?
	SELECT month_name AS month,
    SUM(COGS) As cogs
    FROM sales
    Group By month_name
    Order By cogs DESC;
    
8. What product line had the largest revenue?
	SELECT product_line,
    SUM(total) AS largest_revenue
    FROM sales
    Group By product_line
    Order By largest_revenue;

9.  What is the city with the largest revenue?
	SELECT city,
    SUM(Total) AS largest_revenue
    From sales
    Group By city
    Order By largest_revenue;

10. What product line had the largest VAT?
	 SELECT product_line,
     SUM(VAT) AS vat
     FROM sales
     Group By product_line
     order BY vat;
    
11. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
	 SELECT  product_line, AVG(quantity) AS avg_qnty
	 FROM sales
     Group By product_line;
    
	 SELECT product_line,
		CASE
			WHEN AVG(quantity) > 5.5 THEN "Good"
			ELSE "Bad"
		END AS remark
	 FROM sales
	 GROUP BY product_line;

12. Which branch sold more products than average product sold?
	 SELECT branch, 
     SUM(quantity) AS qnty
	 FROM sales
	 GROUP BY branch
	 HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

13. What is the most common product line by gender?
	 SELECT product_line,Gender,
     COUNT(Gender) AS Total_Gender
     FROM sales
     Group By product_line, Gender
	 Order By Total_Gender DESC;
    
14. What is the average rating of each product line?
	 SELECT product_line, (AVG(rating)) as avg_rating
	 FROM sales
	 GROUP BY product_line
	 ORDER BY avg_rating DESC;
    
15. Number of sales made in each time of the day per weekday
	 SELECT time_of_day,
	 COUNT(*) AS total_sales
	 FROM sales
	 WHERE day_name = "Sunday"
	 GROUP BY time_of_day 
	 ORDER BY total_sales DESC;

16. Which of the customer types brings the most revenue?
	 SELECT customer_type,
     SUM(Total) AS most_revenue
     FROM sales
     Group By customer_type
     Order By most_revenue;

17. Which city has the largest tax percent/ VAT (**Value Added Tax**)?
	 SELECT city,
     ROUND(AVG(VAT),2) AS avg_vat
	 FROM sales
	 GROUP BY city 
	 ORDER BY avg_vat DESC;

18. Which customer type pays the most in VAT?
	 SELECT customer_type,
	 AVG(VAT) AS total_tax
	 FROM sales
	 GROUP BY customer_type
	 ORDER BY total_tax;

19. How many unique customer types does the data have?
	 SELECT DISTINCT customer_type
     FROM sales;
    
20. How many unique payment methods does the data have?
	 SELECT DISTINCT payment_method
     FROM sales;

21. What is the most common customer type?
	 SELECT customer_type,
     COUNT(*) AS count
     FROM sales
     Group By customer_type
     Order By count DESC;
    
22. What is the gender of most of the customers?
	 SELECT gender,
     COUNT(*) As gender_cnt
     FROM sales
     Group By gender
     Order By gender_cnt;
    
23. What is the gender distribution per branch?
	 SELECT gender,branch,
     Count(*) AS gender_cnt
     FROM sales
     Group By gender, branch;

24. Which time of the day do customers give most ratings?
	 SELECT time_of_day,
     AVG(rating) AS avg_rating
     FROM sales
	 Group BY time_of_day
	 LIMIT 1,1;
    
25. Which time of the day do customers give most ratings per branch?
	 SELECT time_of_day,branch,
     AVG(rating) AS avg_rating
     FROM sales
     Group By time_of_day,branch
     Order By avg_rating DESC;

26. Which day fo the week has the best avg ratings?
	 SELECT day_name,
     AVG(rating) AS avg_rating
     FROM sales
     Group By day_name
     Order By avg_rating DESC;

27. Which day of the week has the best average ratings per branch?
	 SELECT day_name,branch,
     AVG(rating) AS avg_rating
     FROM sales
     Group By day_name,branch
     Order By avg_rating DESC;

28. Calculate the total sales amount for each city.
	 SELECT city,
     SUM(Total) AS total_sales
     FROM sales
     Group By city;

29. Find the average unit price for each product line.
	 SELECT product_line,
     FORMAT(AVG(unit_price),2) AS avg_unitprice
     FROM sales
     Group By product_line;

30. Identify the customer type (Member/Normal) with the highest total sales amount.
	 SELECT customer_type, SUM(Total) AS total_sales
	 FROM sales
     Group By customer_type
     LIMIT 1,1;
     
31. Determine the distribution of ratings (e.g., count of ratings falling in different ranges such as 0-2, 2-4, 4-6, etc.).
	 SELECT 
     CASE
        WHEN Rating BETWEEN 0 AND 2 THEN '0-2'
        WHEN Rating BETWEEN 2 AND 4 THEN '2-4'
        WHEN Rating BETWEEN 4 AND 6 THEN '4-6'
        WHEN Rating BETWEEN 6 AND 8 THEN '6-8'
        WHEN Rating BETWEEN 8 AND 10 THEN '8-10'
        ELSE 'Unknown'
     END AS Rating_Range,
     COUNT(*) AS Rating_Count
	 FROM sales
	 GROUP BY Rating_Range
     Order By Rating_Range;
    
     SELECT 
     CONCAT(ROUND(Rating / 2) * 2, '-', ROUND(Rating / 2) * 2 + 2) AS rating_range,
     COUNT(*) AS rating_count
	 FROM sales
	 GROUP BY rating_range
	 ORDER BY rating_range;

32. Find the total sales amount for each weekday.
	 SELECT day_name, ROUND(SUM(Total),2) AS total_sales
     FROM sales
     Group By day_name; 
    
33. Calculate the total sales amount for each branch.
	 SELECT branch, ROUND(SUM(Total),2) AS total_sales
     FROM sales
     Group By branch;

34. Identify the product line with the highest gross margin percentage.
	 SELECT product_line, MAX(gross_margin_percent) AS Highst_Grs_marg_pcnt
	 FROM sales
     Group By product_line
     LIMIT 1;

35. Determine the month with the highest total sales amount.
	 SELECT month_name,
     MAX(Total) AS Highst_total_sales
     FROM sales
     Group By month_name
     LIMIT 1;

36. Find the average quantity sold for each product line.
	 SELECT product_line,
     AVG(quantity) AS avg_quantity
     FROM sales
     Group By product_line;
	
37. Calculate the total sales amount for each customer type (Member/Normal) in each city.
	 SELECT customer_type, city,
     SUM(Total) AS total_sales
     FROM sales
     Group By customer_type, city;

38. Retrieve the total number of invoices in the dataset.
	 SELECT COUNT(*) As Total_Invoice
     FROM sales;

39. Calculate the average total amount of each invoice.
	 SELECT invoice_id,
     AVG(Total) AS avg_total_amount
     FROM sales
     Group By invoice_id;

40. Find the highest and lowest gross income.
	 SELECT MAX(gross_income) AS Highest_gross_icome,
     MIN(gross_income) AS Lowest_gross_icome
     FROM sales;

41. Determine the most popular product line.
	 SELECT product_line,
     COUNT(*) AS Most_sales
     FROM sales
     Group By product_line
     LIMIT 1;

42. Identify the branch with the highest average gross margin percentage.
	 SELECT branch,
     AVG(gross_margin_percent) AS avg_GMP
     FROM sales
     Group By Branch
     LIMIT 1;

43. Count the number of transactions made via each payment method.
	 SELECT payment_method,
     COUNT(*) AS transaction_count
     FROM sales
     Group By payment_method;

44. Calculate the total sales amount for each month.
	 SELECT month_name,
     SUM(Total) AS total_sales
     FROM sales
     Group By month_name;

45. Find the average rating for each product line.
	 SELECT product_line,
     AVG(rating) AS avg_rating
     FROM sales
     Group By product_line;

46. Identify the busiest time of the day for shopping.
	SELECT time_of_day,
    COUNT(*) as busiest_time_of_day
    FROM sales
    Group By time_of_day
    LIMIT 1;

47. Determine the day of the week with the highest sales volume.
	 SELECT day_name,
     MAX(Total) AS Highest_sales
     FROM sales
     Group By day_name
     Order BY Highest_sales DESC
     LIMIT 1;


   
    
