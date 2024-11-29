/*
Objective 1
Identify when vehicles are likely to be stolen
Your first objective is to explore the vehicle and date fields in the stolen_vehicles table to identify when vehicles tend to be stolen
Task:
--->Find the number of vehicles stolen each year
---->Find the number of vehicles stolen each month
---->Find the number of vehicles stolen each day of the week
---->Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
----->Create a bar chart that shows the number of vehicles stolen on each day of the week
*/

---Task:
--->Find the number of vehicles stolen each year
select * from locations
select * from make_details
select * from stolen_vehicles


--stolen_vechicle has details for each year
select year(date_stolen), count(vehicle_id) as noofvehicles  from stolen_vehicles 
group by year(date_stolen)



---->Find the number of vehicles stolen each month
SELECT 
    MONTH(date_stolen), COUNT(vehicle_id) AS noofvehicles
FROM
    stolen_vehicles
GROUP BY MONTH(date_stolen)


---lets order by year,month
SELECT 
    year(date_stolen),MONTH(date_stolen) ,COUNT(vehicle_id) AS noofvehicles
FROM
    stolen_vehicles
GROUP BY year(date_stolen),MONTH(date_stolen)
order by year(date_stolen),MONTH(date_stolen)
---here result shows we have records for  3 month of 2021 ,and jan to april of 2022.And at april 2022 we see no of vehicle is less 

SELECT 
    year(date_stolen),MONTH(date_stolen) ,day(date_stolen),COUNT(vehicle_id) AS noofvehicles
FROM
    stolen_vehicles
 where month(date_stolen)=4   
GROUP BY year(date_stolen),MONTH(date_stolen),day(date_stolen)
order by year(date_stolen),MONTH(date_stolen),day(date_stolen)
---here we see only 6 days working in april 2022
---we see more vehicle stolen between dec to march.because in newzealand summer time is from dec--march--


---->Find the number of vehicles stolen each day of the week
select dayofweek(date_stolen)as daysofweek,count(vehicle_id)
from stolen_vehicles
group by dayofweek(date_stolen)
order by dayofweek(date_stolen)



---->Replace the numeric day of week values with the full name of each day of the week (Sunday, Monday, Tuesday, etc.)
select dayofweek(date_stolen)as daysofweekinnumbers,
     CASE  WHEN dayofweek(date_stolen) =1 then 'Sunday'
        when dayofweek(date_stolen) =2 then 'Monday'
        when dayofweek(date_stolen) =3 then 'Tuesday'
        when dayofweek(date_stolen )=4 then 'Wednesday'
        when dayofweek(date_stolen)=5 then 'Thursday'
        when dayofweek(date_stolen)=6 then 'Friday'
        else 'saturday' end as daysofweeks,
count(vehicle_id)as noofvechile
from
stolen_vehicles
group by dayofweek(date_stolen),daysofweeks
order by dayofweek(date_stolen),daysofweeks


-----Objective 2
---Identify which vehicles are likely to be stolen
---Your second objective is to explore the vehicle type, age, luxury vs standard and color fields in the stolen_vehicles table to identify which vehicles are most likely to be stolen
/*
Task:
---->Find the vehicle types that are most often and least often stolen
---->For each vehicle type, find the average age of the cars that are stolen
---->For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
---->Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen
---->Create a heat map of the table comparing the vehicle types and colors



*/

---->Find the vehicle types that are most often and least often stolen
select vehicle_type,count(vehicle_id)as noofvehicles 
from stolen_vehicles
group by vehicle_type
order by  noofvehicles desc
limit 5

--->most --->Stationwagon-->945

select vehicle_type,count(vehicle_id)as noofvehicles 
from stolen_vehicles
group by vehicle_type
order by  noofvehicles
limit 5
--->least---->Articulated Truck,Special Purpose Vehicle--->1


---->For each vehicle type, find the average age of the cars that are stolen
select vehicle_type, avg(year(date_stolen)-model_year)as Avg_age
from 
stolen_vehicles
group by vehicle_type
order by Avg_age desc
/*
select distinct(vehicle_type)from stolen_vehicles

select vehicle_type ,make_id,(year(date_stolen) - model_year) as ageofbike
from stolen_vehicles
where vehicle_type in (select distinct(vehicle_type)from stolen_vehicles)
group by vehicle_type,make_id


select count(*) from stolen_vehicles
select distinct count(vehicle_type) from stolen_vehicles
select vehicle_type,count(vehicle_type) from stolen_vehicles
group by vehicle_type
select * from stolen_vehicles
select count(*) from stolen_vehicles where vehicle_type='Trailer'
select *  from stolen_vehicles where vehicle_type='Tractor'
select *  from stolen_vehicles where vehicle_type='Cab and Chassis Only'
select *  from stolen_vehicles where vehicle_type='Trailer'

*/

------>For each vehicle type, find the percent of vehicles stolen that are luxury versus standard
select * from stolen_vehicles
select * from make_details


--->lets join these 2 tables first
---step 1:
select vehicle_type,make_type
from stolen_vehicles as sv
left join
make_details as md
on
sv.make_id=md.make_id
group by vehicle_type,make_type

--step 2:to change numeric value to luxury or not data
select vehicle_type, case when make_type ='Luxury' then 1 else 0 end as "luxury or nor"
from stolen_vehicles as sv
left join
make_details as md
on
sv.make_id=md.make_id


---->step 3 : to find percentage we need numerator,denomintor ;numerator-->luxury or not;dinominator-->is car

select vehicle_type, case when make_type ='Luxury' then 1 else 0 end as "luxury or nor",1 as "all_cars"
from stolen_vehicles as sv
left join
make_details as md
on
sv.make_id=md.make_id


---step 4 :we make table as common table expression
with lux_standard as (
select vehicle_type, case when make_type ='Luxury' then 1 else 0 end as "luxury_or_not",1 as "all_cars"
from stolen_vehicles as sv
left join
make_details as md
on
sv.make_id=md.make_id)

select * from lux_standard

---step 5:from this cte as can find  percentage  of vehicle type stolen wrt luxury and not
with lux_standard as (
select vehicle_type, case when make_type ='Luxury' then 1 else 0 end as "luxury_or_not",1 as "all_cars"
from stolen_vehicles as sv
left join
make_details as md
on
sv.make_id=md.make_id)

select vehicle_type,sum(luxury_or_not)/sum(all_cars) * 100 as "percentage"
from lux_standard
group by vehicle_type
order by percentage desc



---->Create a table where the rows represent the top 10 vehicle types, the columns represent the top 7 vehicle colors (plus 1 column for all other colors) and the values are the number of vehicles stolen

--step 1:top 7 colours
select color ,count(vehicle_id)as num_colors
from stolen_vehicles
group by color
order by num_colors desc

/*
top seven colours
Silver	1272
White	934
Black	589
Blue	512
Red	390
Grey	378
Green	224

other colors-->Gold,Brown,Yellow,Orangw,Purple,Cream,Pink
*/

--step 3:we need to create table with rows-->vehicle type,column-->colour
select vehicle_type,
      case when color = "Silver" then 1 else 0  end as Silver,
      case when color = "White" then 1 else 0  end as white,
      case when color = "Black" then 1 else 0  end as Black,
      case when color = "Blue" then 1 else 0  end as Blue,
      case when color = "Red" then 1 else 0  end as Red,
      case when color = "Grey" then 1 else 0  end as Grey,
      case when color ="Green" then 1 else 0 end as Green,      
      case when color in ("Gold","Purple","orange","Pink","Cream","Yellow","Brown") then 1 else 0 end as others
from
stolen_vehicles
group by vehicle_type


---step 4:we need fill the data in table as noofstollen ,we need to sum all the values
select vehicle_type,
      sum(case when color = "Silver" then 1 else 0  end )as Silver,
      sum(case when color = "White" then 1 else 0  end )as white,
      sum(case when color = "Black" then 1 else 0  end )as Black,
      sum(case when color = "Blue" then 1 else 0  end )as Blue,
      sum(case when color = "Red" then 1 else 0  end )as Red,
      sum(case when color = "Grey" then 1 else 0 end )as Grey,
      sum(case when color ="Green" then 1 else 0 end )as Green,      
      sum(case when color in ("Gold","Purple","orange","Pink","Cream","Yellow","Brown") then 1 else 0 end )as others
from
stolen_vehicles
group by vehicle_type

--step 5:top 10 vechicle theft

select vehicle_type,count(vehicle_id)as no_of_vehicle,
      sum(case when color = "Silver" then 1 else 0  end )as Silver,
      sum(case when color = "White" then 1 else 0  end )as white,
      sum(case when color = "Black" then 1 else 0  end )as Black,
      sum(case when color = "Blue" then 1 else 0  end )as Blue,
      sum(case when color = "Red" then 1 else 0  end )as Red,
      sum(case when color = "Grey" then 1 else 0 end )as Grey,
      sum(case when color ="Green" then 1 else 0 end )as Green,      
      sum(case when color in ("Gold","Purple","orange","Pink","Cream","Yellow","Brown") then 1 else 0 end )as others
from
stolen_vehicles
group by vehicle_type
order by no_of_vehicle desc
limit 10


---->Create a heat map of the table comparing the vehicle types and colors
--export the above table reuslt in excel and we do heat map