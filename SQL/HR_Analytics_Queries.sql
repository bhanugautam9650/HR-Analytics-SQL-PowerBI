/*
==============================================================
HR Analytics Project
==============================================================

Tool: SQL Server
Database Table: HR_Analytics

Objective: Analyze employee workforce, salary, performance, 
hiring trends and employee attrition.

Author: Bhanu Gautam
==============================================================
*/

--1.Total Employees
Select 
	count(*) as total_employees
from HR_Analytics

--2. Employees by Department
Select
	department,
	count(*) as employee_count
from HR_Analytics
group by department

--3. Average Salary by Department
Select
	department,
	avg(salary) as dept_avg_salary
from HR_Analytics
group by department

--4. Departments Ranked by Average Salary (Highest to Lowest)
Select
	department,
	avg(salary) as dept_avg_salary
from HR_Analytics
group by department
order by dept_avg_salary desc

--5. Departments with Average Salary Greater Than ₹70,000
Select
	department,
	avg(salary) as dept_avg_salary_more_than_70000
from HR_Analytics
group by department
having avg(salary) > 70000
order by dept_avg_salary_more_than_70000 desc

--6. Employee Count by City
select
	city,
	count(*) as employee_count
from HR_Analytics
group by City
order by employee_count desc

--7. Average Salary by Gender
select 
	gender,
	avg(salary) as avg_salary_by_gender
from HR_Analytics
group by Gender
order by avg_salary_by_gender desc

--8. Top 5 Job Roles by Average Salary
select TOP 5 
	Job_Role,
	avg(salary) as avg_salary_role_wise 
from HR_Analytics
group by Job_Role
order by avg_salary_role_wise desc

--9. Average Salary by Department for Employees Aged 30+
select
	Department,
	avg(salary) as age_wise_avg_salary
from HR_Analytics
where Age >= 30
group by Department

--10. Top Performers by Department
select
	department,
	count(*) as Top_performers
from HR_Analytics
where Performance_Rating = 5
group by Department
order by Top_performers desc

--11. Employee Attrition by Department
select
	Department,
	COUNT(*) as Resigned_employees
from HR_Analytics
where Employment_Status = 'Resigned'
group by department
order by Resigned_employees desc

--12. Overall Employee Attrition Rate
select
	CAST(COUNT(CASE 
		WHEN Employment_Status = 'Resigned' THEN 1 
		END) * 100.0 / COUNT(*) as DECIMAL(10,2)) as Attrition_Rate
from HR_Analytics

--13. Department-wise Employee Attrition Rate
select Department,
	CAST(COUNT(CASE 
		WHEN Employment_Status = 'Resigned' THEN 1 
		END) * 100.0 / COUNT(*) as DECIMAL(10,2)) as Attrition_Rate_department_wise
from HR_Analytics
group by Department
order by Attrition_Rate_department_wise desc

--14. Employee Hiring Trend by Year
select 
	YEAR(Joining_Date) as Joining_Year,
	COUNT(*) as employees_joined
from HR_Analytics
group by YEAR(Joining_Date)
order by Joining_Year

--15. Average Employee Experience by Department
select
	Department,
	CAST(AVG(Experience_Years * 1.0) as DECIMAL(10,2)) as avg_experience
from HR_Analytics
group by Department
order by avg_experience	desc

--16. Employees Earning Above Company Average Salary
select
	Employee_ID,
	Employee_Name,
	Department,
	Job_Role,
	Salary
from HR_Analytics
where Salary > (
	select 
		AVG(Salary) as avg_salary
	from HR_Analytics
)

--17. Highest Paid Employee
select
	Employee_ID,
	Employee_Name,
	Department,
	Job_Role,
	Salary
from HR_Analytics
where Salary = (
	select 
		MAX(salary)
	from HR_Analytics
)

--18. Highest Salary by Department
select 
	Department,
	MAX(salary) as dept_highest_salary
from HR_Analytics
group by Department
order by dept_highest_salary desc

--19. Lowest Salary by Department
select 
	Department,
	MIN(salary) as dept_lowest_salary
from HR_Analytics
group by Department
order by dept_lowest_salary

--20. Employee Distribution by Performance Rating
select 
	Performance_Rating,
	COUNT(*) as Employee_count
from HR_Analytics
group by Performance_Rating
order by Performance_Rating

--21. Average Salary by Performance Rating
select
	Performance_Rating,
	AVG(salary) as avg_salary_rating_wise
from HR_Analytics
group by Performance_Rating
order by Performance_Rating desc

--22. Employees with More Than 10 Years of Experience
select
	Employee_ID,
	Employee_Name,
	Department,
	Job_Role,
	Experience_Years
from HR_Analytics
where Experience_Years > 10
order by Experience_Years desc

--23. Employee Count by Gender
select 
	Gender,
	COUNT(*) as emp_count_gender_wise
from HR_Analytics
group by Gender
order by emp_count_gender_wise desc

--24. Employees Earning Above Their Department Average
select 
	Employee_ID,
	Employee_Name,
	Department,
	Salary
from (
	select 
		*,
		AVG(Salary) over(partition by department) as department_avg_salary
	from HR_Analytics
) t
where Salary > department_avg_salary


--25. Highest-Paid Employee in Each Department
select 
	Employee_ID,
	Employee_Name,
	Department,
	Job_Role,
	Salary
from (
select
	*,
	MAX(salary) over(partition by Department) as dept_max_salary
from HR_Analytics
) t
where Salary = dept_max_salary

--26. Salary Ranking Within Each Department
select 
	Employee_ID,
	Employee_Name,
	Department,
	Salary,
	RANK() over(Partition by department order by salary desc) as salary_rank
from HR_Analytics

--27. Top 2 Highest-Paid Employees in Each Department
select 
	*
from (
	select 
		Employee_ID,
		Employee_Name,
		Department,
		Salary,
		ROW_NUMBER() over(Partition by department order by salary desc) as salary_rank
	from HR_Analytics
) t
where salary_rank <=2

--28. Salary Classification
select
	Employee_ID,
	Employee_Name,
	Department,
	Salary,
	(CASE
		WHEN Salary < 40000 THEN 'Low_Salary'
		WHEN Salary BETWEEN 40000 AND 70000 THEN 'Medium_Salary'
		ELSE 'High_Salary'
	END) as Salary_Category
from HR_Analytics

--29. Department Hiring & Attrition Analysis
select 
	Department,
	COUNT(*) as Total_Employees,
	SUM(CASE
		WHEN Employment_Status = 'Resigned' THEN 1
	END) as Resigned_Employees,
	CAST(SUM(CASE
		WHEN Employment_Status = 'Resigned' THEN 1
	END) * 100.0 / COUNT(*) AS DECIMAL(10,2)) as Attrition_Rate
from HR_Analytics
group by Department

--30. Final HR Management Summary
select 
	Department,
	COUNT(*) as Total_Employees,
	AVG(salary) as Average_Salary,
	MAX(salary) as Highest_Salary,
	MIN(salary) as Lowest_Salary,
	CAST(AVG(Experience_Years * 1.0) AS DECIMAL(10,2)) as Average_Experience,
	SUM(CASE
			WHEN Performance_Rating = 5 THEN 1 ELSE 0
		END) as Top_performers
from HR_Analytics
group by Department
