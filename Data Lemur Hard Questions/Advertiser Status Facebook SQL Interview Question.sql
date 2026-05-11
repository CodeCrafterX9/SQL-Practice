/**
You're provided with two tables: the advertiser table contains information about advertisers and their respective payment status, and the daily_pay table contains the current payment information for advertisers, and it only includes advertisers who have made payments.

Write a query to update the payment status of Facebook advertisers based on the information in the daily_pay table. The output should include the user ID and their current payment status, sorted by the user id.

The payment status of advertisers can be classified into the following categories:

New: Advertisers who are newly registered and have made their first payment.
Existing: Advertisers who have made payments in the past and have recently made a current payment.
Churn: Advertisers who have made payments in the past but have not made any recent payment.
Resurrect: Advertisers who have not made a recent payment but may have made a previous payment and have made a payment again recently.
Before proceeding with the question, it is important to understand the possible transitions in the advertiser's status based on the payment status. 

**/

select coalesce(a.user_id,dp.user_id) as user_id ,
case 
when status = 'NEW' and (paid is not null or paid >0 )
then 'EXISTING'
when status = 'EXISTING' and (paid is not null or paid >0 )
then 'EXISTING'
when status = 'CHURN' and (paid is not null or paid >0 )
then 'RESURRECT'
when status = 'RESURRECT' and (paid is not null or paid >0 )
then 'EXISTING'
when (paid is null or paid <=0 ) then 'CHURN'
when a.user_id is null and (paid is not null or paid >0 )
then 'NEW'
else 'NEW CASE' end as new_status
from advertiser a 
full outer join daily_pay dp on 
a.user_id=dp.user_id
order by 1

/**
APPROACH:
1. Full outer join - Since some companies can be 'NEW' and will not be present in advertiser table . If we do left /Inner join such companies would get skipped . While if we do right join , 
'CHURNED' companies will get skipped
2. Coalesce to handle Churned / New companies 
3. Order By the output as mentioned in the question
**/
