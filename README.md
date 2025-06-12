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

menu_item_id|item_name    |category|price|priceval|
------------+-------------+--------+-----+--------+
         113|Edamame      |Asian   | 5.00|low     |
         130|Shrimp Scampi|Italian |19.95|hight   |
		 
</details>

```sql
-- Example: Find the most popular names by year
-- Find top Names By year
-- F
with girlnames as (
SELECT YEAR, NAME, SUM(Births) AS TotalBirths
FROM names
WHERE Gender = 'F'
GROUP BY YEAR, NAME
)
SELECT * FROM (
SELECT year,name,
    row_number() over (partition by year order by TotalBirths desc) as rnk
FROM girlnames) as f
WHERE rnk = 1
ORDER BY YEAR ASC
```
<details>
  <summary>📊 Show Results</summary>

| Year | Name     | rnk |
|------|----------|------|
| 1980 | Jennifer | 1    |
| 1981 | Jennifer | 1    |
| 1982 | Jennifer | 1    |
| 1983 | Jennifer | 1    |
| 1984 | Jennifer | 1    |
| 1985 | Jessica  | 1    |
| 1986 | Jessica  | 1    |
| 1987 | Jessica  | 1    |
| 1988 | Jessica  | 1    |
| 1989 | Jessica  | 1    |
| 1990 | Jessica  | 1    |
| 1991 | Ashley   | 1    |
| 1992 | Ashley   | 1    |
| 1993 | Jessica  | 1    |
| 1994 | Jessica  | 1    |
| 1995 | Jessica  | 1    |
| 1996 | Emily    | 1    |
| 1997 | Emily    | 1    |
| 1998 | Emily    | 1    |
| 1999 | Emily    | 1    |
| 2000 | Emily    | 1    |
| 2001 | Emily    | 1    |
| 2002 | Emily    | 1    |
| 2003 | Emily    | 1    |
| 2004 | Emily    | 1    |
| 2005 | Emily    | 1    |
| 2006 | Emily    | 1    |
| 2007 | Emily    | 1    |
| 2008 | Emma     | 1    |
| 2009 | Isabella | 1    |

</details>

```sql
-- M
with boyname as (
SELECT YEAR, NAME, SUM(Births) AS TotalBirths
FROM names
WHERE Gender = 'M'
GROUP BY YEAR, NAME
)
SELECT * FROM (
SELECT year,name,
    row_number() over (partition by year order by TotalBirths desc) as rnk
FROM boyname ) as m
where rnk = 1
ORDER BY YEAR ASC
```
<details>
  <summary>📊 Show Results</summary>

| Year | Name    | rnk |
|------|---------|------|
| 1980 | Michael | 1    |
| 1981 | Michael | 1    |
| 1982 | Michael | 1    |
| 1983 | Michael | 1    |
| 1984 | Michael | 1    |
| 1985 | Michael | 1    |
| 1986 | Michael | 1    |
| 1987 | Michael | 1    |
| 1988 | Michael | 1    |
| 1989 | Michael | 1    |
| 1990 | Michael | 1    |
| 1991 | Michael | 1    |
| 1992 | Michael | 1    |
| 1993 | Michael | 1    |
| 1994 | Michael | 1    |
| 1995 | Michael | 1    |
| 1996 | Michael | 1    |
| 1997 | Michael | 1    |
| 1998 | Michael | 1    |
| 1999 | Jacob   | 1    |
| 2000 | Jacob   | 1    |
| 2001 | Jacob   | 1    |
| 2002 | Jacob   | 1    |
| 2003 | Jacob   | 1    |
| 2004 | Jacob   | 1    |
| 2005 | Jacob   | 1    |
| 2006 | Jacob   | 1    |
| 2007 | Jacob   | 1    |
| 2008 | Jacob   | 1    |
| 2009 | Jacob   | 1    |

</details>


```sql
-- Find the names with the biggest jumps in popularity from the first year of the data set to the last year
USE Babynames;
with allnames as (
	SELECT YEAR, NAME, SUM(Births) AS TotalBirths
	FROM names
	GROUP BY YEAR, NAME
),
names1980 as (
	SELECT year,name,
		row_number() over (partition by year order by TotalBirths desc, name desc) as rnk
	FROM allnames
	WHERE YEAR = 1980
),
names2009 as (
	SELECT year,name,
		row_number() over (partition by year order by TotalBirths desc, name desc) as rnk
	FROM allnames
	WHERE YEAR = 2009
)
SELECT Top 3 t1.Name,t1.Year,t1.rnk,t2.Name,t2.Year,t2.rnk,
       t1.rnk - t2.rnk AS diff
FROM names1980 t1
INNER JOIN names2009 t2 ON t1.NAME = t2.NAME
ORDER BY diff desc;
```
<details>
  <summary>📊 Show Results</summary>

| Name   | Year | rnk | Name    | Year | rnk  | diff |
|--------|------|-----|---------|------|------|------|
| Aidan  | 1980 | 5780 | Aidan  | 2009 | 109  | 5671 |
| Colton | 1980 | 5672 | Colton | 2009 | 149  | 5523 |
| Aliyah | 1980 | 5770 | Aliyah | 2009 | 351  | 5419 |

</details>

```sql
--For each year, return the 3 most popular girl names and 3 most popular boy names
use Babynames;
with babiesbyyear as (
SELECT year,name, Gender,sum(Births) as totbirth from names
group by year,name,gender
),
topnames as (
	select YEAR , name, Gender ,
			ROW_NUMBER() over(partition by year, Gender order by totbirth desc) as rnk
	from babiesbyyear
)
select * from topnames
where rnk <= 3
```
<details>
  <summary>📊 Show Results</summary>

| year | name        | Gender | rnk |
|------|-------------|--------|------|
| 1980 | Jennifer    | F      | 1    |
| 1980 | Amanda      | F      | 2    |
| 1980 | Jessica     | F      | 3    |
| 1980 | Michael     | M      | 1    |
| 1980 | Christopher | M      | 2    |
| 1980 | Jason       | M      | 3    |
| 2009 | Isabella    | F      | 1    |
| 2009 | Emma        | F      | 2    |
| 2009 | Olivia      | F      | 3    |
| 2009 | Jacob       | M      | 1    |
| 2009 | Ethan       | M      | 2    |
| 2009 | Michael     | M      | 3    |

</details>

```sql
--For each decade, return the 3 most popular girl names and 3 most popular boy names
use Babynames;
with nameswithdecade as (
SELECT case when year between 1980 and 1989 then 80
			when year between 1990 and 1999 then 90
			when year between 2000 and 2009 then 2000
			else 'GZ' end as decade,
name, Gender,Births from names
),
babiesbydecade as (
SELECT decade,name,Gender,SUM(births) AS totbirth
    FROM nameswithdecade
    WHERE decade IS NOT NULL
    GROUP BY decade, name, gender
),
topnames as (
	select decade , name, Gender ,
			ROW_NUMBER() over(partition by decade, Gender order by totbirth desc) as rnk
	from babiesbydecade
)
select * from topnames
where rnk <= 3
```
<details>
  <summary>📊 Show Results</summary>

| decade | name        | Gender | rnk |
|--------|-------------|--------|------|
| 80     | Jessica     | F      | 1    |
| 80     | Jennifer    | F      | 2    |
| 80     | Amanda      | F      | 3    |
| 80     | Michael     | M      | 1    |
| 80     | Christopher | M      | 2    |
| 80     | Matthew     | M      | 3    |
| 90     | Jessica     | F      | 1    |
| 90     | Ashley      | F      | 2    |
| 90     | Emily       | F      | 3    |
| 90     | Michael     | M      | 1    |
| 90     | Christopher | M      | 2    |
| 90     | Matthew     | M      | 3    |
| 2000   | Emily       | F      | 1    |
| 2000   | Madison     | F      | 2    |
| 2000   | Emma        | F      | 3    |
| 2000   | Jacob       | M      | 1    |
| 2000   | Michael     | M      | 2    |
| 2000   | Joshua      | M      | 3    |
</details>

```sql
-- Return the number of babies born in each of the six regions
USE Babynames;
--find miss / null / duplicated data
select distinct n.State,cr.region from names n
left join regions cr
on n.State = cr.State
-- MI is miss state
--New England is duplicated ->> New_England
```
<details>
  <summary>📊 Show Results</summary>

  ## 📍 State and Region Distribution

| State | Region       |
|-------|-------------|
| AK    | Pacific     |
| AL    | South       |
| AR    | South       |
| AZ    | Mountain    |
| CA    | Pacific     |
| CO    | Mountain    |
| CT    | New_England |
| DC    | Mid_Atlantic|
| DE    | South       |
| FL    | South       |
| GA    | South       |
| HI    | Pacific     |
| IA    | Midwest     |
| ID    | Mountain    |
| IL    | Midwest     |
| IN    | Midwest     |
| KS    | Midwest     |
| KY    | South       |
| LA    | South       |
| MA    | New_England |
| MD    | South       |
| ME    | New_England |
| MI    | NULL        |
| MN    | Midwest     |
| MO    | Midwest     |
| MS    | South       |
| MT    | Mountain    |
| NC    | South       |
| ND    | Midwest     |
| NE    | Midwest     |
| NH    | New England |
| NJ    | Mid_Atlantic|
| NM    | Mountain    |
| NV    | Mountain    |
| NY    | Mid_Atlantic|
| OH    | Midwest     |
| OK    | South       |
| OR    | Pacific     |
| PA    | Mid_Atlantic|
| RI    | New_England |
| SC    | South       |
| SD    | Midwest     |
| TN    | South       |
| TX    | South       |
| UT    | Mountain    |
| VA    | South       |
| VT    | New_England |
| WA    | Pacific     |
| WI    | Midwest     |
| WV    | South       |
| WY    | Mountain    |

</details>


```sql
--clear data
with clean_regin as (
select state,
		case when region = 'New England' then 'New_England' else region end as clean_regi
from regions
union
select 'MI' as state, 'Midwest' as clean_regin
)
-- total births by regi
select cr.clean_regi, sum(n.Births) as totBirths
from names n left join clean_regin cr
on n.State = cr.State
group by clean_regi
```
<details>
  <summary>📊 Show Results</summary>

| clean_regi   | totBirths |
|--------------|-----------|
| South        | 34,219,920|
| Midwest      | 22,676,130|
| Pacific      | 17,540,716|
| Mid_Atlantic | 13,742,667|
| Mountain     |  6,282,217|
| New_England  |  4,269,213|

</details>

```sql
-- top 3 rnk by regin
select * from (
	select cr.clean_regi,n.gender,n.name,
	ROW_NUMBER() over(partition by clean_regi,n.gender order by sum(n.Births) desc) as rnk
	from names n left join clean_regin cr
	on n.State = cr.State
	group by clean_regi,Gender,name
	) as regrnk
where rnk <=3
```
<details>
  <summary>📊 Show Results</summary>

## 📊 Top Names by Region and Gender

| clean_regi  | Gender | Name        | rnk  |
|-------------|--------|-------------|------|
| Mid_Atlantic| F      | Jessica     | 1    |
|             | F      | Ashley      | 2    |
|             | F      | Jennifer    | 3    |
|             | M      | Michael     | 1    |
|             | M      | Matthew     | 2    |
|             | M      | Christopher | 3    |
| Midwest     | F      | Jessica     | 1    |
|             | F      | Ashley      | 2    |
|             | F      | Sarah       | 3    |
|             | M      | Michael     | 1    |
|             | M      | Matthew     | 2    |
|             | M      | Joshua      | 3    |
| Mountain    | F      | Jessica     | 1    |
|             | F      | Ashley      | 2    |
|             | F      | Sarah       | 3    |
|             | M      | Michael     | 1    |
|             | M      | Joshua      | 2    |
|             | M      | Christopher | 3    |
| New_England | F      | Jessica     | 1    |
|             | F      | Sarah       | 2    |
|             | F      | Emily       | 3    |
|             | M      | Michael     | 1    |
|             | M      | Matthew     | 2    |
|             | M      | Christopher | 3    |
| Pacific     | F      | Jessica     | 1    |
|             | F      | Jennifer    | 2    |
|             | F      | Ashley      | 3    |
|             | M      | Michael     | 1    |
|             | M      | Christopher | 2    |
|             | M      | Daniel      | 3    |
| South       | F      | Ashley      | 1    |
|             | F      | Jessica     | 2    |
|             | F      | Jennifer    | 3    |
|             | M      | Christopher | 1    |
|             | M      | Michael     | 2    |
|             | M      | Joshua      | 3    |

</details>

```sql
--Find the 10 most popular androgynous names (names given to both females and males)
USE Babynames;
with tbsex as (
	select name,COUNT(distinct gender) as sex, sum(Births) as totbirths,
	ROW_NUMBER() over(order by sum(Births) desc) as rnk
	from names
	group by name 
)
select TOP 10 * from tbsex
where sex > 1
order by totbirths desc
```
<details>
  <summary>📊 Show Results</summary>

## 📊 Most Popular Androgynous Names

| Name        | sex | totbirths    | rnk |
|-------------|-----|--------------|------|
| Michael     | 2   | 1,382,856    | 1    |
| Christopher | 2   | 1,122,213    | 2    |
| Matthew     | 2   | 1,034,494    | 3    |
| Joshua      | 2   | 960,170      | 4    |
| Jessica     | 2   | 865,046      | 5    |
| Daniel      | 2   | 824,208      | 6    |
| David       | 2   | 819,479      | 7    |
| Ashley      | 2   | 792,865      | 8    |
| James       | 2   | 766,789      | 9    |
| Andrew      | 2   | 761,824      | 10   |

  </details>

```sql
--Find the length of the shortest and longest names, and identify the most popular short names (those with the fewest characters) and long names (those with the most characters)
USE Babynames;
select distinct name, LEN(name) as len  from names
order by len desc, name desc

USE Babynames;
with lenrnk as (
select * from names
	where LEN(name) in(2,15)
)
select * from (
select name, SUM(Births) as totbirths,
ROW_NUMBER() over(partition by len(name) order by sum(Births) desc) as rnk
from lenrnk
group by name
) as rnklen
where rnk <= 3
```
<details>
  <summary>📊 Show Results</summary>

### Shortest Names (2 characters)
| Name | totbirths   | rnk  |
|------|-------------|------|
| Ty   | 29,205      | 1    |
| Bo   | 4,737       | 2    |
| Jo   | 1,713       | 3    |

### Longest Names (15 characters)
| Name            | totbirths | rnk  |
|-----------------|-----------|------|
| Franciscojavier | 52        | 1    |
| Ryanchristopher | 17        | 2    |
| Mariadelosangel | 5         | 3    |

  </details>

```sql
-- The founder of Maven Analytics is named Chris. Find the state with the lowest percent of babies named "Chris"


USE Babynames;
with rnkchis as (
select State,name, SUM(Births) as totbirths 
from names
where name = 'Chris'
group by state,name
),
allbabys as (
select State, SUM(Births) as allbirths 
from names
group by state
)
select top 1 n.State,n.name,n.totbirths,
a.allbirths,
 cast(1.0 * n.totbirths / a.allbirths * 100  as decimal(5,4)) as perc
from rnkchis n
left join allbabys a on n.state = a.state
order by perc asc
-- WV
```
<details>
  <summary>📊 Show Results</summary>

| State | Name | totbirths | allbirths | perc   |
|-------|------|-----------|-----------|--------|
| WV    | Chris| 10        | 553,979   | 0.0018%|

  </details>

## 📊 Output Format
Results will be displayed in organized tables containing:
- Baby name
- Year of record
- Gender
- rnk
- Total births

## 📈 Future Enhancements
- Build Power BI dashboard based on SQL outputs.
- Add more filtering options (e.g., state-level trends, gender ratio changes).
- Use stored procedures or views for reusable queries.

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
