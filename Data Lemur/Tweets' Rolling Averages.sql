/**
Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.

Notes:

A rolling average, also known as a moving average or running mean is a time-series technique that examines trends in data over a specified period of time.
In this case, we want to determine how the tweet count for each user changes over a 3-day period.
**/

with rolling_counts as (
SELECT t1.user_id,t1.tweet_date,t2.tweet_date as rolling_date,t2.tweet_count as rolling_count,
cast(t2.tweet_date as date)-cast(t1.tweet_date as date) datediff FROM 
tweets t1 join tweets t2 
on t1.user_id=t2.user_id and 
(cast(t2.tweet_date as date)-cast(t1.tweet_date as date))
BETWEEN -2 and 0
order by t1.user_id,t1.tweet_date,t2.tweet_date )


select user_id,tweet_date,round(sum(rolling_count)*1.00/count(rolling_date),2) as rolling_avg_3d
from rolling_counts
group by user_id,tweet_date
