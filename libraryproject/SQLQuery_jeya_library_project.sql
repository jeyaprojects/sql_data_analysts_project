create database library_project

---after creating database,import the table---
---next,we need to create relationship with each table;this can be done by ERD
---An ERD (Entity-Relationship Diagram) visually represents the structure of a database, showing the tables, columns, and relationships between them
---expand database-->database diagram-->right click-->new database diagram-->include all table by adding
---setting foreign key 
---foreign key should be primary key some table
---to see the primary key manuall-->right click on table-->design-->first underline data is primary key

--to see the primary key

select * from
INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE ='PRIMARY KEY' and TABLE_NAME='books'

--set primary key
ALTER TABLE books
ADD PRIMARY KEY (isbn)

ALTER TABLE branch
ADD PRIMARY KEY (branch_id)

ALTER TABLE employees
ADD PRIMARY KEY (emp_id)

ALTER TABLE issued_status
ADD PRIMARY KEY (issued_id)

ALTER TABLE members
ADD PRIMARY KEY (member_id)

ALTER TABLE return_status
ADD PRIMARY KEY (return_id)

select * from
INFORMATION_SCHEMA.TABLE_CONSTRAINTS
where CONSTRAINT_TYPE ='PRIMARY KEY' and TABLE_NAME='books'

---set foreign key
ALTER TABLE issued_status
ADD CONSTRAINT fk_members FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books FOREIGN KEY (issued_book_isbn)
REFERENCES books (isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees FOREIGN KEY (issued_emp_id)
REFERENCES employees (emp_id);


ALTER TABLE employees
ADD CONSTRAINT fk_branch FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);
---below code raises error--
ALTER TABLE return_status
ADD CONSTRAINT fk_return_status FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);

select top 5 issued_id from return_status
select top 5 issued_id from issued_status
---need to identify the issued_id values in the return_status table that do not have a corresponding match in the issued_status table.
SELECT issued_id 
FROM return_status
WHERE issued_id NOT IN (SELECT issued_id FROM issued_status);

---delete the value which produce issue
DELETE FROM return_status
WHERE issued_id NOT IN (SELECT issued_id FROM issued_status);
---now we do foreign key setting
ALTER TABLE return_status
ADD CONSTRAINT fk_return_status FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);


--now check the diagram for relationship connection
