USE RestaurantDB;
--find the number of orders
SELECT COUNT(*) FROM order_details
--find the number of items on the menu
SELECT COUNT(*) FROM menu_items

-- 1- What are the least and most expensive items on the menu?
select * from (
SELECT TOP 1 *,'low' as priceval FROM menu_items
ORDER BY price
) as mi
UNION ALL
select * from (
SELECT TOP 1 *, 'hight' as priceval FROM menu_items
ORDER BY price DESC
) as mi

--2-How many Italian dishes are on the menu?
SELECT count(*) FROM menu_items
WHERE category = 'Italian';

--3- What are the least and most expensive Italian dishes on the menu?
select * from (
SELECT TOP 1 *, 'low' as priceval FROM menu_items
WHERE category = 'Italian'
ORDER BY price
) as mi

UNION ALL

select * from (
SELECT TOP 1 *, 'hight' as priceval  FROM menu_items as mi
WHERE category = 'Italian'
ORDER BY price DESC
) as mi


-- 4- How many dishes are in each category?

SELECT mi.category ,count(mi.menu_item_id) as countitems 
FROM menu_items mi
GROUP BY category;

--5- What is the average dish price within each category?
SELECT mi.category ,AVG(mi.price) as avgprice 
FROM menu_items mi
GROUP BY category;

--View the order_details table?
SELECT * FROM order_details

-- 6- What is the date range of the table?
SELECT MIN(order_date) as 'mindate', MAX(order_date) as 'maxdate' FROM order_details


-- 7- How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id) FROM order_details


-- 8- How many items were ordered within this date range?
SELECT COUNT(*) FROM order_details

-- 9- Which orders had the most number of items?
SELECT TOP 10 order_id,count(item_id) as items FROM order_details
group by order_id
order by items DESC 

-- 10- How many orders had more than 12 items?
WITH Toporders as (
	SELECT order_id,count(item_id) as items FROM order_details
	group by order_id
	HAVING count(item_id) > 12
)
SELECT count(*) from Toporders 


-- 11- Combine the menu_items and order_details tables into a single table
With orders as (
	SELECT
	od.order_id,od.order_date,od.order_time,
	mi.item_name,mi.category,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT  order_id,order_date,order_time,item_name, category , price,
count(item_name) as 'quantity'
FROM orders 
Group by order_id,order_date,order_time,item_name, category , price
order by  order_id,item_name 


-- 12- What were the least and most ordered items? What categories were they in?
With orders as (
	SELECT
	od.order_details_id,
	mi.item_name,mi.category,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT item_name, category, price, count(order_details_id) as 'quantity'
FROM orders 
Group by item_name,category,price
order by quantity desc

-- 13- What were the top 5 orders that spent the most money?
With orders as (
	SELECT
	od.order_id,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT TOP 5 order_id, sum(price)  as 'totprice'
FROM orders 
Group by order_id
order by totprice desc

-- 14- What were the top 5 Items that spent the most money?
With orders as (
	SELECT
	od.order_details_id,
	mi.item_name,mi.category,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT TOP 5 item_name, price, count(order_details_id) as 'quantity',
(price * count(order_details_id)) as 'totprice'
FROM orders 
Group by item_name,price
order by totprice desc 


-- 15- View the details of the highest spend order. Which specific items were purchased?
With orders as (
	SELECT
	od.order_id,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT mi.category,count(od.item_id) as 'items' from order_details od
left JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id in (
	SELECT order_id FROM (
		SELECT TOP 1 order_id, sum(price) as 'totprice'
		FROM orders 
		Group by order_id
		order by totprice desc
	) as toporder
)
GROUP BY mi.category
ORDER BY items desc


-- 16- View the details of the top 5 highest spend orders
With orders as (
	SELECT
	od.order_id,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
)
SELECT od.order_id,mi.category,count(od.item_id) as 'items' from order_details od
left JOIN menu_items mi ON od.item_id = mi.menu_item_id
WHERE order_id in (
	SELECT order_id FROM (
		SELECT TOP 5 order_id, sum(price) as 'totprice'
		FROM orders 
		Group by order_id
		order by totprice desc
	) as toporder
)
GROUP BY od.order_id,mi.category
ORDER BY items desc



-- 17- top and last item for each category
With orders as (
	SELECT
	od.order_details_id,
	mi.item_name,mi.category,mi.price
	FROM order_details od
	left JOIN menu_items mi ON od.item_id = mi.menu_item_id
),
TOPitemsranks as ( 
	SELECT item_name,category, price, count(order_details_id) as 'quantity',
	row_number() over(partition by category order by count(order_details_id) desc) as rank
	FROM orders 
	WHERE category IS NOT NULL
	Group by item_name,category,price
),
lastitemsranks as ( 
	SELECT item_name,category, price, count(order_details_id) as 'quantity',
	row_number() over(partition by category order by count(order_details_id) asc) as rank
	FROM orders 
	WHERE category IS NOT NULL
	Group by item_name,category,price
)
select item_name,category, price,quantity from (
	select * from TOPitemsranks
	union all
	select * from lastitemsranks
) as ranks
where rank = 1
order by quantity desc