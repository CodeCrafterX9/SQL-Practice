/**
1978. Employees Whose Manager Left the Company
Table: Employees

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| employee_id | int      |
| name        | varchar  |
| manager_id  | int      |
| salary      | int      |
+-------------+----------+
In SQL, employee_id is the primary key for this table.
This table contains information about the employees, their salary, and the ID of their manager. Some employees do not have a manager (manager_id is null). 
 

Find the IDs of the employees whose salary is strictly less than $30000 and whose manager left the company. When a manager leaves the company, their information is deleted from the Employees table, but the reports still have their manager_id set to the manager that left.

Return the result table ordered by employee_id.

The result format is in the following example.

 

Example 1:

Input:  
Employees table:
+-------------+-----------+------------+--------+
| employee_id | name      | manager_id | salary |
+-------------+-----------+------------+--------+
| 3           | Mila      | 9          | 60301  |
| 12          | Antonella | null       | 31000  |
| 13          | Emery     | null       | 67084  |
| 1           | Kalel     | 11         | 21241  |
| 9           | Mikaela   | null       | 50937  |
| 11          | Joziah    | 6          | 28485  |
+-------------+-----------+------------+--------+
Output: 
+-------------+
| employee_id |
+-------------+
| 11          |
+-------------+

Explanation: 
The employees with a salary less than $30000 are 1 (Kalel) and 11 (Joziah).
Kalel's manager is employee 11, who is still in the company (Joziah).
Joziah's manager is employee 6, who left the company because there is no row for employee 6 as it was deleted.
**/
with mapping as(
select employee_id,manager_id
from Employees
where manager_id is not null
and salary <30000
)

select m.employee_id
from mapping m left join Employees e 
on m.manager_id=e.employee_id
where e.employee_id is null
order by m.employee_id

/** Approach: CTE & LEFT JOIN
Here I have first created a cte where I have fetched only those employees' data who have a manager and salary less than 30000
Then I have left joined those entries with the Employees table on employee id. and since if the manager has left the company his/her entry will show null
we can simply output those employee ids
**/

select employee_id from 
Employees 
where salary < 30000 and manager_id not in (
    select employee_id from Employees
)
order by employee_id;

/** SUBQUERY:
The approach i have used here is that if the manager will be a part of the company , her/his entry will show as an employee in the table,
So I have fetched entries only for those emeployees whose manager's employee id is not in the db.**/
