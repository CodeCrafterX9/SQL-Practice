/**
Amazon aims to optimize the storage capacity of its 500,000 square feet warehouse by prioritizing the stocking of prime items and maintaining an equal distribution across all category types. After accommodating prime items, any remaining square footage will be utilized to stock non-prime items while still ensuring an equal balance among all category types.

In essence, the request is to prioritize filling the warehouse with prime items, ensuring an equal number of each category type, before allocating the remaining space to non-prime items, also maintaining an equal number of each category type. If we are not considering equal number from each category type, you could be picking one small item to maximize the items which is not correct according to the solutions here. Hope this helps

**/

with inventory_set as (
select item_type,count(item_id) as item_count,
sum(square_footage) as item_space
from 
inventory
group by 
1
),

prime as (
select item_type,floor(500000/item_space)*item_count as item_count,
floor(500000/item_space)*item_space as occupied
from inventory_set
where item_type='prime_eligible'
)


select * from (
select item_type,item_count
--,occupied 
from prime
union
select item_type,
floor((500000-(select occupied from prime))/item_space)*item_count
--floor((500000-(select occupied from prime))/item_space)*item_space
from 
inventory_set
where item_type = 'not_prime' 
)t
order by item_type desc
