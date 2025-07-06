/* Order Details

Find order details made by Jill and Eva.
Consider the Jill and Eva as first names of customers.
Output the order date, details and cost along with the first name.
Order records based on the customer id in ascending order.

Tables: 1. customers 2. orders

customers

address: text
city: text
first_name: text
id: bigint
last_name: text
phone_number: text

orders

cust_id: bigint
id: bigint
order_date: date
order_details: text
total_order_cost: bigint
*/
select
c.first_name , o.order_date, o.order_details, o.total_order_cost 
from customers c inner join orders o 
on c.id=o.cust_id
where c.first_name="Jill" or c.first_name="Eva"
order by c.id asc;
