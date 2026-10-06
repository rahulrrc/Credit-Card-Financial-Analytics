-- ==============================================================
-- 1. DATABASE SETUP
-- ==============================================================

-- Create a separate database for the Credit Card Financial Analytics project
CREATE DATABASE IF NOT EXISTS credit_card_db;

-- Select the database so all following tables and queries are created inside it
USE credit_card_db;


-- ==============================================================
-- 2. STAGING TABLES
-- ==============================================================

-- Create staging table for customer demographics
CREATE TABLE staging_customer (
    client_num INT,
    customer_age INT,
    gender VARCHAR(10),
    dependent_count INT,
    education_level VARCHAR(50),
    marital_status VARCHAR(30),
    state_cd VARCHAR(10),
    zipcode INT,
    car_owner VARCHAR(10),
    house_owner VARCHAR(10),
    personal_loan VARCHAR(10),
    contact VARCHAR(30),
    customer_job VARCHAR(50),
    income INT,
    cust_satisfaction_score INT
);

-- Create staging table for credit card transactions and operational metrics
CREATE TABLE staging_credit_card (
    client_num INT,
    card_category VARCHAR(20),
    annual_fees INT,
    activation_30_days INT,
    customer_acq_cost INT,
    week_start_date VARCHAR(20),
    week_num VARCHAR(20),
    qtr VARCHAR(10),
    current_year INT,
    credit_limit DECIMAL(10,2),
    total_revolving_bal INT,
    total_trans_amt INT,
    total_trans_ct INT,
    avg_utilization_ratio DECIMAL(10,3),
    use_chip VARCHAR(20),
    exp_type VARCHAR(50),
    interest_earned DECIMAL(10,3),
    delinquent_acc INT
);
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


-- ==============================================================
-- 4. STAR SCHEMA (DIMENSION & FACT TABLES)
-- ==============================================================

-- Drop tables if they already exist to ensure a clean run
DROP TABLE IF EXISTS fact_credit_card;
DROP TABLE IF EXISTS dim_customer;


-- --------------------------------------------------------------
-- 4.1 CUSTOMER DIMENSION (dim_customer)
-- --------------------------------------------------------------

-- Create the Customer Dimension Table with client_num as Primary Key
CREATE TABLE dim_customer (
    client_num INT PRIMARY KEY,
    customer_age INT,
    gender VARCHAR(10),
    dependent_count INT,
    education_level VARCHAR(50),
    marital_status VARCHAR(30),
    state_cd VARCHAR(10),
    zipcode INT,
    car_owner VARCHAR(10),
    house_owner VARCHAR(10),
    personal_loan VARCHAR(10),
    contact VARCHAR(30),
    customer_job VARCHAR(50),
    income INT,
    cust_satisfaction_score INT
);

-- Insert customer demographic records from the staging table
INSERT INTO dim_customer (
    client_num,
    customer_age,
    gender,
    dependent_count,
    education_level,
    marital_status,
    state_cd,
    zipcode,
    car_owner,
    house_owner,
    personal_loan,
    contact,
    customer_job,
    income,
    cust_satisfaction_score
)
SELECT 
    client_num,
    customer_age,
    gender,
    dependent_count,
    education_level,
    marital_status,
    state_cd,
    zipcode,
    car_owner,
    house_owner,
    personal_loan,
    contact,
    customer_job,
    income,
    cust_satisfaction_score
FROM staging_customer;

-- Check total rows and unique customers in the customer dimension
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT client_num) AS unique_clients
FROM dim_customer;


-- --------------------------------------------------------------
-- 4.2 CREDIT CARD FACT TABLE (fact_credit_card)
-- --------------------------------------------------------------

-- Create the Fact Table linked to dim_customer via Foreign Key
CREATE TABLE fact_credit_card (
    client_num INT PRIMARY KEY,
    card_category VARCHAR(20),
    annual_fees INT,
    activation_30_days INT,
    customer_acq_cost INT,
    week_start_date VARCHAR(20),
    week_num VARCHAR(20),
    qtr VARCHAR(10),
    current_year INT,
    credit_limit DECIMAL(10,2),
    total_revolving_bal INT,
    total_trans_amt INT,
    total_trans_ct INT,
    avg_utilization_ratio DECIMAL(10,3),
    use_chip VARCHAR(20),
    exp_type VARCHAR(50),
    interest_earned DECIMAL(10,3),
    delinquent_acc INT,
    CONSTRAINT fk_customer_fact FOREIGN KEY (client_num) REFERENCES dim_customer(client_num)
);

-- Insert operational and transaction records from the staging table
INSERT INTO fact_credit_card (
    client_num,
    card_category,
    annual_fees,
    activation_30_days,
    customer_acq_cost,
    week_start_date,
    week_num,
    qtr,
    current_year,
    credit_limit,
    total_revolving_bal,
    total_trans_amt,
    total_trans_ct,
    avg_utilization_ratio,
    use_chip,
    exp_type,
    interest_earned,
    delinquent_acc
)
SELECT 
    client_num,
    card_category,
    annual_fees,
    activation_30_days,
    customer_acq_cost,
    week_start_date,
    week_num,
    qtr,
    current_year,
    credit_limit,
    total_revolving_bal,
    total_trans_amt,
    total_trans_ct,
    avg_utilization_ratio,
    use_chip,
    exp_type,
    interest_earned,
    delinquent_acc
FROM staging_credit_card;

-- Check total rows loaded into the fact table
SELECT COUNT(*) AS total_fact_rows FROM fact_credit_card;






-- ==============================================================
-- 5. DATA MODEL VALIDATION
-- ==============================================================

-- Check that every credit card fact row has a matching customer in the dimension table (orphan check)
SELECT COUNT(*) AS unmatched_customers
FROM fact_credit_card f
LEFT JOIN dim_customer d 
    ON f.client_num = d.client_num
WHERE d.client_num IS NULL;

-- Verify referential integrity in reverse (customers without a credit card record)
SELECT COUNT(*) AS customers_without_cards
FROM dim_customer d
LEFT JOIN fact_credit_card f 
    ON d.client_num = f.client_num
WHERE f.client_num IS NULL;

-- Compare record counts across staging, dimension, and fact tables
SELECT 
    (SELECT COUNT(*) FROM staging_customer) AS staging_customer_rows,
    (SELECT COUNT(*) FROM dim_customer) AS dim_customer_rows,
    (SELECT COUNT(*) FROM staging_credit_card) AS staging_cc_rows,
    (SELECT COUNT(*) FROM fact_credit_card) AS fact_cc_rows;
    
    
    
    




-- ==============================================================
-- 6. BUSINESS ANALYSIS
-- ==============================================================


-- --------------------------------------------------------------
-- BUSINESS QUESTION 1
-- What is the overall financial health and delinquency exposure of the portfolio?
-- --------------------------------------------------------------
SELECT 
    COUNT(d.client_num) AS total_customers,
    SUM(f.total_trans_amt) AS total_transaction_volume,
    SUM(f.total_revolving_bal) AS total_revolving_balance,
    ROUND(SUM(f.annual_fees + f.interest_earned), 2) AS total_portfolio_revenue,
    ROUND(SUM(f.delinquent_acc) * 100.0 / COUNT(d.client_num), 2) AS portfolio_delinquency_rate_pct
FROM dim_customer d
INNER JOIN fact_credit_card f 
    ON d.client_num = f.client_num;


-- --------------------------------------------------------------
-- BUSINESS QUESTION 2
-- Which card tiers generate the highest net profit relative to acquisition costs?
-- --------------------------------------------------------------
SELECT 
    f.card_category,
    COUNT(f.client_num) AS card_count,
    ROUND(SUM(f.annual_fees + f.interest_earned), 2) AS gross_revenue,
    SUM(f.customer_acq_cost) AS total_acquisition_cost,
    ROUND(SUM(f.annual_fees + f.interest_earned) - SUM(f.customer_acq_cost), 2) AS net_profit,
    ROUND(SUM(f.annual_fees + f.interest_earned) / NULLIF(SUM(f.customer_acq_cost), 0), 2) AS revenue_to_cac_ratio
FROM fact_credit_card f
GROUP BY f.card_category
ORDER BY gross_revenue DESC;


-- --------------------------------------------------------------
-- BUSINESS QUESTION 3
-- What is the quarterly trajectory of spend and transacting volume?
-- --------------------------------------------------------------
SELECT 
    qtr,
    COUNT(DISTINCT client_num) AS active_cardholders,
    SUM(total_trans_amt) AS total_spend,
    ROUND(AVG(total_trans_amt), 2) AS avg_spend_per_account,
    SUM(total_trans_ct) AS total_transactions
FROM fact_credit_card
GROUP BY qtr
ORDER BY qtr ASC;


-- --------------------------------------------------------------
-- BUSINESS QUESTION 4
-- Which expenditure categories drive the largest transaction volume and average ticket size?
-- --------------------------------------------------------------
SELECT 
    exp_type,
    SUM(total_trans_amt) AS total_expenditure_amt,
    SUM(total_trans_ct) AS total_swipes,
    ROUND(SUM(total_trans_amt) * 1.0 / NULLIF(SUM(total_trans_ct), 0), 2) AS avg_ticket_size,
    ROUND(SUM(total_trans_amt) * 100.0 / (SELECT SUM(total_trans_amt) FROM fact_credit_card), 2) AS spend_share_pct
FROM fact_credit_card
GROUP BY exp_type
ORDER BY total_expenditure_amt DESC;
    
    

-- --------------------------------------------------------------
-- BUSINESS QUESTION 5
-- What proportion of accounts activate within 30 days across acquisition contact channels?
-- --------------------------------------------------------------
SELECT 
    d.contact AS acquisition_contact_channel,
    COUNT(d.client_num) AS total_accounts,
    SUM(f.activation_30_days) AS activated_within_30_days,
    ROUND(SUM(f.activation_30_days) * 100.0 / COUNT(d.client_num), 2) AS activation_rate_pct
FROM dim_customer d
INNER JOIN fact_credit_card f 
    ON d.client_num = f.client_num
GROUP BY d.contact
ORDER BY activation_rate_pct DESC;


-- --------------------------------------------------------------
-- BUSINESS QUESTION 6
-- Which employment and education sectors exhibit the highest delinquency rates?
-- --------------------------------------------------------------
SELECT 
    d.customer_job,
    d.education_level,
    COUNT(d.client_num) AS total_clients,
    SUM(f.delinquent_acc) AS delinquent_clients,
    ROUND(SUM(f.delinquent_acc) * 100.0 / COUNT(d.client_num), 2) AS delinquency_rate_pct,
    SUM(f.total_revolving_bal) AS total_revolving_balance,
    ROUND(AVG(f.total_revolving_bal), 2) AS avg_revolving_balance
FROM dim_customer d
INNER JOIN fact_credit_card f 
    ON d.client_num = f.client_num
GROUP BY d.customer_job, d.education_level
HAVING COUNT(d.client_num) >= 50
ORDER BY delinquency_rate_pct DESC
LIMIT 10;



-- --------------------------------------------------------------
-- BUSINESS QUESTION 7
-- How does credit limit utilization scale across income tiers, and which segment has the highest risk of maxing out their cards?
-- --------------------------------------------------------------
WITH customer_income_tiers AS (
    SELECT 
        d.client_num,
        d.income,
        CASE 
            WHEN d.income < 35000 THEN '1. Low (<35k)'
            WHEN d.income BETWEEN 35000 AND 69999 THEN '2. Mid-Low (35k-70k)'
            WHEN d.income BETWEEN 70000 AND 99999 THEN '3. Middle (70k-100k)'
            WHEN d.income BETWEEN 100000 AND 149999 THEN '4. Upper-Mid (100k-150k)'
            ELSE '5. High (150k+)'
        END AS income_tier,
        f.credit_limit,
        f.avg_utilization_ratio
    FROM dim_customer d
    INNER JOIN fact_credit_card f 
        ON d.client_num = f.client_num
)
SELECT 
    income_tier,
    COUNT(client_num) AS total_customers,
    ROUND(AVG(income), 2) AS avg_income,
    ROUND(AVG(credit_limit), 2) AS avg_credit_limit,
    ROUND(AVG(avg_utilization_ratio) * 100, 2) AS avg_utilization_pct,
    SUM(CASE WHEN avg_utilization_ratio >= 0.80 THEN 1 ELSE 0 END) AS high_utilization_accounts
FROM customer_income_tiers
GROUP BY income_tier
ORDER BY income_tier ASC;



-- --------------------------------------------------------------
-- BUSINESS QUESTION 8
-- How do payment channels (Swipe, Chip, Online) compare in total spend volume, average transaction size, and credit risk?
-- --------------------------------------------------------------
WITH channel_summary AS (
    SELECT 
        use_chip AS payment_channel,
        COUNT(client_num) AS total_accounts,
        SUM(total_trans_amt) AS channel_total_spend,
        ROUND(AVG(total_trans_amt), 2) AS avg_spend_per_account,
        SUM(delinquent_acc) AS delinquent_accounts
    FROM fact_credit_card
    GROUP BY use_chip
)
SELECT 
    payment_channel,
    total_accounts,
    channel_total_spend,
    avg_spend_per_account,
    ROUND(channel_total_spend * 100.0 / SUM(channel_total_spend) OVER (), 2) AS spend_share_pct,
    ROUND(delinquent_accounts * 100.0 / total_accounts, 2) AS delinquency_rate_pct
FROM channel_summary
ORDER BY channel_total_spend DESC;




-- --------------------------------------------------------------
-- BUSINESS QUESTION 9
-- Does customer satisfaction score (CSAT) correlate with revenue generation and transaction volume?
-- --------------------------------------------------------------
SELECT 
    d.cust_satisfaction_score AS csat_score,
    COUNT(d.client_num) AS total_customers,
    ROUND(AVG(f.total_trans_amt), 2) AS avg_annual_spend,
    ROUND(AVG(f.annual_fees + f.interest_earned), 2) AS avg_revenue_per_user,
    ROUND(SUM(f.annual_fees + f.interest_earned), 2) AS total_tier_revenue,
    DENSE_RANK() OVER (ORDER BY ROUND(AVG(f.annual_fees + f.interest_earned), 2) DESC) AS revenue_rank
FROM dim_customer d
INNER JOIN fact_credit_card f 
    ON d.client_num = f.client_num
GROUP BY d.cust_satisfaction_score
ORDER BY csat_score ASC;




-- --------------------------------------------------------------
-- BUSINESS QUESTION 10
-- Pareto 80/20 Analysis: What percentage of cardholders generate 80% of total transaction spend?
-- --------------------------------------------------------------
WITH ranked_spenders AS (
    SELECT 
        client_num,
        total_trans_amt,
        SUM(total_trans_amt) OVER (ORDER BY total_trans_amt DESC) AS running_total_spend,
        SUM(total_trans_amt) OVER () AS total_portfolio_spend
    FROM fact_credit_card
),
pareto_threshold AS (
    SELECT 
        COUNT(client_num) AS high_value_customers
    FROM ranked_spenders
    WHERE running_total_spend <= (total_portfolio_spend * 0.80)
)
SELECT 
    p.high_value_customers,
    (SELECT COUNT(*) FROM fact_credit_card) AS total_portfolio_customers,
    ROUND(p.high_value_customers * 100.0 / (SELECT COUNT(*) FROM fact_credit_card), 2) AS customer_share_pct,
    '80%' AS spend_contribution_target
FROM pareto_threshold p;


