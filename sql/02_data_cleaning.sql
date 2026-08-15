-- ============================================================
-- FILE: 02_data_cleaning.sql
-- PROJECT: Customer Churn & Retention Analytics
-- MYSQL VERSION: 8.0+
-- ============================================================

USE customer_churn_analytics;

-- ============================================================
-- 1. NULL VALUE CHECK
-- ============================================================
-- Business question:
-- Which columns contain missing values before analysis?

SELECT
    SUM(CustomerID IS NULL) AS CustomerID_Nulls,
    SUM(Churn IS NULL) AS Churn_Nulls,
    SUM(Tenure IS NULL) AS Tenure_Nulls,
    SUM(PreferredLoginDevice IS NULL) AS LoginDevice_Nulls,
    SUM(CityTier IS NULL) AS CityTier_Nulls,
    SUM(WarehouseToHome IS NULL) AS WarehouseToHome_Nulls,
    SUM(PreferredPaymentMode IS NULL) AS PaymentMode_Nulls,
    SUM(Gender IS NULL) AS Gender_Nulls,
    SUM(HourSpendOnApp IS NULL) AS HourSpendOnApp_Nulls,
    SUM(NumberOfDeviceRegistered IS NULL) AS Device_Nulls,
    SUM(PreferedOrderCat IS NULL) AS OrderCategory_Nulls,
    SUM(SatisfactionScore IS NULL) AS Satisfaction_Nulls,
    SUM(MaritalStatus IS NULL) AS MaritalStatus_Nulls,
    SUM(NumberOfAddress IS NULL) AS Address_Nulls,
    SUM(Complain IS NULL) AS Complain_Nulls,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS OrderHike_Nulls,
    SUM(CouponUsed IS NULL) AS CouponUsed_Nulls,
    SUM(OrderCount IS NULL) AS OrderCount_Nulls,
    SUM(DaySinceLastOrder IS NULL) AS LastOrder_Nulls,
    SUM(CashbackAmount IS NULL) AS Cashback_Nulls
FROM ecommerce_churn;

-- Show records containing at least one NULL.
SELECT *
FROM ecommerce_churn
WHERE CustomerID IS NULL
   OR Churn IS NULL
   OR Tenure IS NULL
   OR PreferredLoginDevice IS NULL
   OR CityTier IS NULL
   OR WarehouseToHome IS NULL
   OR PreferredPaymentMode IS NULL
   OR Gender IS NULL
   OR HourSpendOnApp IS NULL
   OR NumberOfDeviceRegistered IS NULL
   OR PreferedOrderCat IS NULL
   OR SatisfactionScore IS NULL
   OR MaritalStatus IS NULL
   OR NumberOfAddress IS NULL
   OR Complain IS NULL
   OR OrderAmountHikeFromlastYear IS NULL
   OR CouponUsed IS NULL
   OR OrderCount IS NULL
   OR DaySinceLastOrder IS NULL
   OR CashbackAmount IS NULL;

-- ============================================================
-- 2. DUPLICATE CHECKS
-- ============================================================
-- Business question:
-- Does CustomerID uniquely identify customers?

SELECT
    CustomerID,
    COUNT(*) AS duplicate_count
FROM ecommerce_churn
GROUP BY CustomerID
HAVING COUNT(*) > 1;

-- Check for exact duplicate records.
SELECT
    CustomerID,
    Churn,
    Tenure,
    PreferredLoginDevice,
    CityTier,
    PreferredPaymentMode,
    Gender,
    COUNT(*) AS duplicate_count
FROM ecommerce_churn
GROUP BY
    CustomerID,
    Churn,
    Tenure,
    PreferredLoginDevice,
    CityTier,
    PreferredPaymentMode,
    Gender
HAVING COUNT(*) > 1;

-- OPTIONAL duplicate-removal pattern:
-- Review duplicate records first before executing a DELETE.
--
-- DELETE e1
-- FROM ecommerce_churn e1
-- JOIN ecommerce_churn e2
--   ON e1.CustomerID = e2.CustomerID
--  AND e1.CustomerID IS NOT NULL
--  AND e1.CustomerID > e2.CustomerID;
--
-- For production data, use a staging table plus ROW_NUMBER() to
-- explicitly choose which duplicate record should be retained.

-- ============================================================
-- 3. DATA VALIDATION QUERIES
-- ============================================================
-- Business question:
-- Are categorical flags and numerical values within expected ranges?

-- Churn must be 0 or 1.
SELECT *
FROM ecommerce_churn
WHERE Churn NOT IN (0, 1)
   OR Churn IS NULL;

-- CityTier should be 1, 2, or 3.
SELECT *
FROM ecommerce_churn
WHERE CityTier NOT IN (1, 2, 3)
   OR CityTier IS NULL;

-- SatisfactionScore should be between 1 and 5.
SELECT *
FROM ecommerce_churn
WHERE SatisfactionScore NOT BETWEEN 1 AND 5
   OR SatisfactionScore IS NULL;

-- Complain should be 0 or 1.
SELECT *
FROM ecommerce_churn
WHERE Complain NOT IN (0, 1)
   OR Complain IS NULL;

-- Tenure should not be negative.
SELECT *
FROM ecommerce_churn
WHERE Tenure < 0;

-- Behavioral counts should not be negative.
SELECT *
FROM ecommerce_churn
WHERE OrderCount < 0
   OR CouponUsed < 0
   OR NumberOfDeviceRegistered < 0
   OR NumberOfAddress < 0;

-- Monetary/value fields should not be negative.
SELECT *
FROM ecommerce_churn
WHERE CashbackAmount < 0
   OR WarehouseToHome < 0
   OR HourSpendOnApp < 0;

-- ============================================================
-- 4. FIX NULL VALUES USING MEDIAN
-- ============================================================
-- Business purpose:
-- Replace NULL numerical values with the median of each column.
--
-- MySQL 8.0 does not provide MEDIAN() as a standard aggregate,
-- so each median is calculated using ROW_NUMBER() and COUNT().
--
-- Run the UPDATE statements only after reviewing the NULL checks.

-- ------------------------------------------------------------
-- Tenure median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(Tenure) AS median_value
    FROM (
        SELECT
            Tenure,
            ROW_NUMBER() OVER (ORDER BY Tenure) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE Tenure IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.Tenure = m.median_value
WHERE e.Tenure IS NULL;

-- ------------------------------------------------------------
-- WarehouseToHome median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(WarehouseToHome) AS median_value
    FROM (
        SELECT
            WarehouseToHome,
            ROW_NUMBER() OVER (ORDER BY WarehouseToHome) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE WarehouseToHome IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.WarehouseToHome = m.median_value
WHERE e.WarehouseToHome IS NULL;

-- ------------------------------------------------------------
-- HourSpendOnApp median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(HourSpendOnApp) AS median_value
    FROM (
        SELECT
            HourSpendOnApp,
            ROW_NUMBER() OVER (ORDER BY HourSpendOnApp) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE HourSpendOnApp IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.HourSpendOnApp = m.median_value
WHERE e.HourSpendOnApp IS NULL;

-- ------------------------------------------------------------
-- OrderAmountHikeFromlastYear median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(OrderAmountHikeFromlastYear) AS median_value
    FROM (
        SELECT
            OrderAmountHikeFromlastYear,
            ROW_NUMBER() OVER (ORDER BY OrderAmountHikeFromlastYear) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE OrderAmountHikeFromlastYear IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.OrderAmountHikeFromlastYear = m.median_value
WHERE e.OrderAmountHikeFromlastYear IS NULL;

-- ------------------------------------------------------------
-- CouponUsed median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(CouponUsed) AS median_value
    FROM (
        SELECT
            CouponUsed,
            ROW_NUMBER() OVER (ORDER BY CouponUsed) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE CouponUsed IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.CouponUsed = m.median_value
WHERE e.CouponUsed IS NULL;

-- ------------------------------------------------------------
-- OrderCount median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(OrderCount) AS median_value
    FROM (
        SELECT
            OrderCount,
            ROW_NUMBER() OVER (ORDER BY OrderCount) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE OrderCount IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.OrderCount = m.median_value
WHERE e.OrderCount IS NULL;

-- ------------------------------------------------------------
-- DaySinceLastOrder median
-- ------------------------------------------------------------
UPDATE ecommerce_churn e
JOIN (
    SELECT AVG(DaySinceLastOrder) AS median_value
    FROM (
        SELECT
            DaySinceLastOrder,
            ROW_NUMBER() OVER (ORDER BY DaySinceLastOrder) AS rn,
            COUNT(*) OVER () AS cnt
        FROM ecommerce_churn
        WHERE DaySinceLastOrder IS NOT NULL
    ) ranked
    WHERE rn IN (
        FLOOR((cnt + 1) / 2),
        CEIL((cnt + 1) / 2)
    )
) m
SET e.DaySinceLastOrder = m.median_value
WHERE e.DaySinceLastOrder IS NULL;

-- ============================================================
-- 5. POST-CLEANING VERIFICATION
-- ============================================================
-- Business question:
-- Did the NULL treatment remove the expected missing values?

SELECT
    SUM(Tenure IS NULL) AS Tenure_Nulls,
    SUM(WarehouseToHome IS NULL) AS WarehouseToHome_Nulls,
    SUM(HourSpendOnApp IS NULL) AS HourSpendOnApp_Nulls,
    SUM(OrderAmountHikeFromlastYear IS NULL) AS OrderHike_Nulls,
    SUM(CouponUsed IS NULL) AS CouponUsed_Nulls,
    SUM(OrderCount IS NULL) AS OrderCount_Nulls,
    SUM(DaySinceLastOrder IS NULL) AS LastOrder_Nulls
FROM ecommerce_churn;

-- Final row-count validation.
SELECT COUNT(*) AS final_customer_count
FROM ecommerce_churn;
