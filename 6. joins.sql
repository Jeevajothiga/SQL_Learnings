-- Joins

-- joins allow you to combine 2 tables together (or more) if they have a common column.
-- doesn't mean they need the same column name, but the data in it are the same and can be used to join the tables together
-- there are several joins we will look at today, inner joins, outer joins, and self joins


-- here are the first 2 tables - let's see what columns and data in the rows we have in common that we can join on
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

-- let's start with an inner join -- inner joins return rows that are the same in both columns

-- since we have the same columns we need to specify which table they're coming from
SELECT *
FROM employee_demographics
JOIN employee_salary
	ON employee_demographics.employee_id = employee_salary.employee_id;

-- notice Ron Swanson isn't in the results? This is because he doesn't have an employee id in the demographics table. He refused to give his birth date or age or gender

-- use aliasing!
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id;


-- OUTER JOINS

-- for outer joins we have a left and a right join
-- a left join will take everything from the left table even if there is no match in the join, but will only return matches from the right table
-- the exact opposite is true for a right join

SELECT *
FROM employee_salary sal
LEFT JOIN employee_demographics dem
	ON dem.employee_id = sal.employee_id;

-- so you'll notice we have everything from the left table or the salary table. Even though there is no match to ron swanson. 
-- Since there is not match on the right table it's just all Nulls

-- if we just switch this to a right join it basically just looks like an inner join
-- that's because we are taking everything from the demographics table and only matches from the left or salary table. Since they have all the matches
-- it looks kind of like an inner join
SELECT *
FROM employee_salary sal
RIGHT JOIN employee_demographics dem
	ON dem.employee_id = sal.employee_id;



-- Self Join

-- a self join is where you tie a table to itself

SELECT *
FROM employee_salary;

-- what we could do is a secret santa so the person with the higher ID is the person's secret santa


SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id = emp2.employee_id
    ;

-- now let's change it to give them their secret santa
SELECT *
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1  = emp2.employee_id
    ;



SELECT emp1.employee_id as emp_santa, emp1.first_name as santa_first_name, emp1.last_name as santa_last_name, emp2.employee_id, emp2.first_name, emp2.last_name
FROM employee_salary emp1
JOIN employee_salary emp2
	ON emp1.employee_id + 1  = emp2.employee_id
    ;

-- So leslie is Ron's secret santa and so on -- Mark Brandanowitz didn't get a secret santa, but he doesn't deserve one because he broke Ann's heart so it's all good






-- Joining multiple tables

-- now we have on other table we can join - let's take a look at it
SELECT * 
FROM parks_and_recreation.parks_departments;


SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
JOIN parks_departments dept
	ON dept.department_id = sal.dept_id;

-- now notice when we did that, since it's an inner join it got rid of andy because he wasn't a part of any department

-- if we do a left join we would still include him because we are taking everything from the left table which is the salary table in this instance
SELECT *
FROM employee_demographics dem
INNER JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
LEFT JOIN parks_departments dept
	ON dept.department_id = sal.dept_id;


DIFFERENCE

--Here’s a comprehensive **comparison of all SQL joins** explained side-by-side to help you grasp the differences easily. 

---

### **1. INNER JOIN**
- **Definition**: Returns rows that have matching values in both tables.
- **Key Feature**: Excludes non-matching rows.
- **Use Case**: Retrieve only the common data between two tables.
- **Example**: Find employees working in departments that exist in the `Departments` table.

---

### **2. LEFT JOIN**
- **Definition**: Returns all rows from the left table and matching rows from the right table. Non-matching rows from the right table are filled with `NULL`.
- **Key Feature**: Keeps all rows from the left table, regardless of matches.
- **Use Case**: Find all employees, even if they don’t belong to any department.

---

### **3. RIGHT JOIN**
- **Definition**: Returns all rows from the right table and matching rows from the left table. Non-matching rows from the left table are filled with `NULL`.
- **Key Feature**: Keeps all rows from the right table, regardless of matches.
- **Use Case**: Find all departments, even if they don’t have employees assigned.

---

### **4. FULL OUTER JOIN**
- **Definition**: Returns all rows from both tables, with `NULL` in non-matching rows.
- **Key Feature**: Combines the results of `LEFT JOIN` and `RIGHT JOIN`.
- **Use Case**: Find all employees and all departments, including those with no match.

---

### **5. CROSS JOIN**
- **Definition**: Combines every row from the first table with every row from the second table (Cartesian product).
- **Key Feature**: Produces all possible combinations of rows.
- **Use Case**: Generate test data or all combinations of two datasets.

---

### **6. SELF JOIN**
- **Definition**: A join where a table is joined with itself.
- **Key Feature**: Compares rows within the same table.
- **Use Case**: Find relationships in a single table, like employees and their managers.

---

### Summary Table of Differences

| **Join Type**      | **Returns**                                                                 | **Non-Matching Rows**    | **When to Use**                                   |
|---------------------|-----------------------------------------------------------------------------|--------------------------|--------------------------------------------------|
| **INNER JOIN**      | Only rows with matches in both tables.                                     | No                       | To get common data between two tables.          |
| **LEFT JOIN**       | All rows from the left table + matches from the right table.               | Yes (from the left table)| To include unmatched rows from the left table.   |
| **RIGHT JOIN**      | All rows from the right table + matches from the left table.               | Yes (from the right table)| To include unmatched rows from the right table. |
| **FULL OUTER JOIN** | All rows from both tables.                                                 | Yes (from both tables)   | To include all data, even unmatched rows.        |
| **CROSS JOIN**      | Cartesian product of all rows from both tables.                           | Not Applicable           | To generate combinations of two datasets.        |
| **SELF JOIN**       | Rows in the same table that satisfy the join condition.                   | Depends on condition     | To compare rows within a single table.           |

---

### Example for Visualizing Joins
We’ll use the following tables:

#### Table A: Employees
| EmployeeID | Name    | DepartmentID |
|------------|---------|--------------|
| 1          | Alice   | 10           |
| 2          | Bob     | 20           |
| 3          | Charlie | 30           |
| 4          | David   | NULL         |

#### Table B: Departments
| DepartmentID | DepartmentName |
|--------------|----------------|
| 10           | HR             |
| 20           | IT             |
| 40           | Finance        |

---

### Output Results for Each Join

| **Join Type**    | **Result**                                                                                       |
|-------------------|-------------------------------------------------------------------------------------------------|
| **INNER JOIN**    | Matches only: `Alice - HR`, `Bob - IT`.                                                        |
| **LEFT JOIN**     | Includes all employees: `Alice - HR`, `Bob - IT`, `Charlie - NULL`, `David - NULL`.            |
| **RIGHT JOIN**    | Includes all departments: `Alice - HR`, `Bob - IT`, `NULL - Finance`.                          |
| **FULL OUTER JOIN**| Combines all rows: `Alice - HR`, `Bob - IT`, `Charlie - NULL`, `David - NULL`, `NULL - Finance`.|
| **CROSS JOIN**    | All combinations: e.g., `Alice - HR`, `Alice - IT`, `Bob - HR`, etc.                           |
| **SELF JOIN**     | Depends on context: `Employee - Manager` relationships, for instance.                          |

