# Subqueries

#So subqueries are queries within queries. Let's see how this looks.

SELECT *
FROM employee_demographics;


#Now let's say we wanted to look at employees who actually work in the Parks and Rec Department, we could join tables together or we could use a subquery
#We can do that like this:

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id
				FROM employee_salary
                WHERE dept_id = 1);
                
#So we are using that subquery in the where statement and if we just highlight the subwuery and run it it's basically a list we are selecting from in the outer query

SELECT *
FROM employee_demographics
WHERE employee_id IN 
			(SELECT employee_id, salary
				FROM employee_salary
                WHERE dept_id = 1);

# now if we try to have more than 1 column in the subquery we get an error saying the operand should contain 1 column only 

#We can also use subqueries in the select and the from statements - let's see how we can do this

-- Let's say we want to look at the salaries and compare them to the average salary

SELECT first_name, salary, AVG(salary)
FROM employee_salary;
-- if we run this it's not going to work, we are using columns with an aggregate function so we need to use group by
-- if we do that though we don't exactly get what we want
SELECT first_name, salary, AVG(salary)
FROM employee_salary
GROUP BY first_name, salary;

-- it's giving us the average PER GROUP which we don't want
-- here's a good use for a subquery

SELECT first_name, 
salary, 
(SELECT AVG(salary) 
	FROM employee_salary)
FROM employee_salary;


-- We can also use it in the FROM Statement
-- when we use it here it's almost like we are creating a small table we are querying off of
SELECT *
FROM (SELECT gender, MIN(age), MAX(age), COUNT(age),AVG(age)
FROM employee_demographics
GROUP BY gender) 
;
-- now this doesn't work because we get an error saying we have to name it

SELECT gender, AVG(Min_age)
FROM (SELECT gender, MIN(age) Min_age, MAX(age) Max_age, COUNT(age) Count_age ,AVG(age) Avg_age
FROM employee_demographics
GROUP BY gender) AS Agg_Table
GROUP BY gender
;





---(### **Subqueries in SQL**

A **subquery** (or inner query) is a query nested within another query (the outer query). Subqueries are used to perform intermediate calculations or retrieve data that can be used in the main query.

---

### **Types of Subqueries**
1. **Single-Value Subqueries**  
   Returns a single value (scalar) for use in a comparison or calculation.
2. **Multi-Value Subqueries**  
   Returns multiple rows or values for use with `IN`, `ANY`, or `ALL`.
3. **Table Subqueries**  
   Returns a complete table, often used in the `FROM` clause.
4. **Correlated Subqueries**  
   References columns from the outer query, evaluating for each row.

---

### **1. Single-Value Subquery**
- A subquery that returns a single value (e.g., a number or string).  
- Typically used with comparison operators like `=`, `<`, `>`, etc.

**Example:**
Find employees whose salary is greater than the average salary.
```sql
SELECT employee_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);
```

---

### **2. Multi-Value Subquery**
- A subquery that returns multiple values, often used with operators like `IN`, `ANY`, or `ALL`.

**Example with `IN`:**  
Find employees who belong to departments located in "New York" or "San Francisco."
```sql
SELECT employee_name, department_id
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM departments
    WHERE location IN ('New York', 'San Francisco')
);
```

**Example with `ANY`:**  
Find employees whose salary is greater than the salary of **any** employee in department 2.
```sql
SELECT employee_name, salary
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department_id = 2
);
```

---

### **3. Table Subquery**
- A subquery that returns a full table, often used in the `FROM` clause.  
- Requires an alias to refer to the subquery's results.

**Example:**
Find the average salary for each department, then list departments where the average salary exceeds 50,000.
```sql
SELECT department_id, avg_salary
FROM (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
WHERE avg_salary > 50000;
```

---

### **4. Correlated Subquery**
- A subquery that references columns from the outer query.
- Evaluates row-by-row for the outer query.

**Example:**
Find employees whose salary is greater than the average salary of their department.
```sql
SELECT employee_name, salary, department_id
FROM employees e1
WHERE salary > (
    SELECT AVG(salary)
    FROM employees e2
    WHERE e1.department_id = e2.department_id
);
```

---

### **Subquery Placement**
Subqueries can appear in various parts of a query:

1. **In the SELECT Clause**  
   Used to calculate derived values for each row.
   ```sql
   SELECT employee_name, salary,
          (SELECT AVG(salary) FROM employees) AS avg_salary
   FROM employees;
   ```

2. **In the WHERE Clause**  
   Filters rows based on the result of a subquery.
   ```sql
   SELECT employee_name
   FROM employees
   WHERE department_id = (
       SELECT department_id
       FROM departments
       WHERE department_name = 'HR'
   );
   ```

3. **In the FROM Clause**  
   Acts as a derived table.
   ```sql
   SELECT employee_name, avg_salary
   FROM (
       SELECT department_id, AVG(salary) AS avg_salary
       FROM employees
       GROUP BY department_id
   ) AS dept_avg
   JOIN employees ON employees.department_id = dept_avg.department_id;
   ```

---

### **Key Points**
1. Subqueries **must return a compatible value** or structure for their context (e.g., a scalar value for comparison or a list for `IN`).
2. Use **aliases** to reference subquery results in the outer query.
3. **Correlated subqueries** can be slower because they run for each row of the outer query.

---

### **Performance Tips**
- Use **joins** instead of subqueries when possible for better performance.
- Ensure proper indexing to optimize subquery execution.
- Avoid subqueries in the `WHERE` clause if a derived table or join can achieve the same result.
)---
