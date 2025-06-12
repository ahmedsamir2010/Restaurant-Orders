# Restaurant Order Analysis (01-01-2023 TO 31-03-2023) 🍽

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📊 Overview
Analyze order data to identify the most and least popular menu items and types of cuisine

## 🗂 Project Structure
- `SQL Query.sql`: Main SQL file containing analysis queries
- `dataset`: Folder With all dataset type
- `Excel analysis.xlsx`: Excel file with query results for easy viewing and further analysis

## 🚀 Getting Started

### Prerequisites
1. SQL Server Database Management System 
2. CSV file viewer
3. Ability to import CSV files into SQL Server
4. ADV SQL knowledge

### Installation Steps
1. Clone this repository:
```bash
git clone https://github.com/yourusername/us-baby-names-analysis.git
```

2. Open SQL Server and create a new database RestaurantDB
3. Import dataset into a table

### Viewing Results
- View query results directly in your SQL Server interface
- Export results to Excel for additional analysis
- Use data visualization tools for creating charts and graphs

## 📝 Query Highlights

```sql
--find the number of orders
SELECT COUNT(*) FROM order_details
--find the number of items on the menu
SELECT COUNT(*) FROM menu_items
```
<details>
  <summary>📊 Show Results</summary>

|    | orders    | items  |
|----|-----------|--------|
| 1  | 12,234    |   32   |

</details>

```sql
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
```
<details>
  <summary>📊 Show Results</summary>

| menu_item_id | item_name     | category | price | priceval |
|--------------|---------------|----------|-------|----------|
| 113          | Edamame       | Asian    | 5.00  | low      |
| 130          | Shrimp Scampi | Italian  | 19.95 | hight    |
		 
</details>

```sql
--2-How many Italian dishes are on the menu?
SELECT count(*) FROM menu_items
WHERE category = 'Italian';
```
<details>
  <summary>📊 Show Results</summary>
|   |
|---|
| 9 |

</details>

```sql
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

```
<details>
  <summary>📊 Show Results</summary>

| menu_item_id | item_name     | category | price | priceval |
|--------------|---------------|----------|-------|----------|
| 124          | Spaghetti     | Italian  | 14.50 | low      |
| 130          | Shrimp Scampi | Italian  | 19.95 | hight    |

</details>


```sql
-- 4- How many dishes are in each category?

SELECT mi.category ,count(mi.menu_item_id) as countitems 
FROM menu_items mi
GROUP BY category;
```
<details>
  <summary>📊 Show Results</summary>

| category | countitems |
|----------|------------|
| American | 6          |
| Asian    | 8          |
| Italian  | 9          |
| Mexican  | 9          |


</details>

```sql
--5- What is the average dish price within each category?
SELECT mi.category ,AVG(mi.price) as avgprice 
FROM menu_items mi
GROUP BY category;
```
<details>
  <summary>📊 Show Results</summary>
  
| category | avgprice  |
|----------|-----------|
| American | 10.066666 |
| Asian    | 13.475000 |
| Italian  | 16.750000 |
| Mexican  | 11.800000 |


</details>

```sql
-- 6- What is the date range of the table?
SELECT MIN(order_date) as 'mindate', MAX(order_date) as 'maxdate' FROM order_details
```
<details>
  <summary>📊 Show Results</summary>
  
| mindate    | maxdate    |
|------------|------------|
| 2023-01-01 | 2023-03-31 |

</details>

```sql
-- 7- How many orders were made within this date range?
SELECT COUNT(DISTINCT order_id) FROM order_details
```
<details>
  <summary>📊 Show Results</summary>

|       |
|-------|
| 5370  |

</details>


```sql
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
```
<details>
  <summary>📊 Show Results</summary>

|       |
|-------|
| 12234 |


| order_id | items |
|----------|-------|
| 330      | 14    |
| 3473     | 14    |
| 2675     | 14    |
| 1957     | 14    |
| 440      | 14    |
| 443      | 14    |
| 4305     | 14    |
| 1274     | 13    |
| 1569     | 13    |
| 4836     | 13    |

|       |
|-------|
| 20    |
</details>

```sql
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
```
<details>
  <summary>📊 Show Results</summary>
  
| order_id | order_date | order_time | item_name           | category | price | quantity  |
|----------|------------|------------|----------------------|----------|-------|----------|
| 1        | 2023-01-01 | 11:38:36   | Korean Beef Bowl     | Asian    | 17.95 | 1        |
| 2        | 2023-01-01 | 11:57:40   | Chicken Burrito      | Mexican  | 12.95 | 1        |
| 2        | 2023-01-01 | 11:57:40   | French Fries         | American | 7.00  | 1        |
| 2        | 2023-01-01 | 11:57:40   | Mushroom Ravioli     | Italian  | 15.50 | 1        |
| 2        | 2023-01-01 | 11:57:40   | Spaghetti            | Italian  | 14.50 | 1        |
| 2        | 2023-01-01 | 11:57:40   | Tofu Pad Thai        | Asian    | 14.50 | 1        |
| 3        | 2023-01-01 | 12:12:28   | Chicken Burrito      | Mexican  | 12.95 | 1        |
| 3        | 2023-01-01 | 12:12:28   | Chicken Torta        | Mexican  | 11.95 | 1        |
| 4        | 2023-01-01 | 12:16:31   | Chicken Burrito      | Mexican  | 12.95 | 1        |
| 5        | 2023-01-01 | 12:21:30   | Chicken Burrito      | Mexican  | 12.95 | 1        |

</details>

```sql
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
```
<details>
  <summary>📊 Show Results</summary>
  
 
| item_name            | category | price | quantity |
|----------------------|----------|--------|----------|
| Hamburger            | American | 12.95  | 622      |
| Edamame              | Asian    | 5.00   | 620      |
| Korean Beef Bowl     | Asian    | 17.95  | 588      |
| Cheeseburger         | American | 13.95  | 583      |
| French Fries         | American | 7.00   | 571      |
| Tofu Pad Thai        | Asian    | 14.50  | 562      |
| Steak Torta          | Mexican  | 13.95  | 489      |
| Spaghetti & Meatballs| Italian  | 17.95  | 470      |
| Mac & Cheese         | American | 7.00   | 463      |
| Chips & Salsa        | Mexican  | 7.00   | 461      |
| Orange Chicken       | Asian    | 16.50  | 456      |
| Chicken Burrito      | Mexican  | 12.95  | 455      |
| Eggplant Parmesan    | Italian  | 16.95  | 420      |
| Chicken Torta        | Mexican  | 11.95  | 379      |
| Spaghetti            | Italian  | 14.50  | 367      |
| Chicken Parmesan     | Italian  | 17.95  | 364      |
| Pork Ramen           | Asian    | 17.95  | 360      |
| Mushroom Ravioli     | Italian  | 15.50  | 359      |
| California Roll      | Asian    | 11.95  | 355      |
| Steak Burrito        | Mexican  | 14.95  | 354      |
| Salmon Roll          | Asian    | 14.95  | 324      |
| Meat Lasagna         | Italian  | 17.95  | 273      |
| Hot Dog              | American | 9.00   | 257      |
| Fettuccine Alfredo   | Italian  | 14.50  | 249      |
| Shrimp Scampi        | Italian  | 19.95  | 239      |
| Veggie Burger        | American | 10.50  | 238      |
| Chips & Guacamole    | Mexican  | 9.00   | 237      |
| Cheese Quesadillas   | Mexican  | 10.50  | 233      |
| Steak Tacos          | Mexican  | 13.95  | 214      |
| Cheese Lasagna       | Italian  | 15.50  | 207      |
| Potstickers          | Asian    | 9.00   | 205      |
| Chicken Tacos        | Mexican  | 11.95  | 123      |

  </details>

```sql
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
```
<details>
  <summary>📊 Show Results</summary>

| order_id | totprice |
|----------|----------|
| 440      | 192.15   |
| 2075     | 191.05   |
| 1957     | 190.10   |
| 330      | 189.70   |
| 2675     | 185.10   |


  </details>

```sql
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

```
<details>
  <summary>📊 Show Results</summary>

| item_name             | price | quantity | totprice |
|-----------------------|--------|----------|----------|
| Korean Beef Bowl      | 17.95  | 588      | 10554.60 |
| Spaghetti & Meatballs | 17.95  | 470      | 8436.50  |
| Tofu Pad Thai         | 14.50  | 562      | 8149.00  |
| Cheeseburger          | 13.95  | 583      | 8132.85  |
| Hamburger             | 12.95  | 622      | 8054.90  |

  </details>

```sql
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

```
<details>
  <summary>📊 Show Results</summary>

| category | items |
|----------|-------|
| Italian  | 8     |
| Mexican  | 2     |
| American | 2     |
| Asian    | 2     |


  </details>
  
```sql
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
```
<details>
  <summary>📊 Show Results</summary>

| order_id | category | items |
|----------|----------|-------|
| 440      | Italian  | 8     |
| 330      | Asian    | 6     |
| 2075     | Italian  | 6     |
| 1957     | Italian  | 5     |
| 2675     | Italian  | 4     |
| 330      | Mexican  | 4     |
| 2675     | Mexican  | 4     |
| 2675     | American | 3     |
| 1957     | Mexican  | 3     |
| 2075     | Mexican  | 3     |
| 1957     | American | 3     |
| 1957     | Asian    | 3     |
| 2075     | Asian    | 3     |
| 2675     | Asian    | 3     |
| 330      | Italian  | 3     |
| 440      | American | 2     |
| 440      | Mexican  | 2     |
| 440      | Asian    | 2     |
| 330      | American | 1     |
| 2075     | American | 1     |


  </details>
  
  
```sql
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
```
<details>
  <summary>📊 Show Results</summary>

| item_name             | category | price | quantity |
|-----------------------|----------|--------|----------|
| Hamburger             | American | 12.95  | 622      |
| Edamame               | Asian    | 5.00   | 620      |
| Steak Torta           | Mexican  | 13.95  | 489      |
| Spaghetti & Meatballs | Italian  | 17.95  | 470      |
| Veggie Burger         | American | 10.50  | 238      |
| Cheese Lasagna        | Italian  | 15.50  | 207      |
| Potstickers           | Asian    | 9.00   | 205      |
| Chicken Tacos         | Mexican  | 11.95  | 123      |

</details>
  

## 🤝 Contributing
Contributions are welcome! Here's how you can help:
- Add new analysis queries
- Improve existing queries
- Document results and findings
- Add new visualization examples

## 📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact
For questions or feedback, please open an issue in this repository.
