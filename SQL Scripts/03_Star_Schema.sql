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