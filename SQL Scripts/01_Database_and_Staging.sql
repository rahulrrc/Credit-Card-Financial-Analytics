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
