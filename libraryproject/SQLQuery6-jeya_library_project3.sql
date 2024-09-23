
-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

select *

from books

where category ='Classic'

-- Task 8: Find Total Rental Income by Category:
select category as by_category,
sum(rental_price)as Total_rental_income
from books
group by category

--above is not the answer,it shows according to books,here we need to join books and issued_status

select b.category ,

sum(b.rental_price),
count(*)
from issued_status as ist
join
books as b
on b.isbn=ist.issued_book_isbn
group by b.category


SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.category

--Task 9:-- List Members Who Registered in the Last 180 Days:
SELECT * 
FROM members
WHERE reg_date >= DATEADD(DAY, -180, GETDATE());

-- task 10 List Employees with Their Branch Manager's Name and their branch details:

select
e1.*,
b.manager_id,
e2.emp_id as manager_name
 from employees as e1
join
branch as b
on
e1.branch_id =b.branch_id
join
employees as e2
on
b.manager_id=e2.emp_id


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
--here we need to create a table
create table books_rental_price_greater7
(
isbn varchar(50),
book_title varchar(100),
category varchar(50),
rental_price float,
status varchar(50),
author varchar(50),
publisher varchar(50)

)

insert into books_rental_price_greater7
(
isbn,
book_title,
category ,
rental_price,
status ,
author,
publisher
)
select *
from
books
where
rental_price >=7
----
select 
*
from books_rental_price_greater7


-- Task 12: Retrieve the List of Books Not Yet Returned
select * from books
where 
status ='no'


--need to combine status_issued and return status
select 
ist.issued_book_name
from issued_status as ist
left join
return_status as rst
on
ist.issued_id=rst.issued_id
where rst.return_id is null

--------------------------------