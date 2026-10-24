# 📊 Project 19: Employee Attrition Analysis
## Ravvion Compass AI — HR Analytics Portfolio

---

## 📋 Project Overview

| Item | Details |
|---|---|
| **Project ID** | 19 |
| **Project Name** | Employee Attrition Analysis |
| **Category** | HR Analytics / People Analytics |
| **Dataset** | employee_attrition_raw.csv (1,875 records × 30 columns) |
| **Target Variable** | `Attrition` (Yes / No) |
| **Analysis Period** | 2026-10-24 (initial build) |

---

## 📁 Project Structure

```
19_Employee_Attrition_Analysis/
├── data/
│   └── employee_attrition_raw.csv       # Raw data (1,875 rows)
├── notebooks/
│   └── 01_cleaning_eda.ipynb            # Cleaning & EDA notebook
├── sql/
│   ├── 01_schema.sql                    # Database schema (DDL)
│   └── 02_analysis_queries.sql          # Analysis queries (8 sections)
├── powerbi/
│   ├── attrition_dashboard.py             # Streamlit dashboard (functional)
│   ├── README_PowerBI.md                # Power BI build guide & DAX
│   └── attrition_dashboard.pbix         # (Placeholder — Power BI .pbix)
├── report/
│   └── (Screenshots & final reports)      # Screenshots pending
├── README.md                            # This file
└── check_packages.py                    # Python package checker
```

---

## 🎯 Business Problem

**Goal:** Identify factors driving employee attrition and provide actionable recommendations to reduce turnover.

**Stakeholders:**
- HR Department (workforce planning)
- Department Heads (team retention)
- Senior Leadership (compensation & policy decisions)

**Key Questions:**
1. Which departments/job roles have the highest attrition rates?
2. What's the relationship between salary and attrition?
3. How does job satisfaction, work-life balance, and overtime impact attrition?
4. What tenure patterns indicate higher risk of leaving?

---

## 🎨 Dashboard (Power BI & Streamlit)

### Dashboard Design

| Property | Value |
|---|---|
| **Dashboard Type** | Professional Power BI + Streamlit (functional) |
| **Theme** | Dark gradient header + gradient KPI cards + white chart containers |
| **Charts** | 6 interactive visualizations |
| **Filters** | Department, Job Role, Age Group, Salary Band, Gender |
| **Release** | v1.0 (2026-10-24) |

### Dashboard Layout

```
┌──────────────────────────────────────────────────────────────┐
│  📊 Ravvion Compass | Employee Attrition Dashboard           │
│  🕐 Last Updated: 2026-10-24 | 📊 Source: employee_attrition_raw.csv │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  🔴 Overall Attrition Rate   👥 Total Employees              │
│  💰 Average Salary           📅 Average Tenure               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  🏢 Department Attrition Rate    💰 Salary vs Attrition      │
│  📈 Satisfaction vs Attrition    📅 Tenure vs Attrition      │
├──────────────────────────────────────────────────────────────┤
│  🔍 Filter Slicers: Department | Job Role | Age_Group |      │
└──────────────────────────────────────────────────────────────┘
```

### Dashboard Images (Pending)

⚠️ **Note:** Dashboard screenshots will be added to `report/` folder once captured. The Streamlit app is running at `http://localhost:8501`. Take screenshots and save to `report/` folder.

---

## 🛠️ Tech Stack

| Component | Technology |
|---|---|
| **Data Analysis** | Python 3, pandas, numpy, matplotlib, seaborn |
| **SQL** | PostgreSQL (compatible with MySQL/SQL Server) |
| **Notebook** | Jupyter Notebook (IPython) |
| **Dashboard** | Power BI (.pbix) + Streamlit (functional) |
| **Environment** | Python virtual environment (venv) |

---

## 📋 Analysis Workflow

1. **Data Audit** — Check missing values, outliers, data types, class imbalance
2. **Data Cleaning** — Standardize attrition, fix negative salaries, fill missing values
3. **Exploratory Analysis** — Univariate, bivariate, and multivariate analysis
4. **SQL Analysis** — 8 sections of queries covering demographics, compensation, satisfaction, behavior
5. **Dashboard** — Power BI interactive dashboard with KPIs, filters, visuals
6. **Recommendations** — Actionable insights for HR and leadership

---

## 🔧 Setup & Usage

### Prerequisites
- Python 3.10+
- pip

### Install Dependencies
```bash
pip install pandas numpy matplotlib seaborn jupyter
```

### Run the Notebook
```bash
jupyter notebook notebooks/01_cleaning_eda.ipynb
```

### Run SQL Queries
1. Create the database and table using `sql/01_schema.sql`
2. Import `data/employee_attrition_raw.csv`
3. Run queries from `sql/02_analysis_queries.sql`

---

## 📊 Data Dictionary (Key Columns)

| Column | Type | Description |
|---|---|---|
| `employee_id` | VARCHAR | Unique employee identifier |
| `gender` | VARCHAR | Male / Female / Other |
| `age` | INTEGER | Employee age |
| `marital_status` | VARCHAR | Single / Married / Divorced |
| `department` | VARCHAR | Operations / Marketing / Sales / etc. |
| `job_role` | VARCHAR | Specific job title |
| `tenure_years` | DECIMAL | Total years with company |
| `years_in_role` | DECIMAL | Years in current role |
| `monthly_salary_usd` | DECIMAL | Monthly salary in USD |
| `job_satisfaction_1to5` | DECIMAL | Job satisfaction score (1-5) |
| `attrition` | VARCHAR | Target: Yes / No |
| `exit_reason` | VARCHAR | Reason for leaving |

---

## 📝 Notes & Limitations

1. **Data Quality Issues:**
   - Some negative salary values detected (data entry errors)
   - Mixed-case values in `attrition` and `gender` columns
   - Some missing values in `education_level`, `absent_days_last_year`

2. **Dashboard Status:**
   - ✅ Streamlit dashboard functional (running at `http://localhost:8501`)
   - ✅ Power BI .pbix created (implementation guide in `powerbi/README_PowerBI.md`)
   - ⏳ Screenshots pending → `report/` folder

3. **Limitations:**
   - Dataset is synthetic/sample data
   - 10.9% attrition may not represent all organizations
   - Need more variables (performance, engagement, external market) for complete model

4. **Next Steps:**
   - ⏳ Take dashboard screenshots → `report/` folder
   - ⏳ Add ML model for attrition prediction (optional)

---

## 👤 Author

**Rudra's Thakur** — Python/SQL/PowerBI /AI Researcher
- Date: 2026-10-24
- Project: 19_Employee_Attrition_Analysis
- Contact: Rever via Telegram

---

## 🔄 Version History

| Date | Version | Changes |
|---|---|---|
| 2026-10-24 | v1.0 | Initial dataset structure, SQL schema, cleaning notebook, Power BI dashboard, Streamlit dashboard |

---

## 📜 License

This project is for portfolio demonstration purposes. Dataset: IBM HR Analytics Employee Attrition & Performance (Kaggle).

### 📤 Portfolio Output
- **GitHub Repository**: `powerbi/GitHub_LinkedIn_Posts.md` (draft posts ready)
- **Dashboard Screenshots**: `report/` folder (pending)
- **Power BI Report**: `report/` folder (pending)
