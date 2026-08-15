# 📊 Business Problem Statement
## E-Commerce Customer Churn & Retention Analytics

---

## 🏢 Business Context

An online e-commerce company has been operating for several years 
and has built a customer base of 5,600+ active shoppers across 
multiple cities in India (Metro, Tier-2, and Tier-3).

However, the leadership team has observed a concerning trend:
**A significant portion of customers stop purchasing after 
a few months, causing revenue leakage and rising customer 
acquisition costs.**

The Marketing Head has raised this concern:

> "We are spending ₹500-800 to acquire each new customer, 
>  but many of them churn within their first year. 
>  We need to understand WHO is leaving, WHY they are leaving, 
>  and WHAT we can do to retain them — before it's too late."

---

## 🎯 The Core Business Problem

**The company is losing customers, but does not know:**

1. **WHO** is most likely to churn (which customer segments)
2. **WHY** they are churning (behavioural signals & root causes)
3. **WHEN** the churn risk is highest (customer lifecycle stage)
4. **HOW MUCH** revenue is at risk if we do nothing
5. **WHAT ACTIONS** the retention team should take first

---

## 📈 Project Objectives

As the Data Analyst on this project, I will:

1. **Measure the Problem**
   - Calculate overall churn rate
   - Quantify revenue at risk in ₹
   - Identify how many high-value customers are churning

2. **Identify Churn Patterns**
   - Segment customers by tenure, city, category preference
   - Find which segments have highest churn rates
   - Analyze cohort retention curves month over month

3. **Find Root Causes**
   - Which behaviours signal churn early?
   - Do complaints, low satisfaction, or long gaps predict churn?
   - Is churn driven by product, payment, or delivery issues?

4. **Deliver Actionable Recommendations**
   - Retention playbook: 3 specific actions for 3 customer segments
   - Prioritize actions by expected revenue impact
   - Provide early warning indicators for future monitoring

---

## 📊 Key Performance Indicators (KPIs)

| KPI | Definition | Why It Matters |
|-----|------------|----------------|
| Churn Rate % | (Churned Customers / Total Customers) × 100 | Overall health metric |
| Retention Rate % | 100 - Churn Rate | Positive framing for teams |
| Avg Customer Tenure | Average months customers stay | Loyalty indicator |
| Complaint-to-Churn Rate | Churn rate among complainers | Service quality signal |
| High-Value Churn Count | Churned customers with high cashback | Revenue impact |
| Revenue at Risk (₹) | Sum of cashback from at-risk customers | Financial urgency |
| Cohort Retention Curve | Retention % by joining month | Lifecycle understanding |

---

## 👥 Stakeholders & Their Needs

| Stakeholder | What They Need From This Analysis |
|-------------|-----------------------------------|
| Marketing Head | Which segments to target for retention campaigns |
| Customer Service Team | Which complaint patterns need urgent attention |
| Product Team | Which product categories drive loyalty vs churn |
| Finance Team | Revenue impact and retention ROI |
| CEO/Leadership | Overall churn trend and strategic direction |

---

## 📦 Expected Deliverables

1. **SQL Analysis File** — 10-12 business questions answered
2. **Python Notebooks** (4 notebooks):
   - Data Cleaning & EDA
   - Cohort Retention Analysis
   - Churn Driver Analysis
   - Revenue at Risk & Recommendations
3. **Power BI Dashboard** — Interactive churn dashboard
4. **Executive PPT** — 10-12 slide presentation
5. **Insights Document** — Key findings with recommendations
6. **Retention Playbook** — 3 actions for 3 customer segments

---

## ⚠️ Assumptions & Limitations

- Dataset represents a snapshot in time (not live streaming data)
- "Churn" is defined as customers who have stopped purchasing
- Revenue is estimated using Cashback Amount as proxy 
  (actual revenue data not available)
- Analysis assumes recent 12-month customer behavior
- Recommendations are based on data patterns; A/B testing 
  needed to validate impact

---

## 🎯 Success Criteria

This project will be considered successful if:

✅ We identify top 3 churn drivers with data backing
✅ We quantify revenue at risk in ₹ terms
✅ We deliver 3 actionable retention recommendations
✅ Dashboard clearly shows churn patterns to non-technical stakeholders
✅ Recommendations can be implemented within 30-60 days