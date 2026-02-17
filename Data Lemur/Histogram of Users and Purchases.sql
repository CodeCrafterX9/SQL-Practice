/**
Walmart SQL Interview Question
Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a query that retrieve the users along with the number of products they bought.

Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological order by the transaction date.

user_transactions Table:
Column Name	Type
product_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	123	68.90	07/08/2022 12:00:00
9623	123	274.10	07/08/2022 12:00:00
1467	115	19.90	07/08/2022 12:00:00
2513	159	25.00	07/08/2022 12:00:00
1452	159	74.50	07/10/2022 12:00:00
Example Output:
transaction_date	user_id	purchase_count
07/08/2022 12:00:00	115	1
07/08/2022 12:00:000	123	2
07/10/2022 12:00:00	159	1

**/

with d2d as (
SELECT user_id,date(transaction_date) date,count(product_id) purchase_count
-- d2d transactions of the user + 
-- also handle edge case of transaction on same day diff times
FROM user_transactions
group by user_id,2
)

select date transaction_date,user_id,purchase_count
from 
(
select *,rank() over (partition by user_id order by date desc) rnk
from d2d
-- ranks data on basis of transaction date
)t 
where rnk =1 
-- filters all data except latest entry
order by 1 desc, 2 asc
