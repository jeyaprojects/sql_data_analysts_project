show databases
USE  sakila
SELECT * FROM sakila.film f where f.rental_rate<=2.99



#1) All films with PG-13 films with rental rate of 2.99 or lower
select * from film f
where f.rental_rate <= 2.99
and
f.rating='PG-13'



#2) All films that have deleted scenes
select f.title,f.description,f.special_features
from film f
where
f.special_features like '%Deleted Scenes%'
#add title starts with c
and
f.title like 'c%'



#3) All active customers
select 
*
from customer
where
active = 1


#4) Names of customers who rented a movie on 26th July 2005
select r.rental_id,r.rental_date,c.customer_id,concat(c.first_name,' ',c.last_name) cuatomername
from rental r
join customer c on r.customer_id=c.customer_id
where date(r.rental_date)='2005-07-26'





#5) Distinct names of customers who rented a movie on 26th July 2005
select distinct c.customer_id,concat(c.first_name,' ',c.last_name) cuatomername
from rental r
join customer c on r.customer_id=c.customer_id
where date(r.rental_date)='2005-07-26'




#6) How many rentals we do on each day?
select date(rental_date) date,count(*) no_of_rental
from
rental
group by date(rental_date)




#7) All Sci-fi films in our catalogue
select 
c.category_id ,
c.name,
f.title,
f.description
from category c
join
film_category fc
on
c.category_id=fc.category_id
join
film f
on
f.film_id=fc.film_id
where name='Sci-Fi'





#8) Customers and how many movies they rented from us so far?

select 
c.customer_id,concat(c.first_name,' ',c.last_name) customer_name,r.rental_id,count(*) count
from
rental r
join
customer c
on
c.customer_id=r.customer_id
group by
c.customer_id
order by
count(*)desc




#9) Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)
#here we use rental,inventory file table
#analysis
select * from rental#inventoryid,chk rental count less than 1
select * from inventory# invenid,filmid
select * from film#filmid,title

#solution
select r.inventory_id,f.title,count(*) lowrentallessthan2
from  rental r
join
inventory inv
on
inv.inventory_id=r.inventory_id
join
film f
on
f.film_id=inv.film_id

group by r.inventory_id
having count(*)<=1

#we can use as cte common table expression
with low_rental as(
     select r.inventory_id,f.title,count(*) lowrentallessthan2
from  rental r
join
inventory inv
on
inv.inventory_id=r.inventory_id
join
film f
on
f.film_id=inv.film_id

group by r.inventory_id
having count(*)<=1
)
select * from low_rental
 









#10) Which movies are not returned yet?
select 
f.title title,
r.rental_date   not_yet_return
from rental r
join
inventory inv
on r.inventory_id=inv.inventory_id
join film f
on
f.film_id=inv.film_id
where return_date is null 




#H1) How many distinct last names we have in the data?
select
distinct c.last_name 
from 
customer c

#solution
select
count(distinct c.last_name) distinctlastname
from 
customer c


