# 📊 Power BI Dashboard — Employee Attrition Analysis
## Ravvion Compass AI | Project 19

---

## 🎯 Dashboard Overview

| Property | Value |
|---|---|
| **Project** | 19_Employee_Attrition_Analysis |
| **Dataset** | employee_attrition_raw.csv (1,875 records × 29 columns) |
| **Target** | Attrition (Yes / No) |
| **Dashboard File** | powerbi/attrition_dashboard.pbix |
| **Release** | v1.0 (2026-10-24) |

---

## 📐 1. Data Model Design

### Tables (Import Mode)

| Table Name | Source Column | Type |
|---|---|---|
| `DimEmployee` | Employee_ID, Full_Name, Gender, Age, Marital_Status, Education_Level, Education_Field, Age_Group | Dimension |
| `DimDepartment` | Department, Job_Role, Business_Unit, Job_Satisfaction_1to5, EnvironmentSatisfaction, WorkLifeBalance | Dimension |
| `DimCompensation` | Monthly_Salary_USD, Salary_Band, Bonus_Pct_of_Salary | Dimension |
| `DimEngagement` | Tenure_Years, Years_In_Role, Num_Companies_Worked, Remote_Days_per_Week, Travel_Frequency, Training_Hours_LastYear, Absence_Days | Dimension |
| `FactAttrition` | Attrition, Attrition_Date, Exit_Reason, Job_Role, Department, Monthly_Salary_USD | Fact |

### Relationships

```
DimEmployee ────< FactAttrition
DimDepartment ────< FactAttrition
DimCompensation ────< FactAttrition
```

---

## 📊 2. DAX Measures

### KPI Measures

```dax
// Overall Attrition Rate
Attrition Rate = 
VAR TotalEmployees = COUNTROWS('FactAttrition')
VAR Attrited = 
    COUNTROWS(
        FILTER(
            'FactAttrition',
            UPPER('FactAttrition'[Attrition]) = "YES"
        )
    )
RETURN
    DIVIDE(Attrited, TotalEmployees)

// Attrition Rate by Department
Attrition Rate % = 
VAR TotalInDept = CALCULATE(COUNTROWS('FactAttrition'), ALLEXCEPT('FactAttrition', 'DimDepartment'[Department]))
VAR AttritedInDept = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        FILTER(
            ALL('DimDepartment'),
            UPPER('FactAttrition'[Attrition]) = "YES"
        )
    )
RETURN
    DIVIDE(AttritedInDept, TotalInDept)
```

```dax
// Average Salary
Average Salary = AVERAGE('FactAttrition'[Monthly_Salary_USD])

// Average Tenure
Avg Tenure = AVERAGE('FactAttrition'[Tenure_Years])

// High Performers % 
High Performers % = 
VAR Total = COUNTROWS('FactAttrition')
VAR HighPerf = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        'FactAttrition'[Job_Satisfaction_1to5] >= 4
    )
RETURN
    DIVIDE(HighPerf, Total)

// Overtime Impact
Overtime Attrition Rate = 
VAR Total = COUNTROWS('FactAttrition')
VAR OvertimeYes = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        'FactAttrition'[OverTime] = "Yes",
        UPPER('FactAttrition'[Attrition]) = "YES"
    )
RETURN
    DIVIDE(OvertimeYes, Total)
```

```dax
// Top K Department by Attrition
Top Attrition Dept = 
VAR TopDept = 
    TOPN(
        1,
        SUMMARIZE('DimDepartment', 'DimDepartment'[Department], 'DimDepartment'[Attrition]),
        [Attrition Rate],
        DESC
    )
RETURN
    SELECTCOLUMNS(TopDept, "Department", 'DimDepartment'[Department])
```

```dax
// Salary Band Attrition
Salary Band Attrition = 
VAR Total = COUNTROWS('FactAttrition')
VAR LowSalary = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        'FactAttrition'[Salary_Band] = "<5k",
        UPPER('FactAttrition'[Attrition]) = "YES"
    )
RETURN
    DIVIDE(LowSalary, Total)
```

```dax
// Satisfaction vs Attrition
Satisfaction Attrition Rate = 
VAR Total = COUNTROWS('FactAttrition')
VAR HighSatisfaction = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        'FactAttrition'[Job_Satisfaction_1to5] >= 4,
        UPPER('FactAttrition'[Attrition]) = "YES"
    )
RETURN
    DIVIDE(HighSatisfaction, Total)

```

```dax
// Tenure Cohort Analysis
Tenure Cohort = 
VAR Tenure = SELECTEDVALUE('FactAttrition'[Tenure_Years])
VAR Bucket = 
    IF(Tenure < 2, "0-2 Years",
    IF(Tenure < 5, "2-5 Years",
    IF(Tenure < 10, "5-10 Years",
    "10+ Years")))
RETURN
    Bucket

// Tenure Cohort Attrition Rate
Tenure Cohort Attrition Rate = 
VAR TotalInCohort = CALCULATE(COUNTROWS('FactAttrition'), ALLEXCEPT('FactAttrition', 'DimEmployee'[Tenure_Cohort]))
VAR AttritedInCohort = 
    CALCULATE(
        COUNTROWS('FactAttrition'),
        FILTER(
            ALL('DimEmployee'),
            UPPER('FactAttrition'[Attrition]) = "YES"
        )
    )
RETURN
    DIVIDE(AttritedInCohort, TotalInCohort)
```

---

## 🎨 3. Dashboard Visual Layout (Professional Design)

### Layout: Top-to-Bottom with 3 Zones

```
┌──────────────────────────────────────────────────────────────┐
│  📄 Ravvion Compass | Employee Attrition Dashboard           │
│  🕐 Last Updated: 2026-10-24 | 📊 Source: employee_attrition_raw.csv │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  [KPI Card 1]  Overall Attrition Rate   [KPI Card 2]  Total Employees │
│  [KPI Card 3]  Avg Monthly Salary       [KPI Card 4]  Avg Tenure       │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│  📊 Department-wise Attrition Rate      💰 Salary by Attrition   │
│  (Clustered Bar Chart)                    (Box Plot)             │
├──────────────────────────────────────────────────────────────┤
│  📈 Job Satisfaction vs Attrition       📅 Tenure vs Attrition   │
│  (Line Chart)                           (Line Chart)             │
├──────────────────────────────────────────────────────────────┤
│  🔍 Filter Slicers: Department | Job Role | Age_Group | Salary_Band │
└──────────────────────────────────────────────────────────────┘
```

### Visual Specifications

| # | Visual | Type | Color Scheme | Interactivity |
|---|---|---|---|---|
| 1 | Overall Attrition Rate | KPI Card | `#E74C3C` (Red) headline, `#2ECC71` (Green) background | Slicer-linked |
| 2 | Total Employees | KPI Card | `#3498DB` (Blue) | — |
| 3 | Average Salary | KPI Card | `#F39C12` (Orange) | — |
| 4 | Department Attrition | Clustered Bar | `#E74C3C`, `#2ECC71` | Slicer-linked |
| 5 | Salary vs Attrition | Box Plot | `#3498DB` | Slicer-linked |
| 6 | Satisfaction vs Attrition | Line Chart | `#E67E22`, `#2ECC71` | Slicer-linked |
| 7 | Tenure vs Attrition | Line Chart | `#E74C3C` | Slicer-linked |
| 8 | Exit Reasons | Stacked Bar | `#9B59B6`, `#3498DB`, `#1ABC9C` | Slicer-linked |
| 9 | Filter Slicers | Slicer | — | Multi-select |

---

## 🛠️ 4. Step-by-Step Build Instructions

### Step 1: Launch Power BI Desktop
Open Power BI Desktop and create a new report.

### Step 2: Get Data
1. Go to **Home** → **Get Data** → **Text/CSV**
2. Select `data/employee_attrition_raw.csv`
3. Click **Load**

### Step 3: Create Tables (if using multiple queries)
1. **Home** → **Manage Relationships** → **New Table**
2. Create:
   - `DimEmployee`
   - `DimDepartment`
   - `DimCompensation`
   - `DimEngagement`
3. Link to main table via `Employee_ID`

### Step 4: Create DAX Measures
1. Go to **View** → **New Table** or create measures in **Modeling** tab
2. Paste DAX measures from Section 2 above
3. All measures will appear in the Fields pane

### Step 5: Build Visuals
1. **Background**: Set to dark gray (`#1C1C1C`) or white for clean look
2. **Title Bar**: Add a title with company branding
3. **Add visuals** in order (Section 3)

### Step 6: Format the Dashboard
1. Set font to **Segoe UI** (professional)
2. Set heading size to 18-20pt
3. Add page background color
4. Set card colors to match brand palette

### Step 7: Add Slicers
1. **Quick Measures** → **Slicer** for:
   - Department
   - Job Role
   - Age Group
   - Salary Band
   - Gender
2. Set slicer to single-select by default

### Step 8: Publish
1. Go to **File** → **Publish**
2. Connect to your workspace
3. Set dashboard name to `attrition_dashboard`

---

## 📈 5. Expected Insights (Pre-built Analytics)

| Insight | Finding | Action |
|---|---|---|
| Overall Attrition | ~10.9% | Monitor monthly trends |
| Highest Risk Dept | Varies | Targeted HR intervention |
| Overtime → Attrition | Higher rate | Reduce overtime or improve compensation |
| Low Satisfaction → Attrition | Higher rate | Engagement programs |
| Low Salary → Attrition | Higher rate | Competitive compensation review |

---

## 🔧 6. Troubleshooting

| Issue | Solution |
|---|---|
| No data in dashboard | Check field names match CSV exactly (case-sensitive) |
| Slicers not filtering visuals | Ensure all visuals use the same table/model |
| DAX errors | Verify table names match your import |
| Attrition rate = 0% | Check if `Attrition` values are all "NO" (case sensitivity) |

---

## 📁 Project Files

| File | Description |
|---|---|
| `data/employee_attrition_raw.csv` | Raw data (1,875 records) |
| `notebooks/01_cleaning_eda.ipynb` | Cleaning & EDA analysis |
| `sql/01_schema.sql` | Database schema |
| `sql/02_analysis_queries.sql` | SQL analysis queries |
| `powerbi/attrition_dashboard.pbix` | Power BI dashboard (build this) |
| `README.md` | Project documentation |

---

## 👤 Author

**Rudra's Thakur** — Python/SQL/PowerBI /AI Researcher
- Date: 2026-10-24
- Project: 19_Employee_Attrition_Analysis
- Portfolio: Ravvion Compass AI
