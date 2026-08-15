-- ============================================================
-- FILE: 01_database_setup.sql
-- PROJECT: Customer Churn & Retention Analytics
-- MYSQL VERSION: 8.0+
-- ============================================================

CREATE DATABASE IF NOT EXISTS customer_churn_analytics
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE customer_churn_analytics;

-- Create the analytical table.
-- CustomerID is indexed rather than declared UNIQUE so that duplicate
-- records can be detected and cleaned in File 02 before analysis.

CREATE TABLE IF NOT EXISTS ecommerce_churn (
    CustomerID INT NOT NULL,
    Churn TINYINT NULL,
    Tenure INT NULL,
    PreferredLoginDevice VARCHAR(50) NULL,
    CityTier TINYINT NULL,
    WarehouseToHome DECIMAL(10,2) NULL,
    PreferredPaymentMode VARCHAR(50) NULL,
    Gender VARCHAR(20) NULL,
    HourSpendOnApp DECIMAL(10,2) NULL,
    NumberOfDeviceRegistered INT NULL,
    PreferedOrderCat VARCHAR(100) NULL,
    SatisfactionScore TINYINT NULL,
    MaritalStatus VARCHAR(30) NULL,
    NumberOfAddress INT NULL,
    Complain TINYINT NULL,
    OrderAmountHikeFromlastYear DECIMAL(10,2) NULL,
    CouponUsed DECIMAL(10,2) NULL,
    OrderCount DECIMAL(10,2) NULL,
    DaySinceLastOrder DECIMAL(10,2) NULL,
    CashbackAmount DECIMAL(12,2) NULL,

    INDEX idx_customer_id (CustomerID),
    INDEX idx_churn (Churn),
    INDEX idx_tenure (Tenure),
    INDEX idx_citytier (CityTier),
    INDEX idx_gender (Gender),
    INDEX idx_complain (Complain),
    INDEX idx_payment_mode (PreferredPaymentMode),
    INDEX idx_order_category (PreferedOrderCat),
    INDEX idx_satisfaction (SatisfactionScore)
);

-- ============================================================
-- LOAD DATA INSTRUCTION
-- ============================================================
-- Export the cleaned CSV from the Python project first.
-- Update the path below to your local file.
--
-- Example:
--
-- LOAD DATA LOCAL INFILE 'D:/path/to/cleaned_ecommerce_churn.csv'
-- INTO TABLE ecommerce_churn
-- FIELDS TERMINATED BY ','
-- OPTIONALLY ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS;
--
-- If using Windows and LOCAL INFILE is disabled, enable it in the
-- MySQL client/server configuration before running LOAD DATA.
--
-- Verify the imported row count:
--
-- SELECT COUNT(*) AS customer_count
-- FROM ecommerce_churn;

