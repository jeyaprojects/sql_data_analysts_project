# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Sam-ple_sales`.

- **Table Creation**:A table named `retail_sales` is created by importing the data after downloading from any source/network/website.



### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
- **data type changing for datetime:for requirement datetime is changed to date and time

```sql
SELECT * FROM dbo.retail_sales

--To get total record count
select COUNT (*) from  retail_sales

---data cleaning:to remove null values
select COUNT(*) from retail_sales
where transactions_id is null

select COUNT(*) from retail_sales
where sale_date is null

select COUNT(*) from retail_sales
where sale_time is null

---to get month as 11 and year 2022
SELECT FORMAT(new_sales_date, 'yyyy-MM') AS formatted_date
FROM retail_sales;

---we do checking of null values in single quote
select * from retail_sales
where 
  transactions_id is null
  or
  sale_date is null
  or
  sale_time is null
  or
  customer_id is null
  or
  gender is null
  or
  age is null
  or
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null

  delete from retail_sales
  where
  transactions_id is null
  or
  sale_date is null
  or
  sale_time is null
  or
  customer_id is null
  or
  gender is null
  or
  
  category is null
  or
  quantiy is null
  or
  price_per_unit is null
  or
  cogs is null
  or
  total_sale is null

  ---to check how many left
  select count (*) from retail_sales

  delete from retail_sales
  where 
  age is null

  select count (*) from retail_sales

  --data exploration
  --how many sales we have?

  select count(*) as total_sales
  from retail_sales
  
  ---how many unique customer we have?
  select count( distinct customer_id) from retail_sales

  --how many distinct category?
  select distinct category from retail_sales


  ---to change datatype of sale_date to date
  select convert (DATE,sale_date) as date_only 
  from retail_sales

  --permantely changing the datatype by adding new column and copy from old column and then drop the old column

  ---- Step 1: Add new column
  Alter table retail_sales add new_sales_time DateTime

  select * from retail_sales

  ---copying the data from old column
  update retail_sales
  set new_sales_time =cast(salestime as datetime)

  ---drop the old column
  alter table retail_sales  drop column salestime

  ---rename the new column
 ---- ALTER TABLE retail_sales RENAME COLUMN new_sales_date TO sale_date

   select * from retail_sales
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. ** Write a SQL query to retrieve all columns for sales made on '2022-11-05**
```sql
SELECT *
FROM retail_sales
WHERE new_sales_date = '2022-11-05';
```

2. **Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022:**
```sql
select *
from retail_sales
where category ='Clothing'

and
quantiy >= 4

and
year(new_sales_date)=2022
and 
month (new_sales_date)=11
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category**
```sql
select 
category,
sum(total_sale) as net_sales ,
count(*) as total_order
from 
retail_sales
group by category
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

```sql
select 
avg(age) as Avg_age
from
 retail_sales
 where category ='Beauty'


```
5. ** Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select *

from 
retail_sales

where 
total_sale >=1000
```

6. **WWrite a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select 
   category,
    gender,
    count(*)as total_transaction
from 
retail_sales
group by category,gender
order by category
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
Sselect 
    year,
    month,
    avg_sales
from
(
         select 
            year(new_sales_date) as year,
            month(new_sales_date) as month,
            avg(total_sale)as avg_sales,
            rank() over (
			     partition by year(new_sales_date)
			     order by avg(total_sale)desc
			)as rank
           from retail_sales
           group by 
           YEAR(new_sales_date),
		   MONTH(new_sales_date)
) as t1
where rank =1

```

8. **Write a SQL query to find the top 5 customers based on the highest total sales  **:
```sql
select top 5
customer_id,
sum(total_sale) as Total_sales

from retail_sales
group by customer_id
order by sum(total_sale)desc
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select  category from retail_sales 

select 
category as categoryname,
count(distinct customer_id) as unique_customer
from
retail_sales
group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN DATEPART(HOUR, new_sales_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, new_sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift

```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `database_setup.sql` file to create and populate the database.
3. **Run the Queries**: Use the SQL queries provided in the `analysis_queries.sql` file to perform your analysis.
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - Jeya

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. 


- **LinkedIn**:https://www.linkedin.com/in/jeyaselvalakshmi-qa/
- 

Thank you for your support, and I look forward to connecting with you!
