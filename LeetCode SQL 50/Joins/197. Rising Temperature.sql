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
Approach 1: DATEDIFF(prevdate,nextdate)=prevdate-nextdate , ABS(-10)=10
Honestly, this question can be solved using multiple approaches like lead ,lag, joins etc.
Here I have firstly self joined the Weather table with itself, such that the entry of previous day is mapped with the entry of next day.
Output:
| prev_id | prev_day   | prev_temp | next_id | next_day   | next_temp |
| ------- | ---------- | --------- | ------- | ---------- | --------- |
| 1       | 2015-01-01 | 10        | 2       | 2015-01-02 | 25        |
| 2       | 2015-01-02 | 25        | 3       | 2015-01-03 | 20        |
| 3       | 2015-01-03 | 20        | 4       | 2015-01-04 | 30        |
| 4       | 2015-01-04 | 30        | null    | null       | null      |

now here we can see that the temp has risen from day 1 to day 2 and day3 to 4.
Hence later i have put that as the filter. 
**/

with d2d as( 
    select w1.id as next_id,w1.recordDate as next_date,w1.temperature as next_temp, w2.id as prev_id,w2.recordDate as prev_date,w2.temperature as prev_temp
    from Weather w1 join Weather w2
    on w1.recordDate>w2.recordDate and abs(datediff(w1.recordDate,w2.recordDate)) =1 
    #w1 next day and w2 is prev day
)
select next_id  id from d2d where next_temp>prev_temp;

/** similar to approach 1 but has inner join instead of left join **/

with next_day as (
select * , lead(temperature) over (order by recordDate) as next_day_temp,
lead(id) over (order by recordDate) as next_day_id,lead(recordDate) over (order by recordDate) as next_date
from Weather )

select next_day_id as id from next_day where 
next_day_temp > temperature 
and datediff(next_date,recordDate)=1;

/** Approach : LEAD ()
instead of doing left joins n all , we can simply use lead()
lead(column_value_required) over (partition by column_name(if there is some grouping required) order by 
column_name (this column tells which row is the next row ) )

So basically lead partitions the table into groups (optional) --> then orders it in desc/asc order --> now picks the value (here temperature)
and puts that value of next row to the current row.

**/

