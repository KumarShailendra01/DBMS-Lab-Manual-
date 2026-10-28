-- =========================================================
-- EXPERIMENT 7: DATABASE NORMALIZATION
-- Aim: Demonstrate 1NF, 2NF, 3NF, BCNF, Lossless Join,
-- and Dependency Preservation.
-- =========================================================


-- SECTION 1: CREATE DATABASE AND ORIGINAL SALES TABLE

-- Create the database
CREATE DATABASE IF NOT EXISTS SalesDB;

-- Select the database
USE SalesDB;

-- Remove previous experiment tables to allow rerunning
DROP TABLE IF EXISTS Sale_Item_2NF;
DROP TABLE IF EXISTS Sale_Header_3NF;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Product_2NF;
DROP TABLE IF EXISTS Sale_Header_2NF;
DROP TABLE IF EXISTS Sales;

-- Create the original Sales table
-- Each row represents one product within a sale
CREATE TABLE Sales (
    sale_id INT,
    sale_date DATE,
    customer_id INT,
    customer_name VARCHAR(50),
    salesperson_id INT,
    salesperson_name VARCHAR(50),
    product_id INT,
    product_name VARCHAR(50),
    quantity INT,
    PRIMARY KEY (sale_id, product_id)
);

-- Insert six sample sales records
INSERT INTO Sales VALUES
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 201, 'Laptop', 1),
(1001, '2026-01-10', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse', 2),
(1002, '2026-01-11', 2, 'Diya', 102, 'Priya', 201, 'Laptop', 1),
(1002, '2026-01-11', 2, 'Diya', 102, 'Priya', 203, 'Keyboard', 1),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 202, 'Mouse', 3),
(1003, '2026-01-12', 1, 'Aarav', 101, 'Rahul', 204, 'Monitor', 1);

-- Display the original Sales table
SELECT * FROM Sales;


-- SECTION 2: FUNCTIONAL DEPENDENCIES
-- These dependencies are explanations, not executable SQL.
--
-- sale_id -> sale_date, customer_id, salesperson_id
-- customer_id -> customer_name
-- salesperson_id -> salesperson_name
-- product_id -> product_name
-- (sale_id, product_id) -> quantity


-- SECTION 3: FIRST NORMAL FORM (1NF)

-- Display the 1NF table
-- Every field contains one atomic value
SELECT
    sale_id,
    sale_date,
    customer_id,
    customer_name,
    salesperson_id,
    salesperson_name,
    product_id,
    product_name,
    quantity
FROM Sales
ORDER BY sale_id, product_id;


-- SECTION 4: SECOND NORMAL FORM (2NF)

-- Create a table for sale-level information
CREATE TABLE Sale_Header_2NF (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    customer_id INT,
    customer_name VARCHAR(50),
    salesperson_id INT,
    salesperson_name VARCHAR(50)
);

-- Insert unique sale-header records
INSERT INTO Sale_Header_2NF
SELECT DISTINCT
    sale_id,
    sale_date,
    customer_id,
    customer_name,
    salesperson_id,
    salesperson_name
FROM Sales;

-- Create a table for product information
CREATE TABLE Product_2NF (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50)
);

-- Insert unique product records
INSERT INTO Product_2NF
SELECT DISTINCT
    product_id,
    product_name
FROM Sales;

-- Create a table for products belonging to each sale
CREATE TABLE Sale_Item_2NF (
    sale_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (sale_id, product_id),

    -- Connect each sale item to its sale
    FOREIGN KEY (sale_id)
        REFERENCES Sale_Header_2NF(sale_id),

    -- Connect each sale item to its product
    FOREIGN KEY (product_id)
        REFERENCES Product_2NF(product_id)
);

-- Insert all sale-item records
INSERT INTO Sale_Item_2NF
SELECT sale_id, product_id, quantity
FROM Sales;

-- Display the 2NF sale-header table
SELECT * FROM Sale_Header_2NF
ORDER BY sale_id;

-- Display the 2NF product table
SELECT * FROM Product_2NF
ORDER BY product_id;

-- Display the 2NF sale-item table
SELECT * FROM Sale_Item_2NF
ORDER BY sale_id, product_id;


-- SECTION 5: THIRD NORMAL FORM (3NF)

-- Create the Customer table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50)
);

-- Insert unique customer records
INSERT INTO Customer
SELECT DISTINCT customer_id, customer_name
FROM Sale_Header_2NF;

-- Create the Salesperson table
CREATE TABLE Salesperson (
    salesperson_id INT PRIMARY KEY,
    salesperson_name VARCHAR(50)
);

-- Insert unique salesperson records
INSERT INTO Salesperson
SELECT DISTINCT salesperson_id, salesperson_name
FROM Sale_Header_2NF;

-- Create the normalized sale-header table
-- Customer and salesperson names are stored separately
CREATE TABLE Sale_Header_3NF (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    customer_id INT,
    salesperson_id INT,

    -- Connect each sale to a customer
    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    -- Connect each sale to a salesperson
    FOREIGN KEY (salesperson_id)
        REFERENCES Salesperson(salesperson_id)
);

-- Insert normalized sale-header records
INSERT INTO Sale_Header_3NF
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header_2NF;

-- Display customer records
SELECT * FROM Customer
ORDER BY customer_id;

-- Display salesperson records
SELECT * FROM Salesperson
ORDER BY salesperson_id;

-- Display normalized sale-header records
SELECT * FROM Sale_Header_3NF
ORDER BY sale_id;


-- SECTION 6: VERIFY BOYCE-CODD NORMAL FORM (BCNF)

-- Display customers
-- customer_id is the primary key
SELECT customer_id, customer_name
FROM Customer;

-- Display salespeople
-- salesperson_id is the primary key
SELECT salesperson_id, salesperson_name
FROM Salesperson;

-- Display products
-- product_id is the primary key
SELECT product_id, product_name
FROM Product_2NF;

-- Display sale headers
-- sale_id is the primary key
SELECT sale_id, sale_date, customer_id, salesperson_id
FROM Sale_Header_3NF;

-- Display sale items
-- (sale_id, product_id) is the composite primary key
SELECT sale_id, product_id, quantity
FROM Sale_Item_2NF;


-- SECTION 7: VERIFY LOSSLESS JOIN

-- Reconstruct the original Sales information
-- by joining the normalized tables
SELECT
    H.sale_id,
    H.sale_date,
    H.customer_id,
    C.customer_name,
    H.salesperson_id,
    SP.salesperson_name,
    P.product_id,
    P.product_name,
    I.quantity
FROM Sale_Header_3NF H

-- Retrieve the customer name
JOIN Customer C
    ON H.customer_id = C.customer_id

-- Retrieve the salesperson name
JOIN Salesperson SP
    ON H.salesperson_id = SP.salesperson_id

-- Retrieve products and quantities for each sale
JOIN Sale_Item_2NF I
    ON H.sale_id = I.sale_id

-- Retrieve product names
JOIN Product_2NF P
    ON I.product_id = P.product_id

-- Sort the reconstructed records
ORDER BY H.sale_id, P.product_id;

-- Compare original and reconstructed row counts
SELECT
    (SELECT COUNT(*) FROM Sales) AS original_rows,
    (
        SELECT COUNT(*)
        FROM Sale_Header_3NF H
        JOIN Customer C
            ON H.customer_id = C.customer_id
        JOIN Salesperson SP
            ON H.salesperson_id = SP.salesperson_id
        JOIN Sale_Item_2NF I
            ON H.sale_id = I.sale_id
        JOIN Product_2NF P
            ON I.product_id = P.product_id
    ) AS reconstructed_rows;


-- SECTION 8: VERIFY DEPENDENCY PRESERVATION

-- Check the customer ID-to-name mapping
SELECT
    customer_id,
    COUNT(DISTINCT customer_name) AS name_count
FROM Customer
GROUP BY customer_id;

-- Check the salesperson ID-to-name mapping
SELECT
    salesperson_id,
    COUNT(DISTINCT salesperson_name) AS name_count
FROM Salesperson
GROUP BY salesperson_id;

-- Check the product ID-to-name mapping
SELECT
    product_id,
    COUNT(DISTINCT product_name) AS name_count
FROM Product_2NF
GROUP BY product_id;


-- =========================================================
-- END OF EXPERIMENT 7
-- =========================================================