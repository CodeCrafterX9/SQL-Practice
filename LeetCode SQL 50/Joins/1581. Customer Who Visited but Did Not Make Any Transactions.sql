/**
1581. Customer Who Visited but Did Not Make Any Transactions
Table: Visits

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| visit_id    | int     |
| customer_id | int     |
+-------------+---------+
visit_id is the column with unique values for this table.
This table contains information about the customers who visited the mall.
 

Table: Transactions

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| transaction_id | int     |
| visit_id       | int     |
| amount         | int     |
+----------------+---------+
transaction_id is column with unique values for this table.
This table contains information about the transactions made during the visit_id.
 

Write a solution to find the IDs of the users who visited without making any transactions and the number of times they made these types of visits.

Return the result table sorted in any order.

The result format is in the following example.

 

Example 1:

Input: 
Visits
+----------+-------------+
| visit_id | customer_id |
+----------+-------------+
| 1        | 23          |
| 2        | 9           |
| 4        | 30          |
| 5        | 54          |
| 6        | 96          |
| 7        | 54          |
| 8        | 54          |
+----------+-------------+
Transactions
+----------------+----------+--------+
| transaction_id | visit_id | amount |
+----------------+----------+--------+
| 2              | 5        | 310    |
| 3              | 5        | 300    |
| 9              | 5        | 200    |
| 12             | 1        | 910    |
| 13             | 2        | 970    |
+----------------+----------+--------+
Output: 
+-------------+----------------+
| customer_id | count_no_trans |
+-------------+----------------+
| 54          | 2              |
| 30          | 1              |
| 96          | 1              |
+-------------+----------------+
Explanation: 
Customer with id = 23 visited the mall once and made one transaction during the visit with id = 12.
Customer with id = 9 visited the mall once and made one transaction during the visit with id = 13.
Customer with id = 30 visited the mall once and did not make any transactions.
Customer with id = 54 visited the mall three times. During 2 visits they did not make any transactions, and during one visit they made 3 transactions.
Customer with id = 96 visited the mall once and did not make any transactions.
As we can see, users with IDs 30 and 96 visited the mall one time without making any transactions. Also, user 54 visited the mall twice and did not make any transactions.
**/
select customer_id,count(visit_id) as count_no_trans
from 
Visits 
where visit_id not in (select visit_id from Transactions group by 1)
group by 1 ;

/**
Approach 1: WHERE NOT IN
Basically whenever a customer makes a payment his visit id is stored in transactions, so that means if a visit id is not stored in Transactions table, then that customer 
didnot make any transaction in that visit.
Then i have grouped the results on cutomer id to see how many such visits each customer has made **/

select customer_id,count(distinct Visits.visit_id) as count_no_trans from 
Visits left join Transactions
on Visits.visit_id = Transactions.visit_id
where transaction_id is null
group by customer_id
;

/**
Approach 2: JOIN
Basically here we can left join both Visits and Transactions Table

Result:
| visit_id | customer_id | transaction_id | visit_id | amount |
| -------- | ----------- | -------------- | -------- | ------ |
| 1        | 23          | 12             | 1        | 910    |
| 2        | 9           | 13             | 2        | 970    |
| 4        | 30          | null           | null     | null   |
| 5        | 54          | 9              | 5        | 200    |
| 5        | 54          | 3              | 5        | 300    |
| 5        | 54          | 2              | 5        | 310    |
| 6        | 96          | null           | null     | null   |
| 7        | 54          | null           | null     | null   |
| 8        | 54          | null           | null     | null   |

Note: all the entries where transaction_id is null are basically those visits when the customer did not make any purchase. Which means we can make a filter of (where transaction_id is null)
Which shall look like this -->

| visit_id | customer_id | transaction_id | visit_id | amount |
| -------- | ----------- | -------------- | -------- | ------ |
| 4        | 30          | null           | null     | null   |
| 6        | 96          | null           | null     | null   |
| 7        | 54          | null           | null     | null   |
| 8        | 54          | null           | null     | null   |

Now just like previous approach we will group the table by cutomer id and count the number of distinct visits the customer has made

Result:
| customer_id | count_no_trans |
| ----------- | -------------- |
| 30          | 1              |
| 54          | 2              |
| 96          | 1              |

**/
