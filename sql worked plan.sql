create database  mysql_retail_project_large;;
use  mysql_retail_project_large;;
create table customers (
customer_id int primary key,
customer_name varchar(100),
city varchar(50)
);

create table products (
product_id int primary key,
product_name varchar(100),
unit_price decimal(10,2)
);

create table orders (
order_id int primary key,
customer_id int,
order_date date,
foreign key (customer_id)references customers(customer_id)
);
create table order_items (
order_id int,
product_id int,
quantity int,
foreign key(order_id)references orders(order_id),
foreign key(product_id)references products(product_id)
);

show tables;
describe customers;

select count(*) from customers;
select count(*) from order_items;
select count(*) from orders;
select count(*) from products;
select
customers.customer_name,
orders.order_id,
products.product_name,
order_items.quantity
from customers
join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id;

describe customers;

-- counting orders per customers
select
customers.customer_name,
count(orders.order_id) as total_orders
from customers
left join orders
on customers.customer_id = orders.customer_id 
group by customers.customer_name;
-- finding customers from Nairobi
select * from customers
where city = 'Nairobi';

-- finding products costing more than 20,000
select * from products
where unit_price > 20000;
-- finding products costing between 10000 and 30000

select * from products
where unit_price between 10000 and 30000;
select * from orders
where order_date between '2025-03-01' and '2025-03-31';

-- find customers whose name contain '50'
select * from customers 
where customer_name like '%50%';

-- find customers from Nairobi or Kisumu
select * from customers 
where city in ('Nairobi', 'Kisumu');

-- show products from highest to lowest price
select * from products
order by unit_Price desc;

-- show the 10 most expensive products
select * from products 
order by unit_price desc
limit 10;

-- show the latest 20 orders
select * from orders
order by order_date desc
limit 20;

-- showing orders from oldest to newest
select * from orders
order by order_date asc;

-- top 15 most expensive products
select * from products
order by unit_price desc
limit 15;

-- finding the average product price
select avg(unit_price) as average_price 
from products;
-- total quantity sold
select sum(quantity) as total_units_sold  from order_items;
-- total number of orders
select count(*) as total_orders
from orders;
-- the lowest quantity in a single order;
select max(quantity)
from order_items;

-- calculating potential total revenue
select sum(order_items.quantity * products.unit_price)
as total_revenue
from order_items join products
on order_items.product_id = products.product_id;

-- customers who never ordered
select
customers.customer_id,
customers.customer_name
from customers 
left join orders
on customers.customer_id = orders.customer_id
where orders.order_id is null;

-- revenue by customer
select
customers.customer_id,
customers.customer_name,
sum(order_items.quantity * products.unit_price) as revenue
from customers 
join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id
group by customers.customer_id,
customers.customer_name
order by revenue desc;

-- highest spending customer
select 
customers.customer_name,
sum(order_items.quantity * products.unit_price) 
as revenue
from customers
join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id
group by customers.customer_name
order by revenue desc
limit 1;

-- most popular products
select
products.product_name,
sum(order_items.quantity) as units_sold
from products
join order_items
on products.product_id = order_items.product_id
group by products.product_name
order by units_sold desc;

-- customer segment
select
customers.customer_name,
sum(order_items.quantity * products.unit_price)
as revenue,
case
    when sum(order_items.quantity * products.unit_price) > 500000
           then 'high value'
     when sum(order_items.quantity * products.unit_price) >= 100000     
		   then 'medium value'
	    else 'low value'
        end as customer_segment
from customers
join orders
on customers.customer_id = orders.customer_id
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id
group by customers.customer_name;

-- dense rank
select product_name,
unit_price,
dense_rank() over(order by unit_price desc)
as price_rank
from products;

-- running total revenue
select order_date,
daily_sales,
sum(daily_sales)
over(order by order_date)
as running_total
from 
(
select orders.order_date,
sum(order_items.quantity * products.unit_price)
as daily_sales
from orders
join order_items
on orders.order_id = order_items.order_id
join products
on order_items.product_id = products.product_id
group by orders.order_date
) sales;



































