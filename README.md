# Credit-Card-Financial-Analytics
An end-to-end data analytics project evaluating credit card portfolio performance, delinquency risk, and customer behavior using Python, MySQL, and Power BI.

## Business Problem

Analyze customer spending behavior, revenue drivers, and delinquency risk for a credit card portfolio, identify the key factors associated with profitability and default, and provide actionable insights to optimize marketing acquisition and mitigate risk.

## Key Result

* **10,293 customers analyzed** → **$57M YTD Portfolio Revenue** and **6.06% overall delinquency rate**
* **Highest-ROI segment:** Platinum and Gold cardholders yield $27.75 and $24.46 in revenue per $1 of acquisition cost
* Full findings and recommendations: `Credit_Card_Financial_Analytics_Project_Report.docx`

## Tech Stack

| Stage | Tool |
| :--- | :--- |
| Data Cleaning & EDA | Python (Pandas, NumPy) |
| Data Modeling | MySQL (star schema) |
| Business Analysis | SQL |
| Reporting & Dashboard | Power BI |

## Project Workflow

```text
Raw CSV → Python (clean + explore) → cleaned CSV
        → MySQL (staging → star schema → validation → business questions)
        → Power BI (interactive dashboard)
        → Word report (insights & recommendations)

```

## Folder Structure

```text
├── Data/
│   ├── Raw uncleaned csv/
│   │   ├── cc_add.csv                         # incremental raw data batch
│   │   ├── credit_card.csv                    # raw operational/transaction data
│   │   ├── cust_add.csv                       # incremental raw data batch
│   │   └── customer.csv                       # raw customer demographics
│   ├── cleaned_credit_card.csv                # cleaned output from Python
│   └── cleaned_customer.csv                   # cleaned output from Python
├── Power BI Dashboard/
│   ├── Credit Card Financial Analytics Dashboard.pbix  # interactive Power BI dashboard
│   └── Credit Card Financial Analytics.pdf             # high-res dashboard export
├── Python/
│   └── Project.ipynb                          # cleaning + exploratory analysis
├── SQL Scripts/
│   ├── 01_Database_and_Staging.sql            # database setup & staging table load
│   ├── 02_Staging_Validation.sql              # data grain & import checks
│   ├── 03_Star_Schema.sql                     # dimension & fact tables
│   ├── 04_Data_Model_Validation.sql           # referential integrity checks
│   ├── 05_Business_Analysis.sql               # the 10 deep-dive business questions
│   └── Project Credit Card.sql                # full master script
├── Credit_Card_Financial_Analytics_Project_Report.docx # client-facing insights report
└── README.md

```

## Data Model

Star schema built in MySQL: one fact table (`fact_credit_card`) linked to one primary dimension (`dim_customer`).

| Table | Type | Grain / Purpose |
| --- | --- | --- |
| `fact_credit_card` | Fact | One row per customer credit card account — handles limits, transactions, balances, and revenue. FK linked to `dim_customer`. |
| `dim_customer` | Dimension | Demographics, income, job sector, and satisfaction scores. |

## Data Cleaning Summary

* Standardized all inconsistent column headers to clean `snake_case` formats.
* Unioned master data batches with incremental weekly data batches.
* Identified and removed exact duplicate records based on primary key (`client_num`).
* Formatted categorical text columns to strip hidden whitespaces.
* Standardized date columns (`week_start_date`) into consistent `DD-MM-YYYY` string formats for reporting.

## Business Questions Answered

1. What is the overall financial health of the portfolio? → **$57M YTD Revenue, $46M Transaction Volume, 6.06% Delinquency Rate.**
2. Which card tiers generate the highest ROI relative to acquisition costs? → **Platinum ($27.75 per $1 CAC) and Gold ($24.46 per $1 CAC).**
3. Which expenditure categories drive the largest volume? → **"Bills" ($11.16M), "Entertainment" ($7.8M), and "Fuel" ($7.7M).**
4. What proportion of accounts activate within 30 days? → **Only 57.5% across the portfolio.**
5. Which employment and education sectors exhibit the highest delinquency rates? → **Self-employed with Doctorates (11.11%) and Uneducated Government workers (9.13%).**
6. Does customer satisfaction score (CSAT) correlate with revenue generation? → **Yes, the lowest CSAT (1) generated the highest average revenue per user ($1,097.91).**
7. What actions can optimize revenue and reduce default? → **See recommendations below.**

Full queries: `SQL Scripts/05_Business_Analysis.sql`

## Recommendations

1. Target top-of-funnel marketing dollars toward acquiring premium tier (Gold/Platinum) users due to their 2.5x higher ROI on acquisition costs.
2. Implement automated multi-channel "activation nudges" (SMS/Email) on Days 7, 14, and 21 to capture the 40% of customers failing to activate their cards.
3. Partner with airlines and hotel chains for co-branded travel rewards, as Travel generates the highest Average Ticket Size ($100.51).
4. Implement proactive financial hardship restructuring for heavily dissatisfied (CSAT 1) customers to mitigate long-term default/churn risks.
5. Lower default credit limits and tighten underwriting for identified high-risk employment cohorts (e.g., self-employed).

## Dashboard

The Power BI dashboard (`Power BI Dashboard/Credit Card Financial Analytics Dashboard.pbix`) provides an interactive dual-page executive view of the portfolio. Page 1 monitors revenue momentum, expenditure types, and acquisition cost efficiency. Page 2 tracks demographic distributions, income groups, age brackets, and satisfaction metrics.

## How to Reproduce

1. **Python:** Open `Python/Project.ipynb`, point it at `Data/Raw uncleaned csv/` files, and run all cells. This produces `cleaned_customer.csv` and `cleaned_credit_card.csv`.
2. **MySQL:** Run `SQL Scripts/Project Credit Card.sql` (or the split `01`–`05` scripts in order) against a MySQL instance to build the staging table, star schema, and run the business-question queries.
3. **Power BI:** Open `Power BI Dashboard/Credit Card Financial Analytics Dashboard.pbix` and refresh the data source to point at your local extracted files or MySQL instance.

## Author

* **Rahul M Ramchandani**
* **Email:** rahulramchand505@gmail.com
* **LinkedIn:** [Rahul M Ramchandani https://www.linkedin.com/in/rahul-m-ramchandani/]
