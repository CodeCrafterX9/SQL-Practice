/** FACEBOOK INTERVIEW QUESTION 

Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs) in July 2022, including the month in numerical format "1, 2, 3".

Hint:

An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.
user_actions Table:
Column Name	Type
user_id	integer
event_id	integer
event_type	string ("sign-in, "like", "comment")
event_date	datetime
user_actionsExample Input:
user_id	event_id	event_type	event_date
445	7765	sign-in	05/31/2022 12:00:00
742	6458	sign-in	06/03/2022 12:00:00
445	3634	like	06/05/2022 12:00:00
742	1374	comment	06/05/2022 12:00:00
648	3124	like	06/18/2022 12:00:00
Example Output for June 2022:
month	monthly_active_users
6	1
Example
In June 2022, there was only one monthly active user (MAU) with the user_id 445.

Please note that the output provided is for June 2022 as the user_actions table only contains event dates for that month. You should adapt the solution accordingly for July 2022.

**/
with cte as (
select user_id,sum(case when event_month=6 then 1 else 0 end) as prev_month,
sum(case when event_month=7 then 1 else 0 end) as curr_month
from (
SELECT *,extract( month from cast(event_date as date)) as event_month,
extract( year from cast(event_date as date)) as event_year
FROM user_actions
where event_type in ('sign-in', 'like', 'comment') 
)t 
group by 1
)

select 7 as month, count(user_id)
from cte 
where prev_month >0 and curr_month>0
