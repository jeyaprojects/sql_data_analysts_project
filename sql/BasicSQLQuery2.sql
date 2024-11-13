
---Create database
create Database SampleDatabase

---to list all DB 
SELECT name 
FROM sys.databases;






---This stored procedure also lists all databases in SQL Server.
EXEC sp_databases;

---drop DB
drop database SampleDatabase


create Database SampleDatabase


---Create tables in student database

create table Student_details
(
student_ID int,
student_name nvarchar(50),
student_gender nvarchar(15),
student_DOB date)


insert into Student_details (student_ID,student_name,student_gender,student_DOB)
values(001,'Meena','Female','1992-07-23'),
(002,'Tharun','Male','2001-03-21'),
(003,'Niranjana','Female','2007-09-25'),
(004,'Manoj','Male','1985-03-03'),
(005,'Kameela','Female','1999-09-12'),
(006,'Lokesh','Male','1992-11-21'),
(007,'Priya','Female','1999-10-25')

select * from Student_details

/*
Create Table Using Another Table
A copy of an existing table can also be created using CREATE TABLE.

The new table gets the same column definitions. All columns or specific columns can be selected.

If you create a new table using an existing table, the new table will be filled with the existing values from the old table.

Syntax
CREATE TABLE new_table_name AS
    SELECT column1, column2,...
    FROM existing_table_name
    WHERE ....;---work in mysql
*/
--for sql
select * into copyofstudentdetails
from Student_details

select * from copyofstudentdetails

---drop the copytable
drop table copyofstudentdetails
select * from copyofstudentdetails


--Truncate
--The TRUNCATE TABLE statement is used to delete the data inside a table, but not the table itself.

select *  into copystudent
from Student_details

select * from Student_details
select * from copystudent

--delete only data in copystudent
Truncate table copystudent

select * from copystudent


--Alter table
/*
The ALTER TABLE statement is used to add, delete, or modify columns in an existing table.

The ALTER TABLE statement is also used to add and drop various constraints on an existing table.
*/

--ADD column--alter
select * from Student_details

alter table Student_details 
add Student_address nvarchar(100),Student_email nvarchar(100)

select * from Student_details

---drop the column using alter

Alter table Student_details
drop column Student_email

select * from Student_details


---rename the column using alter

EXEC sp_rename 'Student_details.Student_address',  'Student_contact', 'COLUMN';


--to chk
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Student_details';


--to change the datatype of column
select * from Student_details

alter table Student_details
alter
COLUMN Student_contact int

alter table Student_details
alter
COLUMN Student_contact nvarchar(50)


---constraints
/*
Constraints can be specified when the table is created with the CREATE TABLE statement,
or after the table is created with the ALTER TABLE statement.
CREATE TABLE table_name (
    column1 datatype constraint,
    column2 datatype constraint,
    column3 datatype constraint,
    ....
);
SQL constraints are used to specify rules for the data in a table.

Constraints are used to limit the type of data that can go into a table. This ensures the accuracy and reliability of the data in the table. If there is any violation between the constraint and the data action, the action is aborted.

Constraints can be column level or table level. Column level constraints apply to a column, and table level constraints apply to the whole table.

The following constraints are commonly used in SQL:

NOT NULL - Ensures that a column cannot have a NULL value
UNIQUE - Ensures that all values in a column are different
PRIMARY KEY - A combination of a NOT NULL and UNIQUE. Uniquely identifies each row in a table
FOREIGN KEY - Prevents actions that would destroy links between tables
CHECK - Ensures that the values in a column satisfies a specific condition
DEFAULT - Sets a default value for a column if no value is specified
CREATE INDEX - Used to create and retrieve data from the database very quickly


*/

---Sql not null constraints
--The NOT NULL constraint enforces a column to NOT accept NULL values.

--create new table with not null

create table Student_ID (
Student_ID int not null,
Student_regno int not null)

select * from Student_ID

---to add constraints after already created tables
select * from Student_details

Alter table Student_details
alter column student_ID int not null

select * from Student_details

--unquie
/*
The UNIQUE constraint ensures that all values in a column are different.

Both the UNIQUE and PRIMARY KEY constraints provide a guarantee for uniqueness for a column or set of columns.

A PRIMARY KEY constraint automatically has a UNIQUE constraint.

However, you can have many UNIQUE constraints per table, but only one PRIMARY KEY constraint per table
*/



select * from student_ID

drop table Student_ID

create table Student_ID (
student_ID int not null unique,
student_regno int not null unique)

select * from student_ID

--for already created table --unique constraints
select * from Student_details

alter table Student_details
add unique (Student_ID)



INSERT INTO Student_details (student_ID, student_name, student_gender, student_DOB)
VALUES (009, 'Madhavi', 'Female', '2011-09-21');

select * from Student_details


alter table Student_details
add unique (student_name)

---to drop unique constraints



--get contraint name
SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME = 'Student_details' AND CONSTRAINT_TYPE = 'UNIQUE';
--give constrain name  to drop
ALTER TABLE Student_details
DROP CONSTRAINT UQ__Student___C5B4DA788ABB67BA;

---primary key
/*The PRIMARY KEY constraint uniquely identifies each record in a table.

Primary keys must contain UNIQUE values, and cannot contain NULL values.

A table can have only ONE primary key; and in the table, this primary key can consist of single or multiple columns (fields).*/

--create table and data with primary key

create table person(
ID int not null primary key,
First_Name nvarchar(50) Not null,
Last_Name nvarchar(50),
Age int not null
)

select * from person

insert into person values(001,'Mahesh','banu',23)

insert into person values(002,'Meena','Kumar',34),
(003,'Neha','John',23),
(004,'Hema','Ravi',21)

/*
To allow naming of a PRIMARY KEY constraint, and for defining a PRIMARY KEY constraint on multiple columns, use the following SQL syntax:
*/

create table people
(
ID int not null,
First_name nvarchar(50) not null,
Last_name nvarchar(50) not null,
Age int,
CONSTRAINT pk_people primary key(ID,First_name)
)

select * from people

insert into people values
(100,'Jency','Corian',24),
(102,'Deena','Selvam',34)


/*
Note: In the example above there is only ONE PRIMARY KEY (PK_Person). However, the VALUE of the primary key is made up of TWO COLUMNS (ID + LastName).


*/

--alter to add  primary key
---Alter table name add primary key(column name)
Alter table Student_details
add primary key(student_ID)

--to alter add primary key conatrain for multiple column

Alter table Student_ID
add constraint pk_student_ID primary key(student_ID,student_regno)

--to drop primary key constraint
alter table tablename
drop constraint constrain_name

---Foreign key
/*
The FOREIGN KEY constraint is used to prevent actions that would destroy links between tables.

A FOREIGN KEY is a field (or collection of fields) in one table, that refers to the PRIMARY KEY in another table.

The table with the foreign key is called the child table, and the table with the primary key is called the referenced or parent table
*/

create table product(
product_ID int not null primary key,
product_name nvarchar(50) not null,
product_category nvarchar(50) not null
)


create table orders
(
order_ID int not null primary key,
order_date date,
product_ID int foreign key references product(product_ID)
)




--check
/*The CHECK constraint is used to limit the value range that can be placed in a column.

If you define a CHECK constraint on a column it will allow only certain values for this column.

If you define a CHECK constraint on a table it can limit the values in certain columns based on values in other columns in the row.


*/


create table Bags(
bag_ID int not null primary key,
bag_category nvarchar(50) not null,
bag_type nvarchar(50) check (bag_type='leather'),
bag_shape nvarchar(50)
)

insert into Bags
values
(001,'US','leather','round'

)

select * from Bags
--if we insert type other than leather is raise error
insert into Bags
values
(002,'US','leather','round'

)

---check for multiple column

create table match_details(
match_ID int not null primary key,
match_team_name nvarchar(50) not null,
match_category nvarchar(50),
match_city nvarchar(50),
constraint check_match_details check(match_ID>0 and match_category='under 16'))

--check on alter table
alter table match_details
add check(match_city  in('chennai','delhi','mumbai'))

--drop check constraint
alter table match_details
drop constraint check_match_details


--default:
/*

The DEFAULT constraint is used to set a default value for a column.

The default value will be added to all new records, if no other value is specified.
The DEFAULT constraint can also be used to insert system values, by using functions like GETDATE():

*/

create table cookies
(
cookies_ID int not null primary key,
cookies_name nvarchar(50) default('Chocolate'),
cookiesorderdate date default getdate()
)

insert into cookies (cookies_ID)values
(100),(102)

select * from cookies

--alter default

alter table cookies
add cookies_category nvarchar(50) default('special')

--already exiting table this shows null by defalut

select * from cookies

--to change to ''special we need to update
update  cookies
set cookies_category='special'
where cookies_category is null

select * from cookies

--to drop deflault
SELECT dc.name AS constraint_name, 
       c.name AS column_name
FROM sys.default_constraints AS dc
JOIN sys.columns AS c
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('cookies')
  AND c.name = 'cookies_category';

---DF__cookies__cookies__71D1E811


ALTER TABLE cookies
DROP CONSTRAINT DF__cookies__cookies__71D1E811;

--add defult as alter
alter table cookies
add constraint default_category
default 'speical' for cookies_category


select * from cookies
---to drop

--to drop deflault
SELECT dc.name AS constraint_name, 
       c.name AS column_name
FROM sys.default_constraints AS dc
JOIN sys.columns AS c
    ON dc.parent_object_id = c.object_id
    AND dc.parent_column_id = c.column_id
WHERE dc.parent_object_id = OBJECT_ID('cookies')
  AND c.name = 'cookies_category';
--cookies_category default_category
ALTER TABLE cookies
DROP CONSTRAINT default_category;


--index
/*
The CREATE INDEX statement is used to create indexes in tables.

Indexes are used to retrieve data from the database more quickly than otherwise. The users cannot see the indexes, they are just used to speed up searches/queries.

Note: Updating a table with indexes takes more time than updating a table without (because the indexes also need an update). So, only create indexes on columns that will be frequently searched against.
*/
--for one index
---Creates an index on a table. Duplicate values are allowed:
--Creates a unique index on a table. Duplicate values are not allowed:
create index index_student_name
on  Student_details(student_name)

--combination of columns --index

create index index_first_last_name
on people(First_name,Last_name)

---drop index
drop index people.index_first_last_name

drop index Student_details.index_student_name

---Auto increment
/*
Auto-increment allows a unique number to be generated automatically when a new record is inserted into a table.

Often this is the primary key field that we would like to be created automatically every time a new record is inserted.
The MS SQL Server uses the IDENTITY keyword to perform an auto-increment feature.

In the example above, the starting value for IDENTITY is 1, and it will increment by 1 for each new record.

Tip: To specify that the "Personid" column should start at value 10 and increment by 5, change it to IDENTITY(10,5).

To insert a new record into the "Persons" table, we will NOT have to specify a value for the "Personid" column (a unique value will be added automatically):

*/

create table pets
(pet_ID int identity(1,1) primary key,
pet_detailer_name nvarchar (50),
pet_type nvarchar(50))

insert into pets
values('max_pets','bird'),
('jolly_pets','fish')

select * from pets


--Dates
/*

The most difficult part when working with dates is to be sure that the format of the date you are trying to insert, matches the format of the date column in the database.

As long as your data contains only the date portion, your queries will work as expected. However, if a time portion is involved, it gets more complicated.
SQL Server comes with the following data types for storing a date or a date/time value in the database:

DATE - format YYYY-MM-DD
DATETIME - format: YYYY-MM-DD HH:MI:SS
SMALLDATETIME - format: YYYY-MM-DD HH:MI:SS
TIMESTAMP - format: a unique number


*/
select * from orders
select * from product

insert into product values(100,'mia','wood'),
(200,'poopoo','leather'),
(300,'meowmeow','plastic')

insert into orders
values (001,'2021-12-31',100),
(002,'2002-05-21',200)

select * from orders where order_date='2021-12-31'

---Note: Two dates can easily be compared if there is no time component involved!

select * from orders where order_date='2021-12-31 23:23:23'

---view
/*
In SQL, a view is a virtual table based on the result-set of an SQL statement.

A view contains rows and columns, just like a real table. The fields in a view are fields from one or more real tables in the database.

You can add SQL statements and functions to a view and present the data as if the data were coming from one single table.

A view is created with the CREATE VIEW statement.



*/

select * from Student_details

--view
create view [student name gender] AS
select student_name,student_gender
from Student_details
where student_gender ='Male'


---to get view
select * from [student name gender]
select * from Student_details


---view with conditon 
select * from people

insert into people
values(103,'Banu','Corian',45),
(104,'Meena','Corian',35),
(105,'Meher','Uisan',55)

create view [people name avg age]AS
select First_name,Last_name,Age
from people
where age >(select avg(age)from people)

select * from [people name avg age]
select * from people


--drop view
drop view [student name gender]
--the following wont work
select * from [student name gender]




