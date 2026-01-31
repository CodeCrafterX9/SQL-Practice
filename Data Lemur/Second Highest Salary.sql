/**
Imagine you're an HR analyst at a tech company tasked with analyzing employee salaries. Your manager is keen on understanding the pay distribution and asks you to determine the second highest salary among all employees.

It's possible that multiple employees may share the same second highest salary. In case of duplicate, display the salary only once.

employee Schema:
column_name	type	description
employee_id	integer	The unique ID of the employee.
name	string	The name of the employee.
salary	integer	The salary of the employee.
department_id	integer	The department ID of the employee.
manager_id	integer	The manager ID of the employee.
employee Example Input:
employee_id	name	salary	department_id	manager_id
1	Emma Thompson	3800	1	6
2	Daniel Rodriguez	2230	1	7
3	Olivia Smith	2000	1	8
Example Output:
second_highest_salary
2230
The output represents the second highest salary among all employees. In this case, the second highest salary is $2,230.

**/


select salary from (
SELECT *, DENSE_RANK() over (order by salary desc)
as rnk
FROM employee ) t
where rnk =2 
limit 1 ;

/**
Approach:
1. we have 3 options to give rank :
a) rank : so if there are more than 1 employee (say 5)  who has highest slary then the rank of second salary will be 6
b) dense rank : only in dense rank the second highest salary shall get 2 rank 
c) row number : so if there are more than 1 employee (say 5) who has highest slary then the row number of second salary will not be 6

2. Used limit if there are more than 1 employees who have second highest salary 
**/
