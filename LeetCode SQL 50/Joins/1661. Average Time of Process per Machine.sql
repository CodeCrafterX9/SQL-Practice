/**
Table: Activity

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| machine_id     | int     |
| process_id     | int     |
| activity_type  | enum    |
| timestamp      | float   |
+----------------+---------+
The table shows the user activities for a factory website.
(machine_id, process_id, activity_type) is the primary key (combination of columns with unique values) of this table.
machine_id is the ID of a machine.
process_id is the ID of a process running on the machine with ID machine_id.
activity_type is an ENUM (category) of type ('start', 'end').
timestamp is a float representing the current time in seconds.
'start' means the machine starts the process at the given timestamp and 'end' means the machine ends the process at the given timestamp.
The 'start' timestamp will always be before the 'end' timestamp for every (machine_id, process_id) pair.
It is guaranteed that each (machine_id, process_id) pair has a 'start' and 'end' timestamp.
 

There is a factory website that has several machines each running the same number of processes. Write a solution to find the average time each machine takes to complete a process.

The time to complete a process is the 'end' timestamp minus the 'start' timestamp. The average time is calculated by the total time to complete every process on the machine divided by the number of processes that were run.

The resulting table should have the machine_id along with the average time as processing_time, which should be rounded to 3 decimal places.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Activity table:
+------------+------------+---------------+-----------+
| machine_id | process_id | activity_type | timestamp |
+------------+------------+---------------+-----------+
| 0          | 0          | start         | 0.712     |
| 0          | 0          | end           | 1.520     |
| 0          | 1          | start         | 3.140     |
| 0          | 1          | end           | 4.120     |
| 1          | 0          | start         | 0.550     |
| 1          | 0          | end           | 1.550     |
| 1          | 1          | start         | 0.430     |
| 1          | 1          | end           | 1.420     |
| 2          | 0          | start         | 4.100     |
| 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.500     |
| 2          | 1          | end           | 5.000     |
+------------+------------+---------------+-----------+
Output: 
+------------+-----------------+
| machine_id | processing_time |
+------------+-----------------+
| 0          | 0.894           |
| 1          | 0.995           |
| 2          | 1.456           |
+------------+-----------------+
Explanation: 
There are 3 machines running 2 processes each.
Machine 0's average time is ((1.520 - 0.712) + (4.120 - 3.140)) / 2 = 0.894
Machine 1's average time is ((1.550 - 0.550) + (1.420 - 0.430)) / 2 = 0.995
Machine 2's average time is ((4.512 - 4.100) + (5.000 - 2.500)) / 2 = 1.456
**/

with machine_logs as (
select *,lead(timestamp) over (partition by machine_id,process_id order by timestamp) as end_time, lead(activity_type) over (partition by machine_id,process_id order by timestamp) as end_activity from Activity )

select machine_id, round(sum(end_time-timestamp)/count(process_id),3) as processing_time
from machine_logs
where end_time is not null 
group by machine_id;

/** Approach: Now since we know that the end time stamp fdor each process will be more than the start timestamp
so we basically partition the tables by machine and process , to bring end_time in the same row.

| machine_id | process_id | activity_type | timestamp | end_time | end_activity |
| ---------- | ---------- | ------------- | --------- | -------- | ------------ |
| 0          | 0          | start         | 0.712     | 1.52     | end          |
| 0          | 0          | end           | 1.52      | null     | null         |
| 0          | 1          | start         | 3.14      | 4.12     | end          |
| 0          | 1          | end           | 4.12      | null     | null         |
| 1          | 0          | start         | 0.55      | 1.55     | end          |
| 1          | 0          | end           | 1.55      | null     | null         |
| 1          | 1          | start         | 0.43      | 1.42     | end          |
| 1          | 1          | end           | 1.42      | null     | null         |
| 2          | 0          | start         | 4.1       | 4.512    | end          |
| 2          | 0          | end           | 4.512     | null     | null         |
| 2          | 1          | start         | 2.5       | 5        | end          |
| 2          | 1          | end           | 5         | null     | null         |

now we can simply filter out the end rows and calculate the diff in the timestamps,(which shall give us time each process has taken)
**/

select * from 
Activity a1 join Activity a2
on a1.machine_id=a2.machine_id and a1.process_id=a2.process_id 
and a1.activity_type='start' and a2.activity_type='end' ;

/**Approach 2: SELF JOIN 

Another way can be if we do self join of the table with itself 

| machine_id | process_id | activity_type | timestamp | machine_id | process_id | activity_type | timestamp |
| ---------- | ---------- | ------------- | --------- | ---------- | ---------- | ------------- | --------- |
| 0          | 0          | start         | 0.712     | 0          | 0          | end           | 1.52      |
| 0          | 1          | start         | 3.14      | 0          | 1          | end           | 4.12      |
| 1          | 0          | start         | 0.55      | 1          | 0          | end           | 1.55      |
| 1          | 1          | start         | 0.43      | 1          | 1          | end           | 1.42      |
| 2          | 0          | start         | 4.1       | 2          | 0          | end           | 4.512     |
| 2          | 1          | start         | 2.5       | 2          | 1          | end           | 5         |

Rest approach shall be the same**/
