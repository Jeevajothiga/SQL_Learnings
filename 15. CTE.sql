-- Using Common Table Expressions (CTE)
-- A CTE allows you to define a subquery block that can be referenced within the main query. 
-- It is particularly useful for recursive queries or queries that require referencing a higher level
-- this is something we will look at in the next lesson/

-- Let's take a look at the basics of writing a CTE:


-- First, CTEs start using a "With" Keyword. Now we get to name this CTE anything we want
-- Then we say as and within the parenthesis we build our subquery/table we want
WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary), AVG(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- directly after using it we can query the CTE
SELECT *
FROM CTE_Example;


-- Now if I come down here, it won't work because it's not using the same syntax
SELECT *
FROM CTE_Example;



-- Now we can use the columns within this CTE to do calculations on this data that
-- we couldn't have done without it.

WITH CTE_Example AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- notice here I have to use back ticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(`SUM(salary)`/`COUNT(salary)`),2)
FROM CTE_Example
GROUP BY gender;



-- we also have the ability to create multiple CTEs with just one With Expression

WITH CTE_Example AS 
(
SELECT employee_id, gender, birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
), -- just have to separate by using a comma
CTE_Example2 AS 
(
SELECT employee_id, salary
FROM parks_and_recreation.employee_salary
WHERE salary >= 50000
)
-- Now if we change this a bit, we can join these two CTEs together
SELECT *
FROM CTE_Example cte1
LEFT JOIN CTE_Example2 cte2
	ON cte1. employee_id = cte2. employee_id;


-- the last thing I wanted to show you is that we can actually make our life easier by renaming the columns in the CTE
-- let's take our very first CTE we made. We had to use tick marks because of the column names

-- we can rename them like this
WITH CTE_Example (gender, sum_salary, min_salary, max_salary, count_salary) AS 
(
SELECT gender, SUM(salary), MIN(salary), MAX(salary), COUNT(salary)
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
-- notice here I have to use back ticks to specify the table names  - without them it doesn't work
SELECT gender, ROUND(AVG(sum_salary/count_salary),2)
FROM CTE_Example
GROUP BY gender;




#### NOTES 





### **Common Table Expressions (CTEs) in SQL**

A **CTE** (Common Table Expression) is a temporary, named result set that you can reference within a `SELECT`, `INSERT`, `UPDATE`, or `DELETE` statement. CTEs are particularly useful for improving query readability, organizing complex logic, and avoiding repeated subqueries.

---

### **CTE Syntax**
```sql
WITH cte_name AS (
    -- SQL query to define the CTE
    SELECT column1, column2, ...
    FROM table_name
    WHERE condition
)
-- Use the CTE in the main query
SELECT column1, column2
FROM cte_name
WHERE condition;
```

---

### **Key Characteristics of CTEs**
1. **Temporary Scope:** A CTE exists only for the duration of the query it’s part of.
2. **Improves Readability:** Helps break down complex queries into manageable parts.
3. **Reusability:** You can reference the same CTE multiple times in a query.
4. **Hierarchical Queries:** Can be recursive, allowing you to work with hierarchical data like organizational structures.

---

### **1. Simple CTE Example**
Find employees with a salary above the department average:
```sql
WITH department_avg AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
)
SELECT employee_name, department_id, salary
FROM employees
JOIN department_avg
ON employees.department_id = department_avg.department_id
WHERE employees.salary > department_avg.avg_salary;
```

---

### **2. Multiple CTEs**
Define and use multiple CTEs in a single query by separating them with commas.

**Example:**
```sql
WITH high_salary AS (
    SELECT employee_id, employee_name, salary
    FROM employees
    WHERE salary > 70000
),
low_salary AS (
    SELECT employee_id, employee_name, salary
    FROM employees
    WHERE salary <= 70000
)
SELECT * FROM high_salary
UNION ALL
SELECT * FROM low_salary;
```

---

### **3. Recursive CTEs**
Recursive CTEs allow you to handle hierarchical or recursive data, such as organizational structures or tree-like data.

**Syntax:**
```sql
WITH RECURSIVE cte_name AS (
    -- Anchor member: Base case
    SELECT column1, column2
    FROM table_name
    WHERE condition
    UNION ALL
    -- Recursive member: Iterative step
    SELECT column1, column2
    FROM table_name
    JOIN cte_name ON table_name.column = cte_name.column
)
SELECT * FROM cte_name;
```

**Example: Find organizational hierarchy (manager → employee):**
```sql
WITH RECURSIVE org_hierarchy AS (
    -- Anchor: Start with the top-level manager
    SELECT employee_id, manager_id, employee_name, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive: Add employees reporting to managers in the hierarchy
    SELECT e.employee_id, e.manager_id, e.employee_name, level + 1
    FROM employees e
    JOIN org_hierarchy h
    ON e.manager_id = h.employee_id
)
SELECT * FROM org_hierarchy
ORDER BY level, employee_id;
```

---

### **4. CTE vs Subqueries**
| Feature                  | **CTE**                                | **Subquery**                          |
|--------------------------|-----------------------------------------|---------------------------------------|
| **Readability**          | More readable for complex queries.     | Less readable, especially when nested.|
| **Reusability**          | Can be reused in the same query.       | Needs repetition if reused.           |
| **Performance**          | Generally similar to subqueries.       | Might be optimized similarly by SQL.  |
| **Recursion**            | Supports recursion.                    | Does not support recursion.           |

---

### **Use Cases for CTEs**
1. **Complex Queries:** Break down long or nested queries into manageable steps.
2. **Hierarchical Data:** Handle recursive relationships like org charts or tree structures.
3. **Aggregations and Filters:** Compute intermediate aggregations for use in final queries.
4. **Improving Maintainability:** Make SQL scripts easier to understand and maintain.

---

### **5. Performance Considerations**
- CTEs are not inherently more performant than subqueries; their main advantage is readability.
- For large datasets, consider materialized views or indexed tables if performance is an issue.

---

### **6. Non-Recursive Example (Rank Employees by Department)**
```sql
WITH ranked_employees AS (
    SELECT employee_id, department_id, salary,
           RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank
    FROM employees
)
SELECT *
FROM ranked_employees
WHERE rank = 1; -- Top-paid employee in each department
```

---

Would you like to see practical examples or work on a specific use case for CTEs?
