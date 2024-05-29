create database zomato;
use zomato;


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

#1 
select userid, sum(price)as total_price from
sales a join product b on a.product_id=b.product_id
group by userid;

#2
select userid, count(created_date)as number_Of_days_visited  from
sales 
group by userid;

#3
select userid, product_name,created_date from
(select a.userid, b.product_name,a.created_date, 
dense_rank()  over(partition by a.userid order by a.created_date)as rd
from sales a join product b on  a.product_id=b.product_id)as ad where rd=1;

#4
select  product_id ,count(created_date) as most_pusrchased from sales group by product_id;

select * from(select userid,product_id ,count(created_date) as most_purchased_item from sales 
group by userid,product_id)as tabl_ where product_id=2;

#5
select * from
(select userid,product_id,count(product_id) as most_ordered,
dense_rank() over (partition by userid order by count(product_id) desc)as rd
from sales group by userid,product_id)as ree where rd=1 ;



#6
select * from
(select a.userid,b.created_date , a.gold_signup_date,b.product_id,rank() over(partition by userid order by created_date)as rk
from goldusers_signup a
join sales b on a.userid=b.userid
 where b.created_date > a.gold_signup_date  )as rnk where rk=1;
 
 
#7
select * from
(select a.userid,b.created_date , a.gold_signup_date,b.product_id,
rank() over(partition by userid order by created_date desc )as rk
from goldusers_signup a
join sales b on a.userid=b.userid
 where b.created_date < a.gold_signup_date  )as rnk where rk=1;
 
 #8
 
select a.userid,count(b.product_id) as total_orders,sum(price) as total_amount_spent
from  goldusers_signup a
join sales b on a.userid=b.userid join
product c on c.product_id=b.product_id  where b.created_date<a.gold_signup_date
group by a.userid ;
#9

select userid,sum(total_points) as total_points from
(select *,round((amt)/(points),0) as total_points  from
(select o.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)as amt from
(select a.*,b.price 
from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)o)g)t group by userid;


select product_id,sum(total_points) as total_points from
(select *,round((amt)/(points),0) as total_points  from
(select o.*,case when product_id=1 then 5 when product_id=2 then 2 when product_id=3 then 5 else 0 end as points from
(select c.userid,c.product_id,sum(price)as amt from
(select a.*,b.price 
from sales a inner join product b on a.product_id=b.product_id) c
group by userid,product_id)o)g)t group by product_id limit 1;



#9	
select *,round((b.price/2),0)as total_zomato_points from
(select a.userid,b.created_date ,c.price, a.gold_signup_date,b.product_id,rank() over(partition by userid order by created_date)as rk
from goldusers_signup a
join sales b on a.userid=b.userid 
join product c on b.product_id=c.product_id
 where b.created_date>=gold_signup_date and
 b.created_date <= date_add(gold_signup_date,interval 1 year))b;
 
 
 #10

select a.userid, sum(b.price)as total_price ,
rank() over( order by sum(b.price) desc)as rnk
from sales a join product b
on a.product_id=b.product_id group by a.userid;


#11
select a.userid,a.created_date,c.gold_signup_date from sales a left join  product b 
on a.product_id=b.product_id left join goldusers_signup c on c.userid=a.userid order by created_date;

select *,case when gold_signup_date is null then 'NA' else rank() 
over(partition by userid order by  created_date desc) end as rnk_ from
(select a.userid,a.created_date, b.gold_signup_date 
from sales a left join goldusers_signup b on 
a.userid=b.userid and created_date >= gold_signup_date)b;