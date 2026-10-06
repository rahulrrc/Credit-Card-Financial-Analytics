# Credit-Card-Financial-Analytics
An end-to-end data analytics project evaluating credit card portfolio performance, delinquency risk, and customer behavior using Python, MySQL, and Power BI.

```markdown

### Business Problem
Analyze customer spending behavior, revenue drivers, and delinquency risk for a credit card portfolio, identify the key factors associated with profitability and default, and provide actionable insights to optimize marketing acquisition and mitigate risk.

### Key Result
* **10,293 customers analyzed** → **$57M YTD Portfolio Revenue** and an overall delinquency rate of **6.06%**.
* **Highest-ROI segment**: Platinum and Gold cardholders yield $27.75 and $24.46 in revenue per $1 of acquisition cost, respectively.
* **Highest-risk segment**: Self-employed customers with Doctorate degrees (11.11% delinquency rate) and lower-income brackets operating at ≥80% credit utilization.
* **Full findings and recommendations**: `Credit_Card_Financial_Analytics_Project_Report.docx`.

### Tech Stack

| Stage | Tool |
| :--- | :--- |
| **Data Cleaning & EDA** | Python (Pandas, NumPy) |
| **Data Modeling** | MySQL (Star Schema) |
| **Business Analysis** | SQL |
| **Reporting & Dashboard** | Power BI, MS Word |

### Project Workflow

```text
Raw CSV → Python (clean + deduplicate + format) → Cleaned CSV
        → MySQL (staging → star schema → validation → business questions)
        → Power BI (interactive dual-page executive dashboard)
        → Word report (insights & recommendations)

```

### Folder Structure

```text
├── Data/
│   ├── Raw uncleaned csv/
│   │   ├── customer.csv                       # raw customer demographics
│   │   ├── credit_card.csv                    # raw operational/transaction data
│   │   ├── cust_add.csv                       # incremental raw data batch
│   │   └── cc_add.csv                         # incremental raw data batch
│   ├── cleaned_customer.csv                   # cleaned output from Python
│   └── cleaned_credit_card.csv                # cleaned output from Python
├── SQL Scripts/
│   ├── 01_Database_and_Staging.sql            # database setup & staging table load
│   ├── 02_Staging_Validation.sql              # data grain & import checks
│   ├── 03_Star_Schema.sql                     # dimension & fact tables
│   ├── 04_Data_Model_Validation.sql           # referential integrity checks
│   ├── 05_Business_Analysis.sql               # the 10 deep-dive business questions
│   └── Project Credit Card.sql                # full master script
├── Python/
│   └── Project.ipynb                          # cleaning + exploratory analysis
├── Power BI Dashboard/
│   ├── Credit Card Financial Analytics Dashboard.pbix  # interactive dashboard
│   └── Credit Card Financial Analytics.pdf             # high-res dashboard export
└── Credit_Card_Financial_Analytics_Project_Report.docx # client-facing insights report

```

### Data Model

Star schema built in MySQL: one fact table (`fact_credit_card`) linked to one primary dimension (`dim_customer`).

| Table | Type | Grain / Purpose |
| --- | --- | --- |
| **fact_credit_card** | Fact | One row per customer credit card account — handles limits, transactions, balances, and revenue. FK linked to `dim_customer`. |
| **dim_customer** | Dimension | Demographics, income, job sector, and satisfaction scores. |

### Data Cleaning Summary

* Standardized all inconsistent column headers to clean `snake_case` formats.
* Unioned master data batches with incremental weekly data batches.
* Identified and removed exact duplicate records based on primary key (`client_num`).
* Formatted categorical text columns to strip hidden whitespaces.
* Standardized date columns (`week_start_date`) into consistent `DD-MM-YYYY` string formats for reporting.

### Business Questions Answered

* **What is the overall financial health of the portfolio?** → $57M YTD Revenue, $46M Transaction Volume, 6.06% Delinquency Rate.
* **Which card tiers generate the highest ROI relative to acquisition costs?** → Platinum ($27.75 per $1 CAC) and Gold ($24.46 per $1 CAC) dramatically outperform the high-volume Blue tier ($10.33).
* **Which expenditure categories drive the largest volume?** → "Bills" ($11.16M), "Entertainment" ($7.8M), and "Fuel" ($7.7M).
* **What proportion of accounts activate within 30 days?** → Only 57.5% across the portfolio, highlighting a massive onboarding drop-off.
* **Which employment and education sectors exhibit the highest delinquency rates?** → Self-employed individuals with Doctorates (11.11%) and Uneducated Government workers (9.13%).
* **Does customer satisfaction score (CSAT) correlate with revenue generation?** → Counter-intuitively, yes. The lowest CSAT (1) generated the highest average revenue per user ($1,097.91), indicating distressed customers incurring high interest/fees.
* **What actions can optimize revenue and reduce default?** → See recommendations below.

*(Full queries: `SQL Scripts/05_Business_Analysis.sql`)*

### Recommendations

* **Pivot Acquisition Spend:** Target top-of-funnel marketing dollars toward acquiring premium tier (Gold/Platinum) users due to their 2.5x higher ROI on acquisition costs.
* **Reduce Onboarding Friction:** With 40% of customers failing to activate their cards within 30 days, automated multi-channel "activation nudges" (SMS/Email) must be implemented on Days 7, 14, and 21.
* **Target High-Ticket Segments:** Partner with airlines and hotel chains for co-branded travel rewards, as Travel generates the highest Average Ticket Size ($100.51).
* **Mitigate High-Risk Revenue:** High revenue from heavily dissatisfied (CSAT 1) customers is a short-term gain but a long-term default/churn risk. Implement proactive financial hardship restructuring for these accounts.
* **Tighten Underwriting:** Lower default credit limits for identified high-risk employment cohorts (e.g., self-employed).

### Dashboard

The Power BI dashboard (`Power BI Dashboard/Credit Card Financial Analytics Dashboard.pbix`) provides a dual-page interactive executive view.

* **Page 1 (Transaction Report):** Monitors revenue momentum, expenditure types, acquisition cost efficiency, and utilization methods.
* **Page 2 (Customer Report):** Tracks demographic distributions, income groups, age brackets, and satisfaction metrics.

### How to Reproduce

* **Python:** Open `Python/Project.ipynb`, point it at the `Data/Raw uncleaned csv/` raw csv files, and run all cells. This produces the `cleaned_customer.csv` and `cleaned_credit_card.csv` files.
* **MySQL:** Run `SQL Scripts/Project Credit Card.sql` (or the split `01`–`05` scripts in order) against a MySQL instance to build the database, load the staging tables, build the star schema, and run the business-question queries.
* **Power BI:** Open `Power BI Dashboard/Credit Card Financial Analytics Dashboard.pbix` and refresh the data source to point at your local extracted files or MySQL instance.

### Author

**Rahul M Ramchandani**
Email: rahulramchand505@gmail.com
LinkedIn: Rahul M Ramchandani

```

```
