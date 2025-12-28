/** 197. Rising Temperature
Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates' id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30).
**/

with d2d as(
select w1.id as prev_id,w1.recordDate as prev_day,w1.temperature as prev_temp,
w2.id as next_id,w2.recordDate as next_day,w2.temperature as next_temp
from Weather w1 left join Weather w2
on w1.recordDate<w2.recordDate and 
abs(datediff(w1.recordDate,w2.recordDate))=1 )

select next_id Id from d2d 
where next_temp > prev_temp;

/**
Approach 1: Honestly, this question can be solved using multiple approaches like lead ,lag, joins etc.
Here I have firstly self joined the Weather table with itself, such that the entry of previous day is mapped with the entry of next day.
Output:
| prev_id | prev_day   | prev_temp | next_id | next_day   | next_temp |
| ------- | ---------- | --------- | ------- | ---------- | --------- |
| 1       | 2015-01-01 | 10        | 2       | 2015-01-02 | 25        |
| 2       | 2015-01-02 | 25        | 3       | 2015-01-03 | 20        |
| 3       | 2015-01-03 | 20        | 4       | 2015-01-04 | 30        |
| 4       | 2015-01-04 | 30        | null    | null       | null      |

now here we can see that the temp has risen from day 1 to day 2 and day3 to 4.
Hence later i have put that as the filter. **/
