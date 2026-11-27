-- 1. Create Bank Accounts Table
CREATE TABLE bank_accounts (
    account_id INT PRIMARY KEY,
    account_holder VARCHAR(50),
    balance NUMERIC(12, 2) CHECK (balance >= 0)
);

-- 2. Insert Sample Data
INSERT INTO bank_accounts
VALUES
    (101, 'Rahul', 10000.00),
    (102, 'Aman', 5000.00);

SELECT * FROM bank_accounts;

-- 3. Demonstrate BEGIN and COMMIT
BEGIN;

UPDATE bank_accounts
SET balance = balance - 2000
WHERE account_id = 101;

UPDATE bank_accounts
SET balance = balance + 2000
WHERE account_id = 102;

COMMIT;

SELECT * FROM bank_accounts;

-- 4. Demonstrate ROLLBACK
BEGIN;

UPDATE bank_accounts
SET balance = balance - 1000
WHERE account_id = 101;

ROLLBACK;

SELECT * FROM bank_accounts;

-- 5. Demonstrate SAVEPOINT
BEGIN;

UPDATE bank_accounts
SET balance = balance - 500
WHERE account_id = 101;

SAVEPOINT sp1;

UPDATE bank_accounts
SET balance = balance - 20000
WHERE account_id = 101;

ROLLBACK TO SAVEPOINT sp1;

UPDATE bank_accounts
SET balance = balance + 500
WHERE account_id = 102;

COMMIT;

SELECT * FROM bank_accounts;

-- 6. Demonstrate Transaction Isolation
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SELECT * FROM bank_accounts;

COMMIT;