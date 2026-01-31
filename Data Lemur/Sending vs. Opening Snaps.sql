/**
Link: https://datalemur.com/questions/time-spent-snaps
Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.

Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

Notes:

Calculate the following percentages:
time spent sending / (Time spent sending + Time spent opening)
Time spent opening / (Time spent sending + Time spent opening)
To avoid integer division in percentages, multiply by 100.0 and not 100.
Effective April 15th, 2023, the solution has been updated and optimised.

activities Table
Column Name	Type
activity_id	integer
user_id	integer
activity_type	string ('send', 'open', 'chat')
time_spent	float
activity_date	datetime
activities Example Input
activity_id	user_id	activity_type	time_spent	activity_date
7274	123	open	4.50	06/22/2022 12:00:00
2425	123	send	3.50	06/22/2022 12:00:00
1413	456	send	5.67	06/23/2022 12:00:00
1414	789	chat	11.00	06/25/2022 12:00:00
2536	456	open	3.00	06/25/2022 12:00:00
age_breakdown Table
Column Name	Type
user_id	integer
age_bucket	string ('21-25', '26-30', '31-25')
age_breakdown Example Input
user_id	age_bucket
123	31-35
456	26-30
789	21-25
Example Output
age_bucket	send_perc	open_perc
26-30	65.40	34.60
31-35	43.75	56.25
Explanation
Using the age bucket 26-30 as example, the time spent sending snaps was 5.67 and the time spent opening snaps was 3.

To calculate the percentage of time spent sending snaps, we divide the time spent sending snaps by the total time spent on sending and opening snaps, which is 5.67 + 3 = 8.67.

So, the percentage of time spent sending snaps is 5.67 / (5.67 + 3) = 65.4%, and the percentage of time spent opening snaps is 3 / (5.67 + 3) = 34.6%.

**/

with users as (
SELECT user_id,
sum(case when activity_type ='open' then time_spent
else 0 end) as open_time,
sum(case when activity_type ='send' then time_spent
else 0 end) as send_time,
sum(case when activity_type in ('open','send') then time_spent
else 0 end) as total_time
FROM activities 
group by 1
)

select age_bucket, round(sum(open_time)*100.0/sum(total_time),2) as open_perc,
round(sum(send_time)*100.0/sum(total_time),2) as send_perc
from users join age_breakdown as ab 
on users.user_id = ab.user_id
group by age_bucket ;

/** approach: 
1. Made user level cte, where we can see total open_time, send_time and send+open_time of each user 
2. Note here in total time i have only taken open and send since there are 3 types of activities (open,send,chat) and we did not require data for chat
3. then i had joined the cte with age_breakdown table to get age buckets for each user
4. I further grouped them on age bucket level and calculated the average**/
