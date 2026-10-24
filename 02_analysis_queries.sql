-- ============================================================
-- Project 19: Employee Attrition Analysis
-- File: sql/02_analysis_queries.sql
-- Purpose: SQL analysis queries for Employee Attrition dataset
-- Database: PostgreSQL (compatible with MySQL / SQL Server)
-- Created: 2026-10-24
-- ============================================================

-- ============================================================
-- SECTION 1: Basic Data Overview
-- ============================================================

-- Total records count
SELECT 
    COUNT(*) AS total_records,
    COUNT(employee_id) AS valid_employee_ids
FROM employee_attrition;

-- Unique departments
SELECT 
    COUNT(DISTINCT department) AS unique_departments,
    COUNT(DISTINCT job_role) AS unique_job_roles,
    COUNT(DISTINCT business_unit) AS unique_business_units
FROM employee_attrition;

-- Gender distribution
SELECT 
    gender,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM employee_attrition
GROUP BY gender
ORDER BY count DESC;

-- ============================================================
-- SECTION 2: Attrition Analysis (Target Variable)
-- ============================================================

-- Overall attrition rate
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited_employees,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate_percent
FROM employee_attrition;

-- Attrition by gender
SELECT 
    gender,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY gender
ORDER BY attrition_rate DESC;

-- Attrition by department
SELECT 
    department,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY department
ORDER BY attrition_rate DESC;

-- Attrition by job role
SELECT 
    job_role,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY job_role
ORDER BY attrition_rate DESC;

-- ============================================================
-- SECTION 3: Employee Demographics & Tenure
-- ============================================================

-- Age distribution
SELECT 
    age_group,
    COUNT(*) AS total,
    ROUND(AVG(age) , 2) AS avg_age,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY age_group
ORDER BY 
    CASE age_group
        WHEN '20-30' THEN 1
        WHEN '31-40' THEN 2
        WHEN '41-50' THEN 3
        WHEN '51-65' THEN 4
    END;

-- Tenure analysis
SELECT 
    tenure_years,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate,
    ROUND(AVG(tenure_years) , 2) AS avg_tenure,
    ROUND(AVG(years_in_role) , 2) AS avg_years_in_role
FROM employee_attrition
GROUP BY tenure_years
ORDER BY tenure_years;

-- Tenure buckets
SELECT 
    CASE 
        WHEN tenure_years < 2 THEN '0-2 years'
        WHEN tenure_years >= 2 AND tenure_years < 5 THEN '2-5 years'
        WHEN tenure_years >= 5 AND tenure_years < 10 THEN '5-10 years'
        ELSE '10+ years'
    END AS tenure_bucket,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY 
    CASE 
        WHEN tenure_years < 2 THEN '0-2 years'
        WHEN tenure_years >= 2 AND tenure_years < 5 THEN '2-5 years'
        WHEN tenure_years >= 5 AND tenure_years < 10 THEN '5-10 years'
        ELSE '10+ years'
    END
ORDER BY 
    CASE tenure_bucket
        WHEN '0-2 years' THEN 1
        WHEN '2-5 years' THEN 2
        WHEN '5-10 years' THEN 3
        ELSE 4
    END;

-- ============================================================
-- SECTION 4: Compensation Analysis
-- ============================================================

-- Salary distribution by salary band
SELECT 
    salary_band,
    COUNT(*) AS total,
    ROUND(AVG(monthly_salary_usd) , 2) AS avg_salary,
    ROUND(MIN(monthly_salary_usd) , 2) AS min_salary,
    ROUND(MAX(monthly_salary_usd) , 2) AS max_salary,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY salary_band
ORDER BY 
    CASE salary_band
        WHEN '<5k' THEN 1
        WHEN '5-8k' THEN 2
        WHEN '8-12k' THEN 3
        WHEN '>12k' THEN 4
    END;

-- Salary band vs attrition
SELECT 
    salary_band,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY salary_band
ORDER BY 
    CASE salary_band
        WHEN '<5k' THEN 1
        WHEN '5-8k' THEN 2
        WHEN '8-12k' THEN 3
        WHEN '>12k' THEN 4
    END;

-- ============================================================
-- SECTION 5: Satisfaction Metrics
-- ============================================================

-- Job satisfaction vs attrition
SELECT 
    job_satisfaction_1to5,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY job_satisfaction_1to5
ORDER BY job_satisfaction_1to5;

-- Environment satisfaction vs attrition
SELECT 
    environment_satisfaction,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY environment_satisfaction
ORDER BY environment_satisfaction;

-- Work-life balance vs attrition
SELECT 
    work_life_balance,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY work_life_balance
ORDER BY work_life_balance;

-- ============================================================
-- SECTION 6: Behavioral & Engagement Analysis
-- ============================================================

-- Overtime vs attrition
SELECT 
    overtime,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY overtime
ORDER BY 
    CASE overtime
        WHEN 'No' THEN 1
        WHEN 'Yes' THEN 2
    END;

-- Average overtime hours by attrition
SELECT 
    attrition,
    ROUND(AVG(avg_monthly_overtime_hrs), 2) AS avg_overtime_hours,
    ROUND(MIN(avg_monthly_overtime_hrs), 2) AS min_overtime,
    ROUND(MAX(avg_monthly_overtime_hrs), 2) AS max_overtime
FROM employee_attrition
GROUP BY attrition;

-- Promotion in last 3 years vs attrition
SELECT 
    promotion_last_3yrs,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY promotion_last_3yrs;

-- Training hours vs attrition
SELECT 
    training_hours_last_year,
    COUNT(*) AS total,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate,
    ROUND(AVG(training_hours_last_year), 2) AS avg_training_hours
FROM employee_attrition
GROUP BY training_hours_last_year
ORDER BY training_hours_last_year;

-- ============================================================
-- SECTION 7: Advanced Analytics (Window Functions)
-- ============================================================

-- Rolling attrition rate by tenure (3-year window)
SELECT 
    tenure_years,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS attrited,
    ROUND(AVG(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100, 2) AS attrition_rate,
    ROUND(
        SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ) AS attrition_rate_3yr_window,
    ROUND(
        AVG(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100, 
        2
    ) OVER (
        ORDER BY tenure_years 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_attrition_rate_3yr
FROM employee_attrition
GROUP BY tenure_years
ORDER BY tenure_years;

-- Attrition rate by department and job role (cross-tab)
SELECT 
    department,
    job_role,
    COUNT(*) AS total,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS attrition_rate
FROM employee_attrition
GROUP BY department, job_role
HAVING COUNT(*) >= 5
ORDER BY attrition_rate DESC;

-- Competitive comparison: employees who left with "Better Offer"
SELECT 
    exit_reason,
    COUNT(*) AS total_exit,
    ROUND(AVG(monthly_salary_usd), 2) AS avg_leaving_salary,
    ROUND(AVG(tenure_years), 2) AS avg_tenure_at_exit
FROM employee_attrition
WHERE UPPER(exit_reason) = 'BETTER OFFER'
    AND UPPER(attrition) = 'YES'
GROUP BY exit_reason;

-- ============================================================
-- SECTION 8: KPIs Summary
-- ============================================================

SELECT 
    COUNT(*) AS total_employees,
    ROUND(AVG(monthly_salary_usd), 2) AS avg_monthly_salary,
    ROUND(MIN(monthly_salary_usd), 2) AS min_monthly_salary,
    ROUND(MAX(monthly_salary_usd), 2) AS max_monthly_salary,
    ROUND(AVG(tenure_years), 2) AS avg_tenure,
    ROUND(AVG(years_in_role), 2) AS avg_years_in_role,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(AVG(job_satisfaction_1to5), 2) AS avg_job_satisfaction,
    ROUND(AVG(environment_satisfaction), 2) AS avg_environment_satisfaction,
    ROUND(AVG(work_life_balance), 2) AS avg_work_life_balance,
    SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) AS total_attrition,
    ROUND(SUM(CASE WHEN UPPER(attrition) = 'YES' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS overall_attrition_rate
FROM employee_attrition;
