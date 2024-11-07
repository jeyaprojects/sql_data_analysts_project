select * from Customers

select * from Order_Product

select * from Orders

select * from Product

select distinct CookieID from Order_Product

select count(distinct CookieID) from Order_Product

select CustomerName,City from Customers where CustomerID =1


--where

select * from Product where CookieName like 'S%'

--order by
select *  from Orders order by OrderTotal
select *  from Orders order by OrderDate
select * from Customers order by City Asc,Country DESC
select * from Customers order by City DESC,Country ASC




--And

select * from  Customers where  Country like 'U%' and  CustomerName like 'T%'





---or
select * from Customers where  Country like 'U%' or Country like 'F%' and CustomerName like 'A%'





--NOT/NOT In /NOT between /NOT like
select * from Customers where CustomerName not like 'A%'








---insert


INSERT INTO Customers (CustomerID, CustomerName, Phone, Address, City, State, Zip, Country, Notes)
VALUES
(7, 'Homemade Snacks', '230-112-1232', '23 Mayor Lane', 'Tree Rose', 'CA', '67003', 'France', 'Homemade delicious food');

select * from Customers




--insert into product with multiple rows

insert into Product(CookieID,CookieName,RevenuePerCookie,CostPerCookie)
values
(7,'Banana Chip',5.00,2.75),
(8,'Badam Biscult',7.00,3.45),
(9,'Manga Pista Roll',6.00,2.75)

select * from Product





--IS NULL.IS NOT nULL

select * from Product where CookieName is not null

select * from Customers where State is null







---Update: you omit the WHERE clause, all records in the table will be updated!

update Customers set State='Paris Region' where City ='Paris'

select * from Customers






----delete:if we  omit the WHERE clause, all records in the table will be deleted!

delete from Product where CookieName ='Manga Pista Roll'

select * from Product


---Top /Top percent
select   top 5  * from Order_Product 

select  top 5 * from Order_Product where Quantity >200 
order by Quantity desc


select * from Order_Product
select   top 5  * from Order_Product
select   top 10 percent  * from Order_Product 
select   top 10 percent  * from Order_Product where Quantity >100
select   top 10 percent  * from Order_Product where Quantity >100 order by Quantity desc

---MIN  MAX SUm COUNT AVG

select min(Quantity) from Order_Product
select min(Quantity)from Order_Product where CookieID = 4
select min(Quantity)  As  minmum_quntity ,CookieID from Order_Product group by CookieID

select max(Quantity) from Order_Product
select max(Quantity)from Order_Product where CookieID = 4
select max(Quantity)  As  minmum_quntity ,CookieID from Order_Product group by CookieID


---count :If you specify a column name instead of (*), NULL values will not be counted.

select * from Product
select count(*)from Product
select count(*) As no_of_records from Product where RevenuePerCookie >3

SELECT COUNT(*) AS no_of_records, CookieName, RevenuePerCookie
FROM Product
WHERE RevenuePerCookie > 3
GROUP BY CookieName, RevenuePerCookie
ORDER BY RevenuePerCookie;


select * from Order_Product
select count(*) from Order_Product
select count(OrderID) as NumberOfRecord,CookieID from Order_Product where Quantity >50
group by CookieID



SELECT COUNT(distinct OrderID) AS OrderCount
FROM Order_Product
WHERE CookieID = 1;

select OrderID from Order_Product where CookieID=1


---sum
select * from Product
select sum(RevenuePerCookie) as SumOfRevenue from Product

---AVG
select * from Product
select AVG(RevenuePerCookie) as SumOfRevenue from Product


---like: The percent sign % represents zero, one, or multiple characters. The underscore sign _ represents one, single characte

select * from Customers
select * from Customers where CustomerName like 'T%'--startw with T
select * from Customers where CustomerName like '%s'---ends with s
select * from Customers where City like '%s'
select * from Customers where CustomerName like '%s' and  CustomerName like 'T%'--starts with T and ends with s
select * from Customers where City like '%s' or Phone like '9%'
select * from Customers where CustomerName like 'W%s'--starts with w and ends with s

select * from Customers
select * from Customers where State like 'W_'--w and one charac ex:W!,W2
select * from Customers where City like 'Mo_il_'

select * from Customers where CustomerName like '[TA]%'--starts either T A
select * from Customers where CustomerName like '[A-H]%'---start in range from A to H
select * from Product where CookieName like '[A-C]%'--its not underscore it is hifen


--In:The IN operator is a shorthand for multiple OR conditions.

select * from Product
select * from Product where CookieName  not in ('Sugar','Raisin','Chip','Fortune')-- anything other than these four specified values.
select * from Product where CookieName   in ('Fortune Cookie','Chip')
select * from Product where CookieName   in ('Sugar','Raisin','Chip','Fortune')--matches one of these values

--In (select)
select * from Order_Product
select * from Orders

select * from Order_Product where OrderID in(select OrderID from Orders )
select * from Order_Product where OrderID  not in(select OrderID from Orders )

select * from Customers
select * from Orders

select  * from Customers where CustomerID in(select  CustomerID from Orders)
select  * from Customers where CustomerID  not in(select  CustomerID from Orders)


--Between  ANd:The BETWEEN operator selects values within a given range. The values can be numbers, text, or dates.

---The BETWEEN operator is inclusive: begin and end values are included.

select * from Order_Product
select * from Order_Product where OrderID between 7 and 10

--Not between and
select * from Order_Product
select count(*) as noofrecord from Order_Product where OrderID not  between 7 and 10
select  * from Order_Product where OrderID not  between 7 and 10

select  * from Order_Product where OrderID not  between 7 and 10 
and
OrderID in (select OrderID from Orders)


--between-date
select * from Orders
select * from Orders where OrderDate between '2022-02-01' and '2022-03-01'

--Alias
select * from  Customers
select CustomerName as Name from Customers

--Using [square brackets]  or  "" for aliases with space characters:
select CustomerName as [Customer from Paris] from Customers where City='Paris'
select CustomerName as "Customer from Paris" from Customers where City='Paris'

--Concatedenate
select * from Customers
select CustomerName,Address + '---' +City as Address from Customers

--Join
select * from Order_Product 
select * from Orders
--INNER is the default join type for JOIN, so when you write JOIN the parser actually writes INNER JOIN.
select * from Orders
inner join
Order_Product 
on
Order_Product.OrderID=Orders.OrderID


select ORD.CustomerID,ORD.OrderID,OP.CookieID,OP.Quantity from Orders as ORD
inner join
Order_Product as OP
on
OP.OrderID=ORD.OrderID


--left join
select ORD.CustomerID,ORD.OrderID,OP.CookieID,OP.Quantity from Orders as ORD
left join
Order_Product as OP
on
OP.OrderID=ORD.OrderID

--right join
select ORD.CustomerID,ORD.OrderID,OP.CookieID,OP.Quantity from Orders as ORD
right join
Order_Product as OP
on
OP.OrderID=ORD.OrderID

select * from Customers
select * from Order_Product 
select * from Product
select * from Orders

--join 4 tables
select * from Order_Product as OP
join Product as P
on
OP.CookieID=P.CookieID
join Orders as O
on
O.OrderID=OP.OrderID
join Customers as C
on
C.CustomerID=O.CustomerID

--left join
select * from Customers
select * from Orders

select * from Customers as C
join
Orders as O
on
O.CustomerID=C.CustomerID

select * from Orders as O
right join
Customers as C
on
O.CustomerID=C.CustomerID

--The FULL OUTER JOIN keyword returns all records when there is a match in left (table1) or right (table2) table records.

--Tip: FULL OUTER JOIN and FULL JOIN are the same.

--The UNION operator is used to combine the result-set of two or more SELECT statements.

--Every SELECT statement within UNION must have the same number of columns
---The columns must also have similar data types
--The columns in every SELECT statement must also be in the same order
--Note: If some customers or suppliers have the same city, each city will only be listed once, because UNION selects only distinct values. Use UNION ALL to also select duplicate values!


--group by
--The GROUP BY statement groups rows that have the same values into summary rows, like "find the number of customers in each country".

---The GROUP BY statement is often used with aggregate functions (COUNT(), MAX(), MIN(), SUM(), AVG()) to group the result-set by one or more columns.

select * from Customers
select * from Order_Product
select * from Orders
select * from Product

select  count(OrderID),CookieID from Order_Product group by CookieID

select  count(OrderID),CookieID
from Order_Product
group by CookieID
order by count(OrderID)

select count(OrderID),CustomerID 
from Orders
group by CustomerID
order by count(OrderID)

--group by with  join
select * from Customers
select * from Orders

select  count(O.OrderID) as  "NO of Order" ,O.CustomerID,C.CustomerName
from Customers as C
join
Orders as O
on C.CustomerID=O.CustomerID
group by
O.CustomerID,C.CustomerName


---Having:
---The HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
--syntax:SELECT column_name(s)
--FROM table_name
--WHERE condition
--GROUP BY column_name(s)
--HAVING condition
--ORDER BY column_name(s);


select * from Customers
select * from Orders


select count(O.OrderID) as "No Of Orders",
O.CustomerID,C.CustomerName
from Customers as C
join
Orders as O
on
C.CustomerID=O.CustomerID
group by O.CustomerID,C.CustomerName
having count(O.OrderID) >10



select count(O.OrderID) as "No Of Orders",
O.CustomerID,C.CustomerName
from Customers as C
join
Orders as O
on
C.CustomerID=O.CustomerID
group by O.CustomerID,C.CustomerName
having count(O.OrderID) >10
order by
count(O.OrderID) desc

---Exist:The EXISTS operator is used to test for the existence of any record in a subquery.

--The EXISTS operator returns TRUE if the subquery returns one or more records


select * from Customers
select * from Orders

select  C.CustomerID,C.CustomerName
from Customers as C
where
exists
(
select * 
from 
Orders as O
where
C.CustomerID=O.CustomerID
and
OrderTotal >200

)




select  C.CustomerID,C.CustomerName
from Customers as C
where
exists
(
select * 
from 
Orders as O
where
C.CustomerID=O.CustomerID
and
OrderTotal =3518.00

)



--Any:The ANY operator:

--returns a boolean value as a result
---returns TRUE if ANY of the subquery values meet the condition
---ANY means that the condition will be true if the operation is true for any of the values in the range.
---Note: The operator must be a standard comparison operator (=, <>, !=, >, >=, <, or <=).
select * from Customers
select * from  Orders


select C.CustomerID,C.CustomerName from Customers as C
where C.CustomerID = ANY
(
select O.CustomerID from Orders as O
where 
O.OrderTotal =2238.00
)




--ALL:he ALL operator:
--returns a boolean value as a result
--returns TRUE if ALL of the subquery values meet the condition
---is used with SELECT, WHERE and HAVING statements
--is used with SELECT, WHERE and HAVING statements

select C.CustomerID,C.CustomerName
from Customers as C
where 
C.CustomerID = ALL
(
select O.CustomerID
from 
Orders as O
where
O.OrderTotal !>10
)
---above not all records are not greater than 10 --true
select C.CustomerID,C.CustomerName
from Customers as C
where 
C.CustomerID = ALL
(
select O.CustomerID
from 
Orders as O
where
O.OrderTotal <10
)


---select  into:The SELECT INTO statement copies data from one table into a new table.
/*
SELECT *
INTO newtable [IN externaldb]
FROM oldtable
WHERE condition;
*/
--SQL statement uses the IN clause to copy the table into a new table in another database:

select * INTO BACkupcustomer from Customers 
select * from BACkupcustomer

select * from Product
select * from Order_Product

select P.CookieID,P.CookieName,OP.Quantity into "cookiesquantity morethan 200"  from Product as P
join
Order_Product as OP
on
P.CookieID=OP.CookieID
where
OP.Quantity > 200

select * from [cookiesquantity morethan 200]

--Tip: SELECT INTO can also be used to create a new, empty table using the schema of another. Just add a WHERE clause that causes the query to return no data:
select * into newtablewithnodata 
from Customers
where 1=0

select * from newtablewithnodata


---insert  into select
/*
The INSERT INTO SELECT statement copies data from one table and inserts it into another table.

The INSERT INTO SELECT statement requires that the data types in source and target tables match.

*/

select * from Customers
select * from newtablewithnodata

insert into newtablewithnodata
select * from Customers
where Country ='United States'

select * from newtablewithnodata



--case:
/*
The CASE expression goes through conditions and returns a value when the first condition is met (like an if-then-else statement). So, once a condition is true, it will stop reading and return the result. If no conditions are true, it returns the value in the ELSE clause.

If there is no ELSE part and no conditions are true, it returns NULL.
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
*/
select * from Order_Product

select OrderID,CookieID ,
case
   when Quantity>200 Then 'quantity greater than 200'
   when Quantity >100 Then 'quantity greater than 100'
   else 'quantity less than 100'
END AS Quantitybyvalues

from Order_Product


---Stored Procedures
/*
A stored procedure is a prepared SQL code that you can save, so the code can be reused over and over again.

So if you have an SQL query that you write over and over again, save it as a stored procedure, and then just call it to execute it.

You can also pass parameters to a stored procedure, so that the stored procedure can act based on the parameter value(s) that is passed.

Stored Procedure Syntax
CREATE PROCEDURE procedure_name
AS
sql_statement
GO;

--to execute:EXEC procedure_name;
*/

CREATE PROCEDURE allfourtableinone
AS
select * from Customers
select * from Product
select * from Order_Product
select * from Orders
go

exec allfourtableinone

---one parameter in store procedure
create procedure CustomersCity @City nvarchar(30)
As
select * from Customers
where City=@City

exec CustomersCity @City='Paris'


--multiparameter-->we use AND

select * from Customers

create procedure CustomerStateandCountry @State nvarchar(50),@Country nvarchar(50)
AS
select * from Customers
where
State=@State  AND Country=@Country

exec CustomerStateandCountry @State='WA',@Country='United States '

---create database



--drop table
drop table newtablewithnodata
drop table [cookiesquantity morethan 200]
drop table BACkupcustomer


