-- 1. Create Database
CREATE DATABASE RailwayDB;
USE RailwayDB;

-- 2. Create Railway Booking Table
CREATE TABLE Railway_Booking (
    booking_id INT PRIMARY KEY,
    passenger_name VARCHAR(50) NOT NULL,
    train_no INT NOT NULL,
    source_station VARCHAR(30) NOT NULL,
    destination_station VARCHAR(30) NOT NULL,
    journey_date DATE NOT NULL,
    travel_class VARCHAR(5),
    seat_no INT,
    fare DECIMAL(8,2),
    booking_status VARCHAR(15)
);

-- 3. Insert 6000 Records
SET SESSION cte_max_recursion_depth = 10000;

INSERT INTO Railway_Booking
    (booking_id, passenger_name, train_no, source_station,
     destination_station, journey_date, travel_class,
     seat_no, fare, booking_status)
WITH RECURSIVE seq AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM seq WHERE n < 6000
)
SELECT
    n,
    CONCAT('Passenger_', n),
    12000 + MOD(n * 7, 50),
    ELT(MOD(n, 10) + 1,
        'Delhi','Mumbai','Kolkata','Chennai','Lucknow',
        'Kanpur','Jaipur','Bhopal','Patna','Ahmedabad'),
    ELT(MOD(n * 3 + 1, 10) + 1,
        'Delhi','Mumbai','Kolkata','Chennai','Lucknow',
        'Kanpur','Jaipur','Bhopal','Patna','Ahmedabad'),
    DATE_ADD('2026-01-01', INTERVAL MOD(n, 365) DAY),
    ELT(MOD(FLOOR(n / 7), 5) + 1, 'SL','3A','2A','1A','CC'),
    1 + MOD(n * 11, 72),
    300 + MOD(n * 37, 2700),
    ELT(MOD(FLOOR(n / 3), 3) + 1,
        'Confirmed','Waiting','Cancelled')
FROM seq;

-- 4. Verify Records
SELECT COUNT(*) AS total_records
FROM Railway_Booking;

SELECT * FROM Railway_Booking
LIMIT 5;

-- 5. Test Queries Before Indexing
EXPLAIN
SELECT * FROM Railway_Booking
WHERE train_no = 12038;

EXPLAIN
SELECT * FROM Railway_Booking
WHERE train_no = 12038
AND journey_date = '2026-05-20';

EXPLAIN
SELECT * FROM Railway_Booking
WHERE journey_date = '2026-05-20';

-- 6. Create Single-Column Index
CREATE INDEX idx_train_no
ON Railway_Booking(train_no);

ANALYZE TABLE Railway_Booking;

SHOW INDEX FROM Railway_Booking;

-- 7. Test Queries After Single-Column Index
EXPLAIN
SELECT * FROM Railway_Booking
WHERE train_no = 12038;

EXPLAIN ANALYZE
SELECT * FROM Railway_Booking
WHERE train_no = 12038;

EXPLAIN
SELECT * FROM Railway_Booking
WHERE train_no = 12038
AND journey_date = '2026-05-20';

-- 8. Create Composite Index
CREATE INDEX idx_train_date
ON Railway_Booking(train_no, journey_date);

ANALYZE TABLE Railway_Booking;

SHOW INDEX FROM Railway_Booking;

-- 9. Test Queries After Composite Index
EXPLAIN
SELECT * FROM Railway_Booking
WHERE train_no = 12038
AND journey_date = '2026-05-20';

EXPLAIN ANALYZE
SELECT * FROM Railway_Booking
WHERE train_no = 12038
AND journey_date = '2026-05-20';

-- 10. Test the Leftmost-Prefix Rule
EXPLAIN
SELECT * FROM Railway_Booking
WHERE journey_date = '2026-05-20';

EXPLAIN ANALYZE
SELECT * FROM Railway_Booking
WHERE journey_date = '2026-05-20';