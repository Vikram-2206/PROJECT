use film_rental;
-- 1. What is the total revenue generated from all rentals in the database? 
select sum(amount) as total_revenue 
from rental 
join payment p using(rental_id);

select sum(amount) as total_revenue from payment;


-- 2. How many rentals were made in each month_name? 
 select monthname(rental_date) as Month_Name,count(*)as No_of_Rentals 
 from rental 
 group by 1 ; 
 
-- 3. What is the rental rate of the film with the longest title in the database? 
select distinct title,character_length(title) as Length_of_title,rental_rate 
from film 
where character_length(title)=(select max(character_length(title)) from film);

select title,rental_rate from film order by length(title) desc limit 1;

-- 4. What is the average rental rate for films that were taken from the last 30 days from the date("2005-05-05 22:04:30")?
-- sir answer
describe rental;
select avg(rental_rate) from film where film_id in(
select film_id from inventory where inventory_id in (
select inventory_id from rental where datediff("2005-05-05 22:04:30",rental_date)<=30));



-- 5. What is the most popular category of films in terms of the number of rentals? 
select distinct fc.category_id,count(*) as no_of_rentals 
from film f 
join inventory i using(film_id) 
join rental r using (inventory_id)
join film_category fc using(film_id)
group by 1
order by 2 desc
limit 1;


select c.name,count(rental_id) as no_of_rentals from rental join inventory using(inventory_id)
join film using(film_id) join film_category using(film_id)
join category c using(category_id) group by 1 order by 2 desc limit 1;

-- 6. Find the longest movie duration from the list of films that have not been rented by any customer. 
select title, max(f.length) as max_length
from inventory i left join rental using(inventory_id)
left join  film f using(film_id) where customer_id is null group by title;


select * from film where film_id in (select film_id from inventory
where inventory_id not in (select inventory_id from rental))order by length desc limit 1;

select max(length) from film left join inventory using (film_id) left join rental
using(inventory_id) where rental_id is null;

-- 7. What is the average rental rate for films, broken down by category? 
select distinct name,AVG(rental_rate)  
from film f 
join inventory i using(film_id) 
join rental r using (inventory_id)
join film_category fc using(film_id)
join category using(category_id)
group by 1;


select name,avg(rental_rate) from film join film_category using(film_id)
join category using(category_id) group by 1;

-- 8. What is the total revenue generated from rentals for each actor in the database? 
with amount as (select distinct concat_ws(' ',first_name,last_name) as Actor_name,sum(p.amount) as total_amount 
from film f 
join inventory i using(film_id) 
join rental r using (inventory_id)
join film_actor fa using(film_id)
join actor a using(actor_id)
join payment p using(rental_id)
group by 1) 
select sum(total_amount) from amount;


select actor.*, sum(amount) as total_revenue from actor 
left join film_actor using(actor_id)
left join film using(film_id) left join inventory using(film_id)
left join rental using(inventory_id) left join payment using(rental_id) group by 1;

-- 9. Show all the actresses who worked in a film having a "Wrestler" in the description. 
select distinct concat_ws(' ',first_name,last_name) as name
from film f 
join film_actor fa using(film_id)
join actor using(actor_id)
where description like'%wrestler%';


select distinct actor.* from actor join film_actor using(actor_id)
join film using(film_id) where description like '%wrestler%';

-- 10. Which customers have rented the same film more than once? 
select c.customer_id,concat_ws(' ',first_name,last_name) as Name,f.film_id,f.title,count(*) as RentalCount
from rental r
join customer c USING(customer_id)
join inventory i using(inventory_id)
join film f using(film_id)
group by 1, 3, 4
having RentalCount > 1
order by  RentalCount desc;


with temp as
(select f.film_id,customer_id,count(*) 
from rental join inventory using(inventory_id) join film f using(film_id)
 group by 1,2 having count(*)>1)
select * from customer where customer_id in (select customer_id from temp);


-- 11. How many films in the comedy category have a rental rate higher than the average rental rate? 
select 'Comedy' as category,count(*) as no_of_films from film f 
join inventory i using(film_id) 
join rental r using (inventory_id)
join film_category fc using (film_id)
join category c using(category_id)
where c.name='Comedy' and rental_rate>(select Avg(rental_rate) from film f join inventory i using(film_id) join rental r using (inventory_id)join film_category fc using (film_id)join category c using(category_id)
where c.name='Comedy');


-- sir answer
select count(*) from film join film_category using(film_id)
join category using(category_id) where name='comedy'
and rental_rate>(select avg(rental_rate) from film);


-- 12. Which films have been rented the most by customers living in each city? 


with temp as 

(select city,title,count(*),rank() over(partition by city order by count(*) desc) as city_rank
from film join inventory using(film_id) join rental using(inventory_id) join
customer using(customer_id) join address using(address_id) join city using(city_id)
group by 1,2)
select city,title from temp where city_rank=1;

-- 13. What is the total amount spent by customers whose rental payments exceed $200? 
with table1 as
(select distinct customer_id,sum(amount)as amount 
from customer c 
join payment p using(customer_id)
group by 1
having sum(amount)>200) 
select sum(amount) as Total_amount from table1;

-- 14. Display the fields which are having foreign key constraints related to the "rental" table. [Hint: using Information_schema] 
select  *
from information_schema.key_column_usage
where table_name= 'rental' and referenced_table_name is not null;


-- 15. Create a View for the total revenue generated by each staff member, broken down by store city with the country name. 

create view  staff_total_revenue as
(select concat_ws('_',first_name,last_name) as staff_name,
sum(amount) as total_revenue,city,country
from staff st join address a using(address_id) join
city c using(city_id) join country co using(country_id) join
payment p using(staff_id)
group by 1,3,4);

select * from staff_total_revenue;

-- 16. Create a view based on rental information consisting of visiting_day, customer_name, the title of the film, no_of_rental_days, the amount paid by the customer along with the percentage of customer spending. 

create view Rental_information as
(select rental_date as visiting_date,
concat_ws('_',first_name,last_name) as customer_name,
title as film_title,datediff(return_date,rental_date) as no_of_days,
amount as amount_paid,(amount/sum(amount))*100 as customer_amount_percentage
from customer c join rental r using(customer_id) join
payment p using(rental_id) join inventory using(inventory_id) join
film using(film_id) group by 1,2,3,4,5);

select * from Rental_information;

-- 17. Display the customers who paid 50% of their total rental costs within one day. 

with temp1 as
(select customer_id,date(payment_date),sum(amount) as day_payment
 from payment group by 1,2),
 
 temp2 as
 (select *,sum(day_payment) over(partition by customer_id) as total_payment
 from temp1),
 
 temp3 as
 (select * from temp2 where day_payment/total_payment>0.5)
 
 select * from customer where customer_id in (select customer_id from temp3);



