-- 1. Create Database
CREATE DATABASE IF NOT EXISTS QueryLabDB;
USE QueryLabDB;

-- 2. Create Employee Table
DROP TABLE IF EXISTS EmployeeData;

CREATE TABLE EmployeeData (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(60) NOT NULL,
    department VARCHAR(30) NOT NULL,
    salary INT NOT NULL,
    city VARCHAR(40) NOT NULL,
    hire_date DATE NOT NULL,
    performance_score DECIMAL(4,2) NOT NULL
);

-- 3. Generate 10000 Records
SET SESSION cte_max_recursion_depth = 10001;

INSERT INTO EmployeeData
    (emp_id, emp_name, department, salary, city,
     hire_date, performance_score)
WITH RECURSIVE numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10000
)
SELECT
    n,
    CONCAT('Employee_', n),
    ELT((n MOD 5) + 1,
        'IT', 'HR', 'Finance', 'Sales', 'Operations'),
    30000 + ((n * 137) MOD 90001),
    ELT((n MOD 6) + 1,
        'Lucknow', 'Delhi', 'Mumbai', 'Pune', 'Jaipur', 'Chennai'),
    DATE_ADD('2015-01-01', INTERVAL (n MOD 3500) DAY),
    1.00 + ((n MOD 50) / 10.0)
FROM numbers;

-- 4. Verify Records
SELECT COUNT(*) AS total_rows
FROM EmployeeData;

-- 5. Query 1: Function on Date Column
EXPLAIN
SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE YEAR(hire_date) = 2022;

-- Optimize Query 1
CREATE INDEX idx_hire_date
ON EmployeeData(hire_date);

EXPLAIN
SELECT emp_id, emp_name, hire_date
FROM EmployeeData
WHERE hire_date >= '2022-01-01'
AND hire_date < '2023-01-01';

-- 6. Query 2: Wildcard Search
EXPLAIN
SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE '%999%';

-- Optimize Query 2 for Prefix Search
CREATE INDEX idx_emp_name
ON EmployeeData(emp_name);

EXPLAIN
SELECT emp_id, emp_name
FROM EmployeeData
WHERE emp_name LIKE 'Employee_999%';

-- 7. Query 3: Department Search
EXPLAIN
SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

-- Optimize Query 3
CREATE INDEX idx_department
ON EmployeeData(department);

EXPLAIN
SELECT emp_id, emp_name, salary
FROM EmployeeData
WHERE department = 'Finance';

-- 8. Query 4: Correlated Subquery
EXPLAIN
SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM EmployeeData e2
    WHERE e2.department = e.department
);

-- Optimize Query 4
CREATE INDEX idx_department_salary
ON EmployeeData(department, salary);

EXPLAIN
SELECT e.emp_id, e.emp_name, e.department, e.salary
FROM EmployeeData e
JOIN (
    SELECT department, AVG(salary) AS avg_salary
    FROM EmployeeData
    GROUP BY department
) AS d ON d.department = e.department
WHERE e.salary > d.avg_salary;

-- 9. Query 5: OR Condition
EXPLAIN
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT' OR city = 'Lucknow';

-- Optimize Query 5 Using Indexes and UNION
CREATE INDEX idx_city
ON EmployeeData(city);

EXPLAIN
SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE department = 'IT'

UNION

SELECT emp_id, emp_name, department, city
FROM EmployeeData
WHERE city = 'Lucknow';

-- 10. Verify Indexes
SHOW INDEX FROM EmployeeData;