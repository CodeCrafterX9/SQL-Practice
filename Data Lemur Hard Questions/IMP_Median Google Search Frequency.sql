/**
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

search_frequency Table:
Column Name	Type
searches	integer
num_users	integer
search_frequency Example Input:
searches	num_users
1	2
2	2
3	3
4	1
Example Output:
median
2.5
By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.

**/

with base as (
SELECT * ,sum(num_users) over(order by searches) as rolling_sum
FROM search_frequency)
,
  
median_pos as (
select 
case when sum(num_users)%2 =0 then floor(sum(num_users)/2) 
when sum(num_users) % 2 =1 then (sum(num_users)+1)/2 end as start_pos,
case when sum(num_users)%2 =0 then floor(sum(num_users)/2)+1 
when sum(num_users) % 2 =1 then (sum(num_users)+1)/2 end as end_pos
from search_frequency
)
,

median_searches as (
(
select * from base 
where (select start_pos from median_pos) <= rolling_sum
limit 1)
union all
(
select * from base 
where (select end_pos from median_pos) <= rolling_sum
limit 1)

)

select round(avg(searches),1) as median from median_searches

/**
Approach:

Step 1: Calculated the median positions : So basically when we calculate median of a data , 
a) We first calculate the total number of entries
b) Then we calculate the middle most positions - If we have 13 entries then the entry at 7th position is middle most and is median of the sample
c) But if we hav even number of rows , we calculate the average of middle most 2 rows 7th & 8th
d) Since in the query we dont know if we will get even or odd number od entries
e) Which is why i created 2 pointers start_position and end_position, And then average noth of them.
In case of even they will be : n/2 th and (n/2)+1 th positions
And in case of Odd , both of them will be equal to (n+1)/2 hence resulting the average to be the ultimate median

Step 2: Once we have median positions for the given number of rows , we need to calculate the search made by users on these postions, To know wwhich user is on 7th position & 8th position
I calculated rolling sum 

Step 3: Once we find the searches made by users on these positions , we simply average and round the result to 1 decimal point
