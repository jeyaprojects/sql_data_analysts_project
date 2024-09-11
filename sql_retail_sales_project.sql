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
  ---Data Analysts and business key problems and answers

  ---- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
  SELECT *
FROM retail_sales
WHERE new_sales_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022


select *
from retail_sales
where category ='Clothing'

and
quantiy >= 4

and
year(new_sales_date)=2022
and 
month (new_sales_date)=11

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
category,
sum(total_sale) as net_sales ,
count(*) as total_order
from 
retail_sales
group by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
avg(age) as Avg_age
from
 retail_sales
 where category ='Beauty'

 
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *

from 
retail_sales

where 
total_sale >=1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


select 
   category,
    gender,
    count(*)as total_transaction
from 
retail_sales
group by category,gender
order by category


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year


--this for trial 

select 
year(new_sales_date) as year,
month(new_sales_date) as month,

avg(total_sale)as avg_sales


from retail_sales
group by 
YEAR(new_sales_date),MONTH(new_sales_date)

order by 
year(new_sales_date),
avg(total_sale) desc

---solution

select 
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top 5
customer_id,
sum(total_sale) as Total_sales

from retail_sales
group by customer_id
order by sum(total_sale)desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


select  category from retail_sales 

select 
category as categoryname,
count(distinct customer_id) as unique_customer
from
retail_sales
group by category


--changing the datatype of sales_time
---- Step 1: Add new column
Alter table retail_sales add salestime dateTime

select * from retail_sales

---copying the data from old column
update retail_sales
set salestime =cast(new_sales_time as datetime)

---drop the old column
alter table retail_sales  drop column new_sales_time

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)




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

---end of project---


















 








