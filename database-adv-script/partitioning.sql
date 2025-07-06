-- Table Partitioning Implementation for Large Booking Table
-- This file contains SQL commands to implement partitioning on the Booking table

-- Note: In MySQL, we need to drop and recreate the table to add partitioning

-- Step 1: Create a backup of the original Booking table
CREATE TABLE Booking_backup AS SELECT * FROM Booking;


DROP TABLE IF EXISTS Booking;

CREATE TABLE Booking (
    booking_id VARCHAR(36) PRIMARY KEY,
    property_id VARCHAR(36) NOT NULL,
    user_id VARCHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    
    -- Indexes (important for partitioned tables)
    INDEX idx_property_id (property_id),
    INDEX idx_user_id (user_id),
    INDEX idx_start_date (start_date),
    INDEX idx_status (status),
    INDEX idx_created_at (created_at)
)
-- Partition by RANGE on start_date (monthly partitions for better query performance)
PARTITION BY RANGE (YEAR(start_date) * 100 + MONTH(start_date)) (
    -- Historical partitions (2023)
    PARTITION p202301 VALUES LESS THAN (202302),
    PARTITION p202302 VALUES LESS THAN (202303),
    PARTITION p202303 VALUES LESS THAN (202304),
    PARTITION p202304 VALUES LESS THAN (202305),
    PARTITION p202305 VALUES LESS THAN (202306),
    PARTITION p202306 VALUES LESS THAN (202307),
    PARTITION p202307 VALUES LESS THAN (202308),
    PARTITION p202308 VALUES LESS THAN (202309),
    PARTITION p202309 VALUES LESS THAN (202310),
    PARTITION p202310 VALUES LESS THAN (202311),
    PARTITION p202311 VALUES LESS THAN (202312),
    PARTITION p202312 VALUES LESS THAN (202401),
    
    -- Current year partitions (2024)
    PARTITION p202401 VALUES LESS THAN (202402),
    PARTITION p202402 VALUES LESS THAN (202403),
    PARTITION p202403 VALUES LESS THAN (202404),
    PARTITION p202404 VALUES LESS THAN (202405),
    PARTITION p202405 VALUES LESS THAN (202406),
    PARTITION p202406 VALUES LESS THAN (202407),
    PARTITION p202407 VALUES LESS THAN (202408),
    PARTITION p202408 VALUES LESS THAN (202409),
    PARTITION p202409 VALUES LESS THAN (202410),
    PARTITION p202410 VALUES LESS THAN (202411),
    PARTITION p202411 VALUES LESS THAN (202412),
    PARTITION p202412 VALUES LESS THAN (202501),
    
    -- Future partitions (2025)
    PARTITION p202501 VALUES LESS THAN (202502),
    PARTITION p202502 VALUES LESS THAN (202503),
    PARTITION p202503 VALUES LESS THAN (202504),
    PARTITION p202504 VALUES LESS THAN (202505),
    PARTITION p202505 VALUES LESS THAN (202506),
    PARTITION p202506 VALUES LESS THAN (202507),
    PARTITION p202507 VALUES LESS THAN (202508),
    PARTITION p202508 VALUES LESS THAN (202509),
    PARTITION p202509 VALUES LESS THAN (202510),
    PARTITION p202510 VALUES LESS THAN (202511),
    PARTITION p202511 VALUES LESS THAN (202512),
    PARTITION p202512 VALUES LESS THAN (202601),
    
    -- Default partition for any future dates
    PARTITION p_future VALUES LESS THAN MAXVALUE
);

-- Step 4: Restore data from backup
INSERT INTO Booking SELECT * FROM Booking_backup;

-- Test Query 1: Date range query (should use partition pruning)
EXPLAIN PARTITIONS
SELECT COUNT(*), AVG(total_price)
FROM Booking
WHERE start_date >= '2024-06-01' AND start_date < '2024-09-01';

-- Test Query 2: Single month query (should hit only one partition)
EXPLAIN PARTITIONS
SELECT *
FROM Booking
WHERE start_date >= '2024-07-01' AND start_date < '2024-08-01'
ORDER BY start_date;

-- Test Query 3: User booking history with date filter
EXPLAIN PARTITIONS
SELECT b.*, p.name AS property_name
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
WHERE b.user_id = 'user123'
AND b.start_date >= '2024-01-01'
ORDER BY b.start_date DESC;

-- Test Query 4: Revenue analysis by month (should efficiently access specific partitions)
EXPLAIN PARTITIONS
SELECT 
    YEAR(start_date) AS year,
    MONTH(start_date) AS month,
    COUNT(*) AS bookings,
    SUM(total_price) AS revenue
FROM Booking
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01'
GROUP BY YEAR(start_date), MONTH(start_date)
ORDER BY year, month;