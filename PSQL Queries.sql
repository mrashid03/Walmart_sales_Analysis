select * from walmart;

drop table walmart;
--
select count(*) from walmart;

select 
	payment_method,
	count(*)
from walmart
group by payment_method;

select count(distinct Branch)
from walmart;

select min(quantity) from walmart;

-- Business Problems
--Q.1 Find different payment methods and number of transactions, number of qty sold


select 
	payment_method,
	count(*) as no_payments,
	sum(quantity) as no_qty_sold
from walmart
group by payment_method;

--Q.2 Identify the Highest-Rated Category in Each Branch, displaying the branch, category and avg Rating

select *
from (
select 
	branch,
	category,
	avg(rating) as avg_rating,
	rank() over(partition by branch order by avg(rating) desc) as rank
from walmart
group by 1,2) sub
where rank = 1;

--Q3. Identify the busiest day for each branch based on the number of transactions.

select *
from
(select 
	branch,
	to_char(to_date(date, 'DD/MM/YY'), 'Day') as day_name,
	count(*) as no_transactions,
	rank() over(partition by branch order by count(*) desc) as rank
from walmart
group by 1, 2)
where rank = 1;

--Q4. Calculate Total Quantity Sold by Payment Method.
-- List payment_method and total quantity.

select 
	payment_method,
	sum(quantity) as no_qty_sold
from walmart
group by payment_method;

--Q5. Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.

select 
	city,
	category,
	min(rating) as min_rating,
	max(rating) as max_rating,
	avg(rating) as avg_rating
from walmart
group by 1, 2;

--Q6. Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.

select 
	category,
	sum(total) as total_revenue,
	sum(total * profit_margin) as profit
from walmart
group by 1;

-- Q.7
-- Determine the most common payment method for each Branch. 
-- Display Branch and the preferred_payment_method.

with cte as
(select
	branch, 
	payment_method,
	count(*) as total_trans,
	rank() over(partition by branch order by count(*) desc) as rank
from walmart
group by 1, 2)
select *
from cte
where rank = 1;

-- Q.8
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices

select
	branch,
	case 
		when extract (hour from(time::time)) < 12 then 'Morning'
		when extract (hour from(time::time)) between 12 and 17 then 'Afternoon'
		else 'Evening'
	end day_time,
	count(*)
from walmart
group by 1, 2
order by 1, 3 desc;
