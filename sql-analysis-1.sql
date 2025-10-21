--  Import the dataset and do usual exploratory analysis steps like checking the 
-- structure & characteristics of the dataset: 

-- 1. Data type of all columns in the "customers" table. 

SELECT  * FROM `TARGET_SQL.geolocation` LIMIT 10;

-- 2. Get the time range between which the orders were placed. 

select min(order_purchase_timestamp) as startTime, max(order_purchase_timestamp) as endTime from `TARGET_SQL.orders`;

-- 3. Count the Cities & States of customers who ordered during the given 
-- period. 

select 
  c.customer_city,c.customer_state
  from
  `TARGET_SQL.orders` as o
  join
  `TARGET_SQL.customers` as c
  on o.customer_id=c.customer_id
  where extract(year from o.order_purchase_timestamp)=2018
  and extract(month from o.order_purchase_timestamp) between 1 and 3;


-- 2. In-depth Exploration:
-- 1. Is there a growing trend in the no. of orders placed over the past years?
  select
   extract(month from order_purchase_timestamp)as month,
   count(order_id) as order_num
   from 
   `TARGET_SQL.orders`
   group by extract(month from order_purchase_timestamp)
   order by order_num desc;

   SELECT
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month_number,
  FORMAT_DATE('%b',  (order_purchase_timestamp)) AS month_name,
  COUNT(order_id) AS order_num
FROM 
  `TARGET_SQL.orders`
GROUP BY 
  month_number, month_name
ORDER BY 
  order_num DESC;

-- 2. Can we see some kind of monthly seasonality in terms of the no. of
-- orders being placed?
 
-- month of aug 8 and july 7 (from above solution)


-- 3. During what time of the day, do the Brazilian customers mostly place
-- their orders? (Dawn, Morning, Afternoon or Night)
-- ■ 0-6 hrs : Dawn
-- ■ 7-12 hrs : Mornings
-- ■ 13-18 hrs : Afternoon
-- ■ 19-23 hrs : Night

select 
extract(hour from order_purchase_timestamp) as time,
count(order_id) as order_num
from `TARGET_SQL.orders`
group by extract(hour from order_purchase_timestamp)
order by order_num desc;

-- 3. Evolution of E-commerce orders in the Brazil region:
  -- 1. Get the month on month no. of orders placed in each state.
  select 
  extract(month from order_purchase_timestamp) as month,
  extract (year from order_purchase_timestamp) as year,
  count(*) as num_orders
  from 
  `TARGET_SQL.orders`
  group by year,month
  order by year,month;
 
  -- 2. How are the customers distributed across all the states?

  select 
  customer_state,
  count(  customer_id) as customer_count
  from
  `TARGET_SQL.customers`
  group by customer_state
  order by customer_count desc
  ;


-- 4.Impact on Economy: Analyze the money movement by e-commerce by looking
--   at order prices, freight and others.
--    1. Get the % increase in the cost of orders from year 2017 to 2018
--    (include months between Jan to Aug only).
--     You can use the "payment_value" column in the payments table to get
--     the cost of orders.
with yearly_totals as (
select  
extract (year from o.order_purchase_timestamp) as year,
sum(p.payment_value) as total_payment
from `TARGET_SQL.payments` as p
join `TARGET_SQL.orders` as o
on p.order_id=o.order_id
where EXTRACT(YEAR FROM o.order_purchase_timestamp) in (2018,2017)
and EXTRACT(MONTH FROM o.order_purchase_timestamp) between 1 and 8
group by year
),
yearly_comparisions as (
select year,total_payment,
lead(total_payment,1,0) over (order by year desc) as prev_year_payments
 from
yearly_totals)

SELECT 
  year,
  CASE 
    WHEN prev_year_payments = 0 THEN NULL
    ELSE ROUND((total_payment - prev_year_payments) / prev_year_payments, 2)
  END AS perc_increase
FROM yearly_comparisions;

--    2. Calculate the Total & Average value of order price for each state.
--    3. Calculate the Total & Average value of order freight for each state.
select
c.customer_state,
avg(price) as avg_price,
sum(price) as sum_price,
avg(freight_value) as avg_freight,
sum(freight_value) as sum_freight
from `TARGET_SQL.orders` as o
join `TARGET_SQL.order_items` as oi
on o.order_id=oi.order_id
join `TARGET_SQL.customers` as c
on c.customer_id= o.customer_id
group by c.customer_state
;


--  5. Analysis based on sales, freight and delivery time.
-- 1. Find the no. of days taken to deliver each order from the order’s
-- purchase date as delivery time.
-- Also, calculate the difference (in days) between the estimated & actual
-- delivery date of an order.
-- Do this in a single query.
-- You can calculate the delivery time and the difference between the
-- estimated & actual delivery date using the given formula:
-- ■ time_to_deliver = order_delivered_customer_date -
-- order_purchase_timestamp
-- ■ diff_estimated_delivery = order_delivered_customer_date -
-- order_estimated_delivery_date

select order_id,
date_diff(date(order_delivered_customer_date),date(order_purchase_timestamp),day) as days_to_delivery,
date_diff(date(order_delivered_customer_date),date(order_estimated_delivery_date),day) as diff_estimated
from
`TARGET_SQL.orders`;
-- 2. Find out the top 5 states with the highest & lowest average freight
-- value.
select
c.customer_state,
avg(freight_value) as avg_freight 
from `TARGET_SQL.orders` as o
join `TARGET_SQL.order_items` as oi
on o.order_id=oi.order_id
join `TARGET_SQL.customers` as c
on c.customer_id= o.customer_id
group by c.customer_state
order by avg_freight desc
limit 5
;

-- 3. Find out the top 5 states with the highest & lowest average delivery
-- time.

select
c.customer_state,

avg(extract(date from o.order_delivered_customer_date)-extract(date from o.order_purchase_timestamp)) as avg_time_to_delivery

from `TARGET_SQL.orders` as o
join `TARGET_SQL.order_items` as oi
on o.order_id=oi.order_id
join `TARGET_SQL.customers` as c
on c.customer_id= o.customer_id
group by c.customer_state
order by avg_time_to_delivery desc
limit 5
;

-- 6. Analysis based on the payments:
-- 1. Find the month on month no. of orders placed using different payment
-- types.
select 
payment_type,
extract(year from order_purchase_timestamp) as year ,
extract(month from order_purchase_timestamp) as month,
count(distinct(o.order_id)) as order_count
from
`TARGET_SQL.orders` as o
inner join `TARGET_SQL.payments` as p 
on o.order_id=p.order_id
group by payment_type,year, month
order by payment_type,year,month;
-- 2. Find the no. of orders placed on the basis of the payment installments
-- that have been paid.

select 
payment_installments,
count(distinct order_id) as num_orders
from `TARGET_SQL.payments`
group by payment_installments;




