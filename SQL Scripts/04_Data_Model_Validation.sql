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
    
    
    
    
