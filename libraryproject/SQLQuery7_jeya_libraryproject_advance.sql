--library project--
select * from  books
select * from  branch
select * from  employees
select * from  issued_status
select * from  return_status
select * from  members

---------------------------------------
/*
Task 13: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.

--here we need connect few tables together
--issued_status with member with books with return status
--->we need to find filter books which is return
--->overdue>30 days DATEDIFF(): This function calculates 
the difference in days between two dates (ist.issued_date and the current date GETDATE()).
*/
select 
m.member_id,
m.member_name,
bk.book_title,
ist.issued_date,
rst.return_date,
CURRENT_DATE-ist.issued_date as days_overdue
from  issued_status as ist
join
members as m
on 
m.member_id=ist.issued_member_id
join
books as bk
on 
ist.issued_book_isbn=bk.isbn
left join
return_status as rst
on ist.issued_id=rst.issued_id
where rst.return_date is null

---same task--
SELECT 
    m.member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    rst.return_date,
    DATEDIFF(DAY, ist.issued_date, GETDATE()) AS days_overdue
FROM issued_status AS ist
JOIN members AS m
    ON m.member_id = ist.issued_member_id
JOIN books AS bk
    ON ist.issued_book_isbn = bk.isbn
LEFT JOIN return_status AS rst
    ON ist.issued_id = rst.issued_id
WHERE rst.return_date IS NULL
And
DATEDIFF(DAY, ist.issued_date, GETDATE()) >30
ORDER BY
m.member_id

-- 
/*    
Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/
--here manually we changed status 
SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-330-25864-8';


SELECT * FROM books
WHERE isbn = '978-0-451-52994-2';

UPDATE books
SET status = 'no'
WHERE isbn = '978-0-451-52994-2';


SELECT * FROM return_status
WHERE issued_id = 'IS130';

INSERT INTO return_status (return_id, issued_id,return_book_name, return_date, return_book_isbn)
VALUES ('RS125', 'IS130','NULL', GETDATE(), 'ISBN123');
SELECT * FROM return_status
WHERE issued_id = 'IS130';


------------Store Procedure:as soon as somebody returns book.it should be updated in book table
--syntax for store procedure
/*
CREATE PROCEDURE procedure_name
    @parameter1 datatype,       -- Input parameter
    @parameter2 datatype OUTPUT -- Output parameter (optional)
AS
BEGIN
    -- SQL statements go here
END;
*/

--to execute
/*
DECLARE @issued_count INT;
EXEC GetIssuedBookCount @member_id = 1, @issued_count = @issued_count OUTPUT;
PRINT @issued_count;
*/

--------------------------




CREATE PROCEDURE add_return_records
    @p_return_id VARCHAR(50),
    @p_issued_id VARCHAR(50),
    @p_return_book_name VARCHAR(50),
    @p_return_date DATETIME2(7),
    @p_return_book_isbn VARCHAR(50)
AS
BEGIN
    DECLARE @v_isbn VARCHAR(50);
    DECLARE @v_book_name VARCHAR(80);

    -- Insert into return_status based on user's input
    INSERT INTO return_status (return_id, issued_id, return_book_name, return_date, return_book_isbn)
    VALUES (@p_return_id, @p_issued_id, @p_return_book_name, @p_return_date, @p_return_book_isbn);

    -- Select the issued book ISBN and book name based on the issued_id
    SELECT 
        @v_isbn = issued_book_isbn,
        @v_book_name = issued_book_name
    FROM issued_status
    WHERE issued_id = @p_issued_id;

    -- Update the book's status
    UPDATE books
    SET status = 'yes'
    WHERE isbn = @v_isbn;

    -- Print a message
    PRINT 'Thank you for returning the book: ' + @v_book_name;

END;

------------
--to check the store procedure is created:tables-->programmability-->stored produre
--to run
--before runing;for our understanding we need to chkif there any book is not return
--issued_status--
select * from issued_status
--let take issued_id IS135-and check wherther it is return or not in return_status
select * from return_status
--so IS135 is not returned--now lets collect details about this
select issued_book_isbn from issued_status where issued_id = 'IS135'
--978-0-307-58837-1
--goto books table and collect details of 978-0-307-58837-1
select * from books where isbn='978-0-307-58837-1'
--book titile--Sapiens: A Brief History of Humankind
---test the function--
select * from issued_status where issued_id='IS135'
select * from return_status where issued_id='IS135'--it show its not return:no result
select * from books where isbn='978-0-307-58837-1'
select * from issued_status where issued_book_isbn='978-0-307-58837-1'
------------------------------------------
--suppose we need to alter the producer use'alter procedure'
---------------------------------------------------------




---to excute---
/*
Insert a record into the return_status table.
Update the status of the returned book in the books table.
Print a message confirming the return.
*/

EXEC add_return_records 
    @p_return_id = 'RS138', 
    @p_issued_id = 'IS135', 
    @p_return_book_name = 'Sapiens: A Brief History of Humankind', 
    @p_return_date = '2024-09-18',  -- passing a specific date
    @p_return_book_isbn = '978-0-307-58837-1';

	/*
	(1 row affected)

(1 row affected)
Thank you for returning the book: Sapiens: A Brief History of Humankind

Completion time: 2024-09-18T15:58:11.2589346+05:30
*/
--to check
select * from return_status where issued_id='IS135'
select * from books where isbn='978-0-307-58837-1'

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/
/*
--here we need to join many table:branch-->branch detail;issued_status--->book issued;employee-->to get branch id
return_status-->return details;books-->for rental details
*/

---step 1
select * from  books
select * from  branch
select * from  employees
select * from  issued_status
select * from  return_status

---step 2
select * from branch as bch
join 
employees as emp
on
bch.branch_id=emp.branch_id
join
issued_status as ist
on
ist.issued_emp_id=emp.emp_id
left join
return_status as rst
on
rst.issued_id=ist.issued_id
join
books as bk
on
bk.isbn=ist.issued_book_isbn

--step3

select 
bch.branch_id,
bch.manager_id,
count(ist.issued_id) as number_of_books_issued,
count(rst.return_id) as number_of_books_returned,
sum(bk.rental_price) as rental_revenue
from branch as bch
join 
employees as emp
on
bch.branch_id=emp.branch_id
join
issued_status as ist
on
ist.issued_emp_id=emp.emp_id
left join
return_status as rst
on
rst.issued_id=ist.issued_id
join
books as bk
on
bk.isbn=ist.issued_book_isbn
group by
bch.branch_id,bch.manager_id

---step4:create table by ctas
CREATE TABLE branch_report (
    branch_id varchar (50),
    manager_id varchar (50),
    number_of_books_issued varchar(50),
    number_of_books_returned varchar(50),
    rental_revenue float
);

INSERT INTO branch_report (branch_id, manager_id, number_of_books_issued, number_of_books_returned, rental_revenue)
SELECT 
    bch.branch_id,
    bch.manager_id,
    COUNT(ist.issued_id) AS number_of_books_issued,
    COUNT(rst.return_id) AS number_of_books_returned,
    SUM(bk.rental_price) AS rental_revenue
FROM 
    branch AS bch
JOIN 
    employees AS emp
    ON bch.branch_id = emp.branch_id
JOIN 
    issued_status AS ist
    ON ist.issued_emp_id = emp.emp_id
LEFT JOIN 
    return_status AS rst
    ON rst.issued_id = ist.issued_id
JOIN 
    books AS bk
    ON bk.isbn = ist.issued_book_isbn
GROUP BY 
    bch.branch_id, bch.manager_id;

---now we can use the new table bracnh_report
select * from branch_report

/*
-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing 
members who have issued at least one book in the last 2 months.
*/

--new table--->member who have issued at least one book in the last 2 months

select * from  books
select * from  branch
select * from  employees
select * from  issued_status--->iss mem id,iss id,issu date,iss book isbn
select * from  return_status
select * from  members--->memberid,mem name
/*
UPDATE issued_status
SET issued_date = GETDATE()
WHERE issued_id = 'IS106';
*/
---step 1:join member and issued_status

select  * from members as mem
join 

issued_status as ist
on
mem.member_id=ist.issued_member_id

---step2

select 
distinct mem.member_id,
mem.member_name,
mem.member_address,
mem.reg_date 


from issued_status as ist
join
members as mem
on
ist.issued_member_id=mem.member_id
WHERE ist.issued_date >= DATEADD(MONTH, -2, GETDATE());
------------------------------------
--above and below are same only



select * from
members 
where
member_id IN(
           select
           distinct issued_member_id
 
           from issued_status
           where
           issued_date>=DATEADD(MONTH, -2, GETDATE())
		   )
		   
---step3:ctas
create table Active_members(
           member_id varchar(50),
		   member_name varchar(50),
		   member_address varchar(50),
		   reg_date datetime2(7)
		   
)
insert into Active_members(member_id,member_name,member_address,reg_date)
select * from
members 
where
member_id IN(
           select
           distinct issued_member_id
 
           from issued_status
           where
           issued_date>=DATEADD(MONTH, -2, GETDATE())
		   )
---chk the table Active_member
select * from Active_members
----------------------------------------------------------------------
-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues.
---Display the employee name, number of books processed, and their branch.
select * from employees--emp name,branch id
select * from issued_status--issued_id
select * from books
select * from branch
--Display;emp name,no of books processed,their branch


SELECT 
    e.emp_name,
    b.branch_id,
    b.manager_id,
	b.branch_address,
	b.contact_no,
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e
    ON e.emp_id = ist.issued_emp_id
JOIN branch AS b
    ON e.branch_id = b.branch_id
GROUP BY 
    e.emp_name, 
    b.branch_id, 
    b.manager_id,
	b.branch_address,
	b.contact_no
---------------------------
--no of books issuedby more than 2 times and the book name
select 
issued_book_name ,
count(issued_id)  as issued_numbers
from
issued_status
group by issued_book_name 
having
count(issued_id)>=2
-------------------------------------

/*
Task 18: Stored Procedure Objective: 

Create a stored procedure to manage the status of books in a library system. 

Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 

The procedure should function as follows: 

The stored procedure should take the book_id as an input parameter. 

The procedure should first check if the book is available (status = 'yes'). 

If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 

If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.
*/
--we need books and issued_status table
select * from books
select * from issued_status

---create procedure 
CREATE PROCEDURE issued_book_details
    @issued_id VARCHAR(50),
    @issued_member_id VARCHAR(50),
    @issued_book_name VARCHAR(100),
    @issued_date DATETIME2(7),
    @issued_book_isbn VARCHAR(50),
    @issued_emp_id VARCHAR(50)
AS
BEGIN
    DECLARE @v_status VARCHAR(50);

    -- Get the status of the book
    SELECT @v_status = status
    FROM books
    WHERE isbn = @issued_book_isbn;

    -- Check if the book is available
    IF @v_status = 'yes'
    BEGIN
        -- Insert into issued_status
        INSERT INTO issued_status (issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, issued_emp_id)
        VALUES (@issued_id, @issued_member_id, @issued_book_name, @issued_date, @issued_book_isbn, @issued_emp_id);
        
        -- Update book status
        UPDATE books
        SET status = 'no'
        WHERE isbn = @issued_book_isbn;

        -- Print success message
        PRINT 'Thank you for requesting the book with ISBN: ' + @issued_book_isbn;
    END
    ELSE
    BEGIN
        -- Print unavailable message
        PRINT 'Sorry to inform you that the book with ISBN: ' + @issued_book_isbn + ' is currently not available.';
    END
END;

---to execute


--before that let check book available or not
--for status -->yes
select * from books
--978-0-06-112008-4  --->yes
---978-0-7432-7357-1  --->no  1491: New Revelations of the Americas Before Columbus


--check format of issued status table
select * from issued_status
-->issuedid-->IS140,memberid-->C111,bookname-->To Kill a Mockingbird,isbn-->978-0-06-112008-4,empid-->E101


-->status-->yes
-- Use current date and time for @issued_date
EXEC issued_book_details 
    @issued_id = 'IS140', 
    @issued_member_id = 'C111', 
    @issued_book_name = 'To Kill a Mockingbird', 
    @issued_date = '2024-09-23',  -- This is outside of the EXEC statement
    @issued_book_isbn = '978-0-06-112008-4', 
    @issued_emp_id = 'E101';

---check again
	select * from books where 
	isbn='978-0-06-112008-4'

---for status no
EXEC issued_book_details 
    @issued_id = 'IS141', 
    @issued_member_id = 'C111', 
    @issued_book_name = '1491: New Revelations of the Americas Before Columbus', 
    @issued_date = '2024-09-23',  -- This is outside of the EXEC statement
    @issued_book_isbn = '978-0-7432-7357-1', 
    @issued_emp_id = 'E101';