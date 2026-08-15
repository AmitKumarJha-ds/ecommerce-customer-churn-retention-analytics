# 📖 Data Dictionary
## E-Commerce Customer Churn Dataset

**Dataset Source:** Kaggle — E-Commerce Customer Churn Analysis
**Total Records:** 5,630 customers  
**Total Columns:** 20  
**File Format:** Excel (.xlsx)  

---

## Column Details

### 🔑 Identifier Columns

| Column | Data Type | Description | Example |
|--------|-----------|-------------|---------|
| CustomerID | Integer | Unique ID for each customer | 50001, 50002 |

---

### 🎯 Target Variable

| Column | Data Type | Description | Values |
|--------|-----------|-------------|--------|
| Churn | Integer | Whether customer churned or not | 1 = Churned, 0 = Retained |

---

### 📅 Tenure & Lifecycle

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| Tenure | Integer | Months customer has been with company | Cohort analysis, lifecycle stages |
| DaySinceLastOrder | Integer | Days since customer's last order | Recency for RFM, engagement level |

---

### 🛒 Purchase Behavior

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| OrderCount | Integer | Total orders in last month | Frequency for RFM |
| OrderAmountHikeFromlastYear | Float | % increase in order value vs last year | Growth signal |
| CouponUsed | Integer | Number of coupons used | Discount sensitivity |
| CashbackAmount | Float | Average cashback amount received | Monetary proxy for RFM |
| PreferedOrderCat | String | Most ordered category | Product preference (Fashion, Grocery, Mobile Phone, Laptop & Accessory, Others) |

---

### 📱 Engagement Metrics

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| HourSpendOnApp | Float | Average hours spent on app per day | Engagement depth |
| NumberOfDeviceRegistered | Integer | Total devices registered on account | Multi-device users |
| PreferredLoginDevice | String | Device most used to login | Mobile Phone / Computer / Phone |

---

### 💳 Payment & Transaction

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| PreferredPaymentMode | String | Most used payment method | Debit Card, Credit Card, UPI, COD, E-wallet, CC |

---

### 📍 Demographics & Location

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| Gender | String | Customer gender | Male / Female |
| MaritalStatus | String | Marital status | Single / Married / Divorced |
| CityTier | Integer | City tier classification | 1 = Metro, 2 = Tier-2, 3 = Tier-3 |
| WarehouseToHome | Float | Distance from warehouse to home (km) | Delivery experience factor |
| NumberOfAddress | Integer | Number of addresses saved | Multi-location users |

---

### 😊 Customer Experience

| Column | Data Type | Description | Business Use |
|--------|-----------|-------------|--------------|
| SatisfactionScore | Integer | Customer satisfaction rating | 1 = Very Unsatisfied, 5 = Very Satisfied |
| Complain | Integer | Complaint raised in last month | 1 = Yes, 0 = No |

---

## 🔍 Data Quality Notes (To Be Verified)

- Some columns may have NULL/missing values (will check in EDA)
- Payment mode may have inconsistent naming (CC vs Credit Card)
- Login device may have similar issue (Phone vs Mobile Phone)
- These will be cleaned in the data preparation step