# 🧠 Target E-Commerce Data Analysis – Insights Report

### 📊 Project Summary
This project analyzes **Target’s E-Commerce Dataset (100K+ orders)** using **Google BigQuery** and **Standard SQL**.  
Each CSV file was uploaded to a dataset in BigQuery (`customers`, `orders`, `order_items`, `order_reviews`, `payments`, `products`, `sellers`, `geolocation`) and queried to uncover key business insights.

---

## 🗂️ Dataset Overview
| Attribute | Details |
|------------|----------|
| **Platform** | Google BigQuery |
| **Technology** | SQL (BigQuery Standard SQL) |
| **Tables Used** | orders, order_items, order_reviews, customers, geolocation, payments, products, sellers |
| **Period Covered** | September 2016 → October 2018 |
| **Total Orders** | ~100,000+ |

---

## 🕒 1. Order Timeline
- **Earliest Order:** 2016-09-04  
- **Latest Order:** 2018-10-17  
⏳ Total span ≈ **2 years** of e-commerce transactions.

---

## 🌎 2. Customer Distribution by State
| Rank | State | Customers | Observation |
|------|--------|------------|--------------|
| 🥇 1 | São Paulo (SP) | 41,746 | Highest customer base |
| 🥈 2 | Rio de Janeiro (RJ) | 12,852 | Strong second market |
| 🥉 3 | Minas Gerais (MG) | 11,635 | Balanced growth |
| 4 | Rio Grande do Sul (RS) | 5,458 | Southern region hub |
| 5 | Paraná (PR) | 5,103 | Active buyers |

➡️ Top 3 states = **~60% of total customers**, showing strong Southeast Brazil concentration.

---

## 📈 3. Monthly Order Trends
| Year | Trend |
|------|--------|
| 2016 | E-commerce launch phase |
| 2017 | Rapid order growth |
| 2018 | Peak transaction year |

📅 **Highest order months:** May, July, August  
📉 **Lowest:** September, October  

> 🟢 Seasonal mid-year spikes correspond to promotions and sales events.

---

## ☀️ 4. Order Time-of-Day Analysis
| Time Range | Classification | Trend |
|-------------|----------------|--------|
| 13 – 18 hrs | Afternoon | 🟢 Highest activity |
| 10 – 12 hrs | Morning | 🟡 Medium |
| 19 – 23 hrs | Night | 🟠 Moderate |
| 00 – 06 hrs | Dawn | 🔴 Lowest |

🕓 **Insight:** Most customers shop during **afternoons**, likely during breaks or commute times.

---

## 📊 5. Year-on-Year Growth
- Total payment volume increased **~137%** (Jan–Aug 2017 → Jan–Aug 2018)
- Indicates **rapid e-commerce adoption** and increased order value per customer.

---

## 💰 6. Average Price & Freight by State
| State | Avg Price (R$) | Avg Freight (R$) | Notes |
|--------|----------------|------------------|--------|
| SP | 109.65 | 15.15 | High sales, efficient logistics |
| RJ | 125.12 | 20.96 | Higher order value |
| MG | 120.75 | 20.63 | Balanced costs |
| RS | 118.40 | 21.00 | Medium range |
| SC | 122.22 | 22.40 | Slightly higher freight |

🚚 **Observation:** Freight is higher for **remote or less-connected regions** due to transportation distance.

---

## ⏱️ 7. Delivery Performance
- **Avg delivery time:** 24–28 days  
- **Longest delivery times:** Northern states – AP, RR, AM, PA  
- **Delivery vs Estimated:**
  - 65% delivered **before** estimated date  
  - 35% had **minor delays**

📦 **Insight:** Core logistics are efficient, but remote-region delays remain.

---

## 🚚 8. Freight Cost Distribution
| State | Avg Freight | Remark |
|--------|--------------|---------|
| RR | 42.98 | Highest cost |
| PB | 42.72 | Remote area |
| RO | 41.07 | High cost due to distance |
| AC | 40.07 | Northern region |
| PI | 39.14 | Less connected |

---

## 💳 9. Payment Insights
| Metric | Observation |
|---------|--------------|
| **Top Payment Type** | UPI |
| **Most Common Installment Count** | 1 (49,060 orders) |
| **Others** | 2–4 installments moderately used |
| **Rare** | 10–12 installments (high-value orders) |

🪙 **Insight:** Customers trust **digital payments**, preferring full or short-term installments.

---

## 📌 10. Summary of Key Findings
| Domain | Insight |
|--------|----------|
| **Order Growth** | 137% rise from 2017 → 2018 |
| **Top Region** | São Paulo dominates in sales & customers |
| **Shopping Time** | Afternoon hours most active |
| **Freight Pattern** | Low in dense regions, high in north |
| **Delivery Speed** | 24–28 days, often earlier than estimate |
| **Payment Behavior** | 1-installment UPI payments dominate |

---

## ✅ Conclusion
The Target e-commerce data shows:
- Strong growth in online retail adoption.
- Major regional imbalance (South & Southeast dominate).
- Steady digital payment adoption.
- Logistics efficiency improving year by year.

> 📊 These insights can help optimize logistics, target ads by region, and plan seasonal campaigns for higher order conversion.

---

## 🧮 Sample SQL Queries (for reference)

```sql
-- Monthly Orders
SELECT
  EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
  EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
  COUNT(order_id) AS total_orders
FROM `target.orders`
GROUP BY year, month
ORDER BY year, month;

-- Customer Count by State
SELECT customer_state, COUNT(DISTINCT customer_id) AS total_customers
FROM `target.customers`
GROUP BY customer_state
ORDER BY total_customers DESC;

-- Average Delivery Time
SELECT
  AVG(DATE_DIFF(order_delivered_customer_date, order_purchase_timestamp, DAY)) AS avg_delivery_days
FROM `target.orders`
WHERE order_delivered_customer_date IS NOT NULL;
