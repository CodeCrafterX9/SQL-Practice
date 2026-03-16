/** WAYFAIR SQL INTERVIEW QUESTION

Assume you're given a table containing information about Wayfair user transactions for different products. Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the results by product ID.

The output should include the year in ascending order, product ID, current year's spend, previous year's spend and year-on-year growth percentage, rounded to 2 decimal places.

user_transactions Table:
Column Name	Type
transaction_id	integer
product_id	integer
spend	decimal
transaction_date	datetime
user_transactions Example Input:
transaction_id	product_id	spend	transaction_date
1341	123424	1500.60	12/31/2019 12:00:00
1423	123424	1000.20	12/31/2020 12:00:00
1623	123424	1246.44	12/31/2021 12:00:00
1322	123424	2145.32	12/31/2022 12:00:00
Example Output:
year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	123424	1500.60	NULL	NULL
2020	123424	1000.20	1500.60	-33.35
2021	123424	1246.44	1000.20	24.62
2022	123424	2145.32	1246.44	72.12
Explanation:
Product ID 123424 is analyzed for multiple years: 2019, 2020, 2021, and 2022.

In the year 2020, the current year's spend is 1000.20, and there is no previous year's spend recorded (indicated by an empty cell).
In the year 2021, the current year's spend is 1246.44, and the previous year's spend is 1000.20.
In the year 2022, the current year's spend is 2145.32, and the previous year's spend is 1246.44.
To calculate the year-on-year growth rate, we compare the current year's spend with the previous year's spend.For instance, the spend grew by 24.62% from 2020 to 2021, indicating a positive growth rate.

**/
with base as (
SELECT *,extract(year from (transaction_date)) as year 
FROM user_transactions)
,
yoy_spend as (
select year,product_id,sum(spend) as curr_year_spend 
from base 
group by 1,2
)
,
cte_3 as (
select *,
lag(curr_year_spend) over (partition by product_id order by year) as prev_year_spend
from 
yoy_spend
)

select *,case when prev_year_spend is null then Null 
else round((curr_year_spend-prev_year_spend)*100/prev_year_spend,2)
end as yoy_rate
from cte_3
