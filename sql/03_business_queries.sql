-- ============================================================
-- FILE: 03_business_queries.sql
-- PROJECT: Customer Churn & Retention Analytics
-- MYSQL VERSION: 8.0+
-- ============================================================

USE customer_churn_analytics;

-- ============================================================
-- QUERY 1: OVERALL CHURN RATE
-- ============================================================
-- Business question:
-- What percentage of the total customer base has churned?

SELECT
    COUNT(*) AS total_customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) AS retained_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn;

-- Expected insight:
-- Establishes the baseline churn rate for comparison with every segment.


-- ============================================================
-- QUERY 2: CHURN RATE BY GENDER
-- ============================================================
-- Business question:
-- Does customer churn differ between male and female customers?

SELECT
    Gender,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY Gender
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Identifies whether one gender has a materially higher observed churn rate.


-- ============================================================
-- QUERY 3: CHURN RATE BY CITY TIER
-- ============================================================
-- Business question:
-- Which city tier has the highest customer churn?

SELECT
    CityTier,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY CityTier
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Highlights geographic segments that may require targeted retention analysis.


-- ============================================================
-- QUERY 4: CHURN RATE BY MARITAL STATUS
-- ============================================================
-- Business question:
-- How does churn vary across marital-status segments?

SELECT
    MaritalStatus,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY MaritalStatus
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Identifies marital-status segments with comparatively higher churn.


-- ============================================================
-- QUERY 5: CHURN RATE BY PREFERRED PAYMENT MODE
-- ============================================================
-- Business question:
-- Which preferred payment modes are associated with higher churn?

SELECT
    PreferredPaymentMode,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY PreferredPaymentMode
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Highlights payment-preference segments that may deserve UX or payment-flow investigation.


-- ============================================================
-- QUERY 6: CHURN RATE BY PREFERRED ORDER CATEGORY
-- ============================================================
-- Business question:
-- Which preferred order categories have the highest churn?

SELECT
    PreferedOrderCat,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY PreferedOrderCat
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Identifies product-category segments where observed retention is comparatively weak.


-- ============================================================
-- QUERY 7: AVERAGE TENURE — CHURNED VS RETAINED
-- ============================================================
-- Business question:
-- Do churned customers have lower average tenure than retained customers?

SELECT
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END AS customer_status,
    COUNT(*) AS customers,
    ROUND(AVG(Tenure), 2) AS average_tenure_months,
    ROUND(MIN(Tenure), 2) AS minimum_tenure,
    ROUND(MAX(Tenure), 2) AS maximum_tenure
FROM ecommerce_churn
GROUP BY
    CASE
        WHEN Churn = 1 THEN 'Churned'
        ELSE 'Retained'
    END
ORDER BY customer_status;

-- Expected insight:
-- A lower average tenure among churned customers supports an early-lifecycle
-- retention hypothesis.


-- ============================================================
-- QUERY 8: COMPLAINT IMPACT ON CHURN
-- ============================================================
-- Business question:
-- How much higher is churn among customers who have complained?

SELECT
    CASE
        WHEN Complain = 1 THEN 'Complaint'
        ELSE 'No Complaint'
    END AS complaint_status,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY
    CASE
        WHEN Complain = 1 THEN 'Complaint'
        ELSE 'No Complaint'
    END
ORDER BY churn_rate_pct DESC;

-- Expected insight:
-- Quantifies whether customers who complain are a materially higher-risk group.


-- ============================================================
-- QUERY 9: TOP 10 HIGHEST-VALUE CUSTOMERS WHO CHURNED
-- ============================================================
-- Business question:
-- Which high-value customers have already churned?

SELECT
    CustomerID,
    CashbackAmount,
    Tenure,
    OrderCount,
    SatisfactionScore,
    RANK() OVER (
        ORDER BY CashbackAmount DESC
    ) AS value_rank
FROM ecommerce_churn
WHERE Churn = 1
ORDER BY CashbackAmount DESC
LIMIT 10;

-- Expected insight:
-- Creates a practical recovery list and demonstrates the RANK() window function.


-- ============================================================
-- QUERY 10: CHURN BY TENURE GROUP
-- ============================================================
-- Business question:
-- At which customer lifecycle stage is churn highest?

WITH tenure_segments AS (
    SELECT
        CASE
            WHEN Tenure <= 3 THEN 'New (0-3m)'
            WHEN Tenure <= 6 THEN 'Growing (4-6m)'
            WHEN Tenure <= 12 THEN 'Established (7-12m)'
            WHEN Tenure <= 24 THEN 'Mature (13-24m)'
            ELSE 'Loyal (25m+)'
        END AS tenure_group,
        Churn
    FROM ecommerce_churn
)
SELECT
    tenure_group,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM tenure_segments
GROUP BY tenure_group
ORDER BY
    CASE tenure_group
        WHEN 'New (0-3m)' THEN 1
        WHEN 'Growing (4-6m)' THEN 2
        WHEN 'Established (7-12m)' THEN 3
        WHEN 'Mature (13-24m)' THEN 4
        WHEN 'Loyal (25m+)' THEN 5
    END;

-- Expected insight:
-- Shows which lifecycle stage deserves the greatest retention attention.


-- ============================================================
-- QUERY 11: SATISFACTION SCORE VS CHURN RATE
-- ============================================================
-- Business question:
-- How does customer satisfaction relate to observed churn?

SELECT
    SatisfactionScore,
    COUNT(*) AS customers,
    SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS churn_rate_pct
FROM ecommerce_churn
GROUP BY SatisfactionScore
ORDER BY SatisfactionScore;

-- Expected insight:
-- Shows how observed churn varies across satisfaction levels.


-- ============================================================
-- QUERY 12: RUNNING TOTAL OF CHURNED CUSTOMERS BY TENURE
-- ============================================================
-- Business question:
-- How does the cumulative number of churned customers build across tenure?

WITH tenure_churn AS (
    SELECT
        Tenure,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers
    FROM ecommerce_churn
    GROUP BY Tenure
),
running_churn AS (
    SELECT
        Tenure,
        churned_customers,
        SUM(churned_customers) OVER (
            ORDER BY Tenure
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_churned_customers,
        LAG(churned_customers) OVER (
            ORDER BY Tenure
        ) AS previous_tenure_churned
    FROM tenure_churn
)
SELECT
    Tenure,
    churned_customers,
    running_churned_customers,
    previous_tenure_churned,
    ROUND(
        100.0 * running_churned_customers /
        (SELECT COUNT(*) FROM ecommerce_churn),
        2
    ) AS cumulative_churn_pct
FROM running_churn
ORDER BY Tenure;

-- Expected insight:
-- Shows cumulative churn progression and demonstrates SUM OVER and LAG.


-- ============================================================
-- QUERY 13: CTE — CUSTOMER VALUE SEGMENTS AND CHURN
-- ============================================================
-- Business question:
-- Which customer-value segments contain the greatest churn risk?

WITH customer_value AS (
    SELECT
        CustomerID,
        Churn,
        CashbackAmount,
        NTILE(4) OVER (
            ORDER BY CashbackAmount
        ) AS value_quartile
    FROM ecommerce_churn
),
segment_summary AS (
    SELECT
        value_quartile,
        COUNT(*) AS customers,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
        ROUND(
            100.0 * SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END)
            / COUNT(*),
            2
        ) AS churn_rate_pct,
        ROUND(AVG(CashbackAmount), 2) AS avg_value
    FROM customer_value
    GROUP BY value_quartile
),
segment_comparison AS (
    SELECT
        current_segment.value_quartile,
        current_segment.customers,
        current_segment.churn_rate_pct,
        current_segment.avg_value,
        previous_segment.churn_rate_pct AS previous_quartile_churn_rate
    FROM segment_summary AS current_segment
    LEFT JOIN segment_summary AS previous_segment
        ON previous_segment.value_quartile =
           current_segment.value_quartile - 1
)
SELECT
    value_quartile,
    customers,
    ROUND(churn_rate_pct, 2) AS churn_rate_pct,
    avg_value,
    ROUND(
        churn_rate_pct -
        COALESCE(previous_quartile_churn_rate, churn_rate_pct),
        2
    ) AS churn_rate_change_vs_previous_quartile
FROM segment_comparison
ORDER BY value_quartile;

-- Expected insight:
-- Compares adjacent value quartiles and demonstrates CTEs, NTILE,
-- aggregation, and a self-join comparison.


-- ============================================================
-- QUERY 14: CUSTOMER-VALUE AT RISK
-- ============================================================
-- Business question:
-- How much customer monetary-value proxy is associated with churned customers?

WITH value_metrics AS (
    SELECT
        SUM(CashbackAmount) AS total_customer_value,
        SUM(
            CASE
                WHEN Churn = 1 THEN CashbackAmount
                ELSE 0
            END
        ) AS churned_customer_value
    FROM ecommerce_churn
)
SELECT
    ROUND(total_customer_value, 2)
        AS total_customer_value_proxy,
    ROUND(churned_customer_value, 2)
        AS value_associated_with_churn,
    ROUND(
        100.0 * churned_customer_value /
        NULLIF(total_customer_value, 0),
        2
    ) AS value_at_risk_pct,
    ROUND(churned_customer_value * 0.05, 2)
        AS value_protected_if_churn_reduced_5_pct,
    ROUND(churned_customer_value * 0.10, 2)
        AS value_protected_if_churn_reduced_10_pct
FROM value_metrics;

-- Expected insight:
-- Converts churn into a customer-value impact.
-- CashbackAmount is a monetary proxy, not actual company revenue.


-- ============================================================
-- QUERY 15: EXECUTIVE KPI DASHBOARD — ONE QUERY
-- ============================================================
-- Business question:
-- Can management receive the most important churn KPIs from one query?

WITH base_metrics AS (
    SELECT
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn = 1 THEN 1 ELSE 0 END) AS churned_customers,
        SUM(CASE WHEN Churn = 0 THEN 1 ELSE 0 END) AS retained_customers,
        SUM(CashbackAmount) AS total_customer_value,
        SUM(
            CASE
                WHEN Churn = 1 THEN CashbackAmount
                ELSE 0
            END
        ) AS churned_customer_value,
        AVG(
            CASE
                WHEN Churn = 1 THEN Tenure
            END
        ) AS avg_churned_tenure,
        AVG(
            CASE
                WHEN Churn = 0 THEN Tenure
            END
        ) AS avg_retained_tenure
    FROM ecommerce_churn
),
complaint_metrics AS (
    SELECT
        ROUND(
            100.0 * SUM(
                CASE
                    WHEN Complain = 1 AND Churn = 1 THEN 1
                    ELSE 0
                END
            ) / NULLIF(
                SUM(CASE WHEN Complain = 1 THEN 1 ELSE 0 END),
                0
            ),
            2
        ) AS complaint_churn_rate
    FROM ecommerce_churn
)
SELECT
    total_customers,
    churned_customers,
    retained_customers,
    ROUND(
        100.0 * churned_customers /
        NULLIF(total_customers, 0),
        2
    ) AS overall_churn_rate_pct,
    ROUND(total_customer_value, 2)
        AS total_customer_value_proxy,
    ROUND(churned_customer_value, 2)
        AS value_associated_with_churn,
    ROUND(
        100.0 * churned_customer_value /
        NULLIF(total_customer_value, 0),
        2
    ) AS value_at_risk_pct,
    ROUND(avg_churned_tenure, 2)
        AS avg_churned_tenure,
    ROUND(avg_retained_tenure, 2)
        AS avg_retained_tenure,
    ROUND(
        avg_retained_tenure - avg_churned_tenure,
        2
    ) AS tenure_gap_months,
    complaint_churn_rate
FROM base_metrics
CROSS JOIN complaint_metrics;

-- Expected insight:
-- Provides a compact executive view combining customer volume, churn,
-- customer-value exposure, tenure difference, and complaint impact.
