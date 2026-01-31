/**
Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

transactions Table:
Column Name	Type
user_id	integer
spend	decimal
transaction_date	timestamp
transactions Example Input:
user_id	spend	transaction_date
111	100.50	01/08/2022 12:00:00
111	55.00	01/10/2022 12:00:00
121	36.00	01/18/2022 12:00:00
145	24.99	01/26/2022 12:00:00
111	89.60	02/05/2022 12:00:00
Example Output:
user_id	spend	transaction_date
111	89.60	02/05/2022 12:00:00
The dataset you are querying against may have different input & output - this is just an example!

**/

select user_id,spend,transaction_date 
from (
select *,rank() over (partition by user_id order by transaction_date) as rnk
from transactions
)t 
where rnk =3;

/**
Difference between rank , dense_rank , and row_number 

Partition   Rank     Dense_Rank     Row_Number
A             1           1              1 
B             2           2              2
B             2           2              3
C             4           3              4
D             5           4              5

**/
