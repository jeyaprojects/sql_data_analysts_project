use restaurant_db

--1--->view the menu item table
select * from menu_items



--2--->find the number of item in the menu table
select count(*)from menu_items


---3-->what are least and more epensive item in the menu
select item_name,price from menu_items 
group by item_name ,price
order by price desc

select item_name,price from menu_items 
group by item_name ,price
order by price 

---4--->how many Italian items are in the menu 
select count(*)as numberofitaliandishes from menu_items
where category="Italian"

--5---->least and expensive item in Italian dishes on menu
select item_name,price,category
from 
menu_items
where
category ="Italian"
group by item_name,price,category
order by price desc



--6=--->>how many dishes are in each catergory
select count(menu_item_id),category
from menu_items
group by category

--7-->average price within each category
select count(menu_item_id),category,avg(price)
from menu_items
group by category
/*
objective:2-->order table
1-->view the order table,what is the date range of table
2-->how many order are made within the date range;how many items are ordred within this date range
3--->which order has most number of items
4-->how many order had more than 12 items
*/
---questions:
---1-->view the order table details,
select * from order_details



---2--->what is the date range of table
select * from order_details
order by order_date

select 
min(order_date) as mindate,max(order_date) as maxdate
from 
order_details




---3-->how many order are made within the date range;
 select count(distinct order_id) from order_details


----4>how many items are ordered within this date range;
select count(*) from order_details



---5--->which order has most number of items
select order_id,count(item_id) as noofitems
from order_details
group by order_id
order by noofitems desc


6-->how many order had more than 12 items

select count(*)as noofodrdersmorethan12items from (
 select order_id,count(item_id)as noofitems
 from order_details
 group by order_id
having noofitems>12)as nomore12

/*objective 3:to analysis the customer behaviour:
1-->combine menu and order table together
2--->what are the least and most ordered items and what category are they in?
3--->what were the top 5 order that spend most money?
4--->views the details of highest spend order,and what insight can you gather from the results
5--->view the details of the highest top 5 spend  orders.what insight can you gather tfrom the results

(we always to join of transcation table to other table,andwe so do left join,s that we have all transaction available)
*/


---1-->combine menu and order table together
select * from menu_items
select * from order_details

--join using left by item_id

SELECT 
    *
FROM
    order_details AS od
        LEFT JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id


----2--->what are the least and most ordered items and what category are they in?
SELECT 
    item_name,category,count(order_details_id)as numoftimepurchased
FROM
    order_details AS od
        LEFT JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
    group by item_name,category
    order by numoftimepurchased desc
    



---3--->what were the top 5 order that spend most money?

SELECT order_id,sum(price) as money

FROM
    order_details AS od
        LEFT JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
group by order_id
order by  money desc
limit 5


---4--->views the details of highest spend order,and what insight can you gather from the results
--from above query we know arder_id =440 is highest spend money

SELECT 
    category,count(item_id)as noofitems
FROM
    order_details AS od
        LEFT JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
    where order_id=440
    group by category


--5--->view the details of the highest top 5 spend  orders.what insight can you gather tfrom the results

/*
we know the top 5 order
440	192.15
2075	191.05
1957	190.10
330	189.70
2675	185.10
*/
SELECT 
    order_id,category,count(item_id)as noofitems
FROM
    order_details AS od
        LEFT JOIN
    menu_items AS mi ON od.item_id = mi.menu_item_id
    where order_id in (440,2075,1957,330,2675)
    group by order_id,category

