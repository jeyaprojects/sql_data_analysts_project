---jeya_library_project_task---
select * from books
select * from branch
select * from employees
select * from issued_status
select * from members
select * from return_status

---2. CRUD Operations
---Create: Inserted sample records into the books table.
---Read: Retrieved and displayed data from various tables.
---Update: Updated records in the employees table.
---Delete: Removed records from the members table as needed.

---Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"


INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
values ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')


----Task 2: Update an Existing Member's Address
select * from members

UPDATE members
set member_address='500 Main St'
where member_id='C101'
select * from members



---Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

select * From issued_status

Delete from issued_status
where issued_id='IS121'


select * From issued_status
where issued_id='IS121'

---Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

select * from issued_status
where issued_emp_id='E101'

---Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

select * from issued_status

select issued_emp_id,
count(issued_id)as book_issued_more_than_one
from issued_status
group by issued_emp_id
having count(issued_id)>1 

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables**: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

---here we join book and issued_status table and to query and we create table on results

--step 1:join the book and issued_status   table with isbn as common thing

select *
from books as b
join
issued_status as ist
on ist.issued_book_isbn=b.isbn

---step 2: group by isbn and making  count by isbn_id
select 
b.isbn,
b.book_title,
count(ist.issued_id)as no_of_issued_count
from books as b
join
issued_status as ist
on b.isbn=ist.issued_book_isbn
group by
b.isbn,b.book_title

--step 3:CTAS(create table as select)
--->first create table structure
CREATE TABLE book_issue_summary (
    isbn VARCHAR(50),
    book_title VARCHAR(100),
    book_issued_cnt INT
);


---insert data using "insert into and select"
INSERT INTO book_issue_summary (isbn, book_title, book_issued_cnt)
SELECT 
    b.isbn,
    b.book_title,
    COUNT(ist.issued_id) AS book_issued_cnt
FROM books AS b
JOIN issued_status AS ist
    ON b.isbn = ist.issued_book_isbn
GROUP BY b.isbn, b.book_title;


---check the new created table
select * from book_issue_summary


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

