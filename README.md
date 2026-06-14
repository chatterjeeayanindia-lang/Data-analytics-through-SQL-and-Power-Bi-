# 📦 Supply Chain Analytics — SQL + Python EDA

![Python](https://img.shields.io/badge/Python-3.12-blue?logo=python&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-orange?logo=mysql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-2.x-150458?logo=pandas&logoColor=white)
![Seaborn](https://img.shields.io/badge/Seaborn-Visualization-teal)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?logo=powerbi&logoColor=black)
![Status](https://img.shields.io/badge/Status-Complete-brightgreen)

> An end-to-end data analytics project that connects Python to a MySQL database (`commodities_supply`) and performs structured Exploratory Data Analysis (EDA) across three levels — Univariate, Bivariate, and Multivariate — with business insights and a Power BI dashboard.

---

## 📁 Project Structure

```
supply-chain-eda/
│
├── commodities_supply_EDA.py   # Main EDA script (SQL + Python)
├── README.md                   # Project documentation
│
├── plots/                      # Auto-generated chart outputs
│   ├── 1A_order_status.png
│   ├── 1B_shipping_mode.png
│   ├── 1C_shipping_days.png
│   ├── 1D_top_states.png
│   ├── 1E_payment_type.png
│   ├── 2A_status_vs_shipping.png
│   ├── 2B_real_vs_scheduled.png
│   ├── 2C_state_status_heatmap.png
│   ├── 2D_delay_by_mode.png
│   ├── 2E_payment_vs_status.png
│   ├── 3A_pairplot.png
│   ├── 3B_state_mode_delay.png
│   ├── 3C_multivariate_heatmap.png
│   └── 3D_correlation.png
│
└── dashboard/
    └── telecom_churn_dashboard.pbix   # Power BI dashboard file
```

---

## 🗃️ Database

- **Database**: `commodities_supply` (MySQL 8.0)
- **Tool**: MySQL Workbench

### Tables Used

| Table | Description |
|---|---|
| `orders` | Order transactions with status, city, state, shipping info |
| `orders_items` | Line items per order |
| `customer_info` | Customer demographics and details |
| `product_info` | Product catalogue |
| `price_detail` | Pricing per product/order |
| `category` | Product categories |
| `department` | Department hierarchy |
| `region` | Geographic region mapping |
| `commodities_info` | Commodity-level details |

---

## ⚙️ Setup & Installation

### 1. Clone the repository
```bash
git clone https://github.com/your-username/supply-chain-eda.git
cd supply-chain-eda
```

### 2. Install dependencies
```bash
pip install mysql-connector-python pandas numpy matplotlib seaborn
```

### 3. Configure your MySQL connection
Open `commodities_supply_EDA.py` and update:
```python
conn = mysql.connector.connect(
    host="localhost",
    port=3306,
    user="root",
    password="YOUR_PASSWORD",      # ← change this
    database="commodities_supply"
)
```

### 4. Run the analysis
```bash
python commodities_supply_EDA.py
```
All charts will be saved automatically as `.png` files.

---

## 📊 Analysis Overview

### 🔹 Section 1 — Univariate Analysis
Examines each variable in isolation to understand its distribution.

| Chart | Variable | Key Finding |
|---|---|---|
| 1A | Order Status | Most orders are COMPLETE; ON_HOLD orders indicate fulfillment bottlenecks |
| 1B | Shipping Mode | Standard Class dominates — customers prioritize cost over speed |
| 1C | Shipping Days | Real shipping days consistently exceed scheduled days |
| 1D | Order States | Maharashtra, UP & Rajasthan are the top markets |
| 1E | Payment Type | DEBIT and TRANSFER are the most common payment methods |

---

### 🔹 Section 2 — Bivariate Analysis
Examines relationships between pairs of variables.

| Chart | Variables | Key Finding |
|---|---|---|
| 2A | Status × Shipping Mode | Standard Class has highest COMPLETE and PENDING orders |
| 2B | Real vs Scheduled Days | Most orders fall above the on-time line — late delivery is widespread |
| 2C | State × Status Heatmap | High-volume states also carry higher PENDING risk |
| 2D | Shipping Mode × Delay | First Class is most consistent; all modes show positive delay |
| 2E | Payment Type × Status | DEBIT payments correlate with more ON_HOLD orders |

---

### 🔹 Section 3 — Multivariate Analysis
Examines interactions between three or more variables simultaneously.

| Chart | Variables | Key Finding |
|---|---|---|
| 3A | Pairplot (numeric) | Strong correlation between real & scheduled days; delays are systematic |
| 3B | State × Mode × Delay | Rajasthan underperforms across all shipping modes |
| 3C | Status × Payment × Mode | Standard Class + DEBIT = most common but highest risk combination |
| 3D | Correlation Matrix | Real & Scheduled days highly correlated (r ≈ 0.9) |

---

## 💡 Key Business Insights

### Supply Chain (SQL + Python)
- **High-value concentration**: A small percentage of orders account for a large share of total sales — high-value customer segmentation is critical
- **Shipping delays are systemic**: Real shipping days exceed scheduled days across all modes, pointing to supply chain inefficiencies
- **Regional imbalance**: Maharashtra and UP drive volume but also carry high PENDING risk; Rajasthan shows delivery issues across all modes
- **Payment risk**: DEBIT payments have higher ON_HOLD rates — possible payment processing failures
- **Cancellation impact**: Cancelled orders represent significant revenue loss; better stock and order management could recover this

### Telecom Churn (Power BI Dashboard)
- **~27% churn rate** — a major retention challenge
- **Month-to-Month contracts** churn significantly more than annual/2-year contracts
- **Higher monthly charges** correlate with higher churn — value perception is key
- **Electronic Check** users have the highest churn rate among payment methods
- **No technical support** → significantly higher churn — after-sales service drives retention
- **Gender has minimal impact** — churn is driven by service, pricing and contract factors

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **MySQL 8.0** | Database storage and SQL querying |
| **MySQL Workbench** | Database management and export |
| **Python 3.12** | Data analysis and scripting |
| **Pandas** | Data manipulation and aggregation |
| **Matplotlib / Seaborn** | Data visualization |
| **Jupyter Lab** | Interactive development environment |
| **Power BI** | Business intelligence dashboard |

---

## 📈 Power BI Dashboard

The Telecom Customer Churn Dashboard visualizes:
- Overall churn rate and customer segmentation
- Contract type vs churn breakdown
- Monthly charges distribution by churn status
- Payment method churn analysis
- Technical support impact on retention

---

## 🚀 Future Improvements

- [ ] Add SQLAlchemy integration for cleaner pandas compatibility
- [ ] Build a predictive churn model using scikit-learn
- [ ] Automate report generation with scheduled Python scripts
- [ ] Connect Power BI directly to MySQL for live dashboard refresh
- [ ] Add customer lifetime value (CLV) segmentation

---

## 👤 Author

**Ayan**
- 📍 Data Analytics Student
- 🔗 [GitHub](https://github.com/chatterjeeayanindia-lang)
- 💼 [LinkedIn](linkedin.com/in/ayan-chatterjee-80240b214)

---

## 📄 License

This project is for educational and portfolio purposes.

---

> *"Data-driven decision-making has the potential to enhance logistics processes, minimize waste, boost customer satisfaction, and increase profitability."*
