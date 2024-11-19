
select * from withdraw
select * from depositedata
select * from game_table

---setting primary key
alter table withdraw
add constraint pk_withdraw primary key(User_Id,Datetime)
---
--find duplicates in depositetable
select * from depositedata

select
    User_ID,
	Datetime,
	count(*) As duplicate_count
from 
depositedata
group by USER_ID,Datetime
having 
  count (*)>1



--we see 9 duplicates we need to remove it
with CTE as(
select
    User_ID,
	Datetime,
	ROW_NUMBER() over (partition by User_ID,Datetime order by Amount desc)AS rownum
from 
  depositedata
)
--to delete
delete from CTE where rownum>1

---9 duplicate are delete
---now we can set primary key

alter table depositedata
add constraint pk_depositedata primary key(User_Id,Datetime)


--gamepoint

--gamepoint
SELECT 
    USER_ID,
    COUNT(USER_ID) AS user_count,
    SUM(Games_Played) AS gamecount_total,
	SUM(Games_Played)* 0.2 as  gamepoint
FROM 
    game_table
GROUP BY 
    USER_ID
ORDER BY 
    USER_ID

--select * from game_table where USER_ID=13

-------
--gamepointtable



create table gamepointtable (
User_ID int not null,
gamepoint float
)

insert into gamepointtable(USER_ID,gamepoint)
SELECT 
    USER_ID,
    
    COUNT(*) *0.2 AS gamepoint
FROM 
    game_table
GROUP BY 
    USER_ID
HAVING 
    COUNT(*) > 1
ORDER BY 
    USER_ID;

select * from gamepointtable


---------depositemoneypoint
select * from depositedata

select count (User_Id),sum(Amount) as deppomit from depositedata where User_Id =11

SELECT 
    User_Id,
    COUNT(User_Id) AS deposit_count,
    SUM(Amount) AS deposit_total,
	SUM(Amount)*0.01 as depositepoint
FROM 
    depositedata
GROUP BY 
    User_Id
ORDER BY 
    User_Id;

--select * from depositedata where User_Id=34


---create separete table depositepoint
create table depositepoints
(User_Id  int not null,
 User_count  int not null,
 deposite_total int not null,
 depositepoint  float not null)

 insert into depositepoints(User_Id,User_count,deposite_total,depositepoint)
 SELECT 
    User_Id,
    COUNT(User_Id) AS User_count,
    SUM(Amount) AS deposit_total,
	SUM(Amount)*0.01 as depositepoint
FROM 
    depositedata
GROUP BY 
    User_Id
ORDER BY 
    User_Id;

select * from depositepoints

---
--withdraw
select * from withdraw 

----withdrawpoints
select
    User_Id,
    count(User_Id) as User_Id_count,
	sum(Amount) as total_amounperuser,
	sum(Amount)*0.005 as withdrawpoint
from
withdraw
group by User_Id
order by User_Id

---withdrawmoneypointstable
create table withdrawpoints
(
User_id int not null,
User_id_count int not null,
total_amountperuser int not null,
withdrawpoint float
)

insert into withdrawpoints
(User_id,User_id_count,total_amountperuser,withdrawpoint)
select
   User_Id,
   count(User_Id)as User_id_count,
   sum(Amount) as total_amountperuser,
   sum(Amount)* 0.005 as withdrawpoint
from
  withdraw
group by User_Id
order by User_Id

-----------

--join 3 tables withdraw,deposite,game_table
select * from game_table
select * from depositedata
select * from withdraw
select * from gamepointtable
select * from depositepoints
select * from withdrawpoints

--/*
SELECT
    gt.USER_ID,
    (SELECT COUNT(*) FROM game_table WHERE USER_ID = gt.USER_ID) AS gameuser,
    (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) AS depouser,
    (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID) AS withuser,
	(SELECT SUM(Amount) FROM depositedata WHERE User_Id = gt.USER_ID) AS depoamount,
    (SELECT SUM(Amount) FROM withdraw WHERE User_Id = gt.USER_ID) AS withdrawamount
	
FROM game_table AS gt
GROUP BY gt.USER_ID
ORDER BY gt.USER_ID;

--*/



----
--for cross check
select * from gamepointtable
select * from depositepoints
select * from withdrawpoints
select count(*) from game_table where User_ID=14
select count(*) from depositedata where USER_Id=14

select count(*) from withdraw where User_Id =14


--userid,gameplayed,noof time deposite,no of time withdraw,totaldepositeamount,depointpoint,totalwithdraw,withdrawpoins:

select 
    gt.User_ID,
	(select count(*) from game_table where User_Id=gt.User_Id)As No_of_games_played,
	(select count(*)from depositedata where User_Id=gt.User_ID) As No_of_time_deposited,
	(select count(*)from withdraw where User_Id=gt.User_ID)As No_of_time_withdrawn,
	COALESCE((select sum(Amount) from depositedata where User_Id=gt.User_Id),0) As Total_deposite_Amount,
	COALESCE((select sum(Amount)from withdraw where User_Id =gt.User_Id),0) As Total_withdraw_Amount,
	COALESCE((select count(*)*0.2  from game_table where User_Id=gt.User_Id),0) As gamepoint,
	COALESCE((select sum(Amount)*0.01 from depositedata where User_Id=gt.User_Id),0) As depositepoint,
	COALESCE((select sum(Amount)*0.005 from withdraw where User_Id=gt.User_Id),0) As withdrawpoint
	
from 
game_table As gt
group by gt.User_ID
order by gt.User_ID




---------userid,gameplayed,noof time deposite,no of time withdraw,totaldepositeamount,depointpoint,totalwithdraw,withdrawpoins,depositethanwithdraw,weighage of deposite and withdraw

----weighaage
SELECT
    gt.USER_ID,
    (SELECT COUNT(*) FROM game_table WHERE USER_ID = gt.USER_ID) AS gameuser,
    (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) AS depouser,
    (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID) AS withuser,
    COALESCE((SELECT SUM(Amount) FROM depositedata WHERE User_Id = gt.USER_ID), 0) AS depoamount,
    COALESCE((SELECT SUM(Amount) FROM withdraw WHERE User_Id = gt.USER_ID), 0) AS withdrawamount,
    COALESCE((SELECT COUNT(*) * 0.2 FROM game_table WHERE USER_ID = gt.USER_ID), 0) AS gamepoint,
    COALESCE((SELECT SUM(Amount) * 0.01 FROM depositedata WHERE User_ID = gt.USER_ID), 0) AS depositepoints,
    COALESCE((SELECT SUM(Amount) * 0.005 FROM withdraw WHERE User_ID = gt.USER_ID), 0) AS withdrawpoints,
    (
        (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
        (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
    ) AS depostitethanwithdraw,
	--to find max of depositeWRTwithdraw
	CASE
        WHEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        ) > 0 THEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        )
        ELSE 0
    END AS max_deposit_withdraw,

	---to find weightage point for deposite than withdraw
	(0.001)*(
	CASE
        WHEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        ) > 0 THEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        )
        ELSE 0
    END )AS weightage_point_of_deposit_withdraw

FROM game_table AS gt
GROUP BY gt.USER_ID
ORDER BY gt.USER_ID;

---create separate weightage table

create table weightagepointable 
(
USER_ID int not null,
gamepoint float not null,
depositepoint float not null,
withdrawpoint float not null,
depositethanwithdrawpoint float not null)

insert into weightagepointable(USER_ID,gamepoint,depositepoint,withdrawpoint,depositethanwithdrawpoint)
SELECT
    gt.USER_ID,
    COALESCE((SELECT COUNT(*) * 0.2 FROM game_table WHERE USER_ID = gt.USER_ID), 0) AS gamepoint,
    COALESCE((SELECT SUM(Amount) * 0.01 FROM depositedata WHERE User_ID = gt.USER_ID), 0) AS depositepoints,
    COALESCE((SELECT SUM(Amount) * 0.005 FROM withdraw WHERE User_ID = gt.USER_ID), 0) AS withdrawpoints,
    ---to find weightage point for deposite than withdraw
	(0.001)*(
	CASE
        WHEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        ) > 0 THEN (
            (SELECT COUNT(*) FROM depositedata WHERE User_Id = gt.USER_ID) -
            (SELECT COUNT(*) FROM withdraw WHERE User_Id = gt.USER_ID)
        )
        ELSE 0
    END )AS weightage_point_of_deposit_withdraw

FROM game_table AS gt
GROUP BY gt.USER_ID
ORDER BY gt.USER_ID;

select * from weightagepointable


---calculating loyalty points
--formulaforloyalpoint=(0.01*dep)+(0.005*with)+(0.001*max((dep-wit),0))+(0.2*gameplayed)
SELECT 
    pt.USER_ID,
    (pt.depositepoint + pt.withdrawpoint + pt.depositethanwithdrawpoint + pt.gamepoint) AS loyaltypoint
FROM weightagepointable AS pt 
ORDER BY pt.USER_ID

--top 50 loyalty point
SELECT top(50)
    pt.USER_ID,
    (pt.depositepoint + pt.withdrawpoint + pt.depositethanwithdrawpoint + pt.gamepoint) AS loyaltypoint
FROM weightagepointable AS pt 
ORDER BY loyaltypoint desc



--games played per player
SELECT 
    user_id,
    COUNT(*) AS games_played
FROM game_table
WHERE datetime >= '2022-10-01 00:00:00'
  AND datetime <= '2022-10-31 23:59:59'
GROUP BY user_id
ORDER BY games_played DESC;


/*
SELECT *
FROM game_table
WHERE datetime >= '2022-10-01 00:00:00'
  AND datetime <= '2022-10-31 23:59:59';

SELECT COUNT(*) AS total_games
FROM game_table
WHERE datetime >= '2022-10-01 00:00:00'
  AND datetime <= '2022-10-31 23:59:59';
*/

select * from weightagepointable

SELECT 
    pt.USER_ID,
    (pt.depositepoint + pt.withdrawpoint + pt.depositethanwithdrawpoint + pt.gamepoint) AS loyaltypoint
FROM weightagepointable AS pt 
ORDER BY pt.USER_ID



---create loyalty table
create table loyaltytable(
    USER_ID int not null,
	loyaltypoint float not null)
insert into loyaltytable(USER_ID,loyaltypoint)
SELECT 
    pt.USER_ID,
    (pt.depositepoint + pt.withdrawpoint + pt.depositethanwithdrawpoint + pt.gamepoint) AS loyaltypoint
FROM weightagepointable AS pt 
ORDER BY pt.USER_ID




select * from loyaltytable
select * from weightagepointable
select * from game_table



select * from weightagepointable as weit
join 
loyaltytable as lt
on 
lt.USER_ID=weit.USER_ID

---creating Loyaltypoinfinaltable
create table Loyaltypointfinaltable
( USER_Id int not null,
  gamepoint float not null,
  depositepoint float not  null,
  withdrawpoint float not null,
  depositethanwithdrawpoint float not null,
  loyaltypoint float not null
)

insert into Loyaltypointfinaltable (
  USER_Id,gamepoint,depositepoint,withdrawpoint,depositethanwithdrawpoint,loyaltypoint)

select 
   weit.USER_ID,
   weit.gamepoint,
   weit.depositepoint,
   weit.withdrawpoint,
   weit.depositethanwithdrawpoint,
   lt.loyaltypoint


from weightagepointable as weit
join 
loyaltytable as lt
on 
lt.USER_ID=weit.USER_ID
--------------------------------------
select * from Loyaltypointfinaltable
select * from Loyaltypointfinaltable order by USER_ID
select * from Loyaltypointfinaltable order by loyaltypoint desc
select top 50 * from Loyaltypointfinaltable order by loyaltypoint desc
--

SELECT 
    gt.user_id,
    (select loyaltypoint from Loyaltypointfinaltable where User_ID=gt.User_ID ) as loyaltypoint
FROM game_table as gt
WHERE datetime >= '2022-10-01 00:00:00'
  AND datetime <= '2022-10-31 23:59:59'
GROUP BY user_id
ORDER BY loyaltypoint DESC;
--------------------

