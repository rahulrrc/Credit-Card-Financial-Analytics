-- ==============================================================
-- 3. DATA GRAIN & STAGING VALIDATION
-- ==============================================================

USE credit_card_db;

-- 1. Check the total number of rows imported into staging (Should be exactly 10,293 each)
SELECT COUNT(*) AS total_customer_staging_rows FROM staging_customer;
SELECT COUNT(*) AS total_cc_staging_rows FROM staging_credit_card;

-- 2. View top 5 rows to ensure data integrity and proper alignment
SELECT * FROM staging_customer LIMIT 5;
SELECT * FROM staging_credit_card LIMIT 5;

-- 3. Check for unique client counts to verify primary key uniqueness
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT client_num) AS unique_clients
FROM staging_customer;


