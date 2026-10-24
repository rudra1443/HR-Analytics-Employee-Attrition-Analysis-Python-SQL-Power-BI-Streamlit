-- ============================================================
-- Project 19: Employee Attrition Analysis
-- File: sql/01_schema.sql
-- Purpose: Database schema (DDL) for Employee Attrition dataset
-- Database: PostgreSQL (compatible with MySQL / SQL Server with minor tweaks)
-- Source: data/employee_attrition_raw.csv (1,875 records)
-- Created: 2026-10-24
-- ============================================================

-- ============================================================
-- Table: employee_attrition
-- Description: Raw employee records with HR attributes, compensation,
--              satisfaction scores, and attrition outcomes
-- ============================================================

CREATE TABLE employee_attrition (
    employee_id          VARCHAR(20)     NOT NULL,   -- Unique employee identifier (e.g., TN11111, TN-11143)
    full_name            VARCHAR(100),               -- Employee full name (nullable in source)
    gender               VARCHAR(10),                -- Male / Female / Other (source has mixed case: M, m, o)
    age                  INTEGER                 NOT NULL,
    marital_status       VARCHAR(20),                -- Single / Married / Divorced
    education_level      VARCHAR(20),                -- High School / Bachelors / Master / PhD (nullable)
    education_field      VARCHAR(30),                -- Business / Finance / Marketing / Engineering / Humanities / Computer Science
    department           VARCHAR(30),                -- Operations / Marketing / Sales / Customer Support / Engineering / HR
    job_role             VARCHAR(50),                -- Specific job title (e.g., Operations Manager, Data Engineer)
    business_unit        VARCHAR(30),                -- Dubai / New York / Berlin / London / Bengaluru / Singapore / Toronto
    age_group            VARCHAR(10),                -- 20-30 / 31-40 / 41-50 / 51-65
    tenure_years         DECIMAL(5,2),               -- Total years with the company
    years_in_role        DECIMAL(5,2),               -- Years in current role
    num_companies_worked INTEGER,                    -- Number of companies worked (0-6)
    monthly_salary_usd   DECIMAL(12,2),              -- Monthly salary in USD (NOTE: may contain negative values = data error)
    salary_band          VARCHAR(10),                -- <5k / 5-8k / 8-12k / >12k
    distance_from_office VARCHAR(15),               -- <5 km / 5-10 km / 10-20 km / >20 km
    travel_frequency     VARCHAR(20),                -- Rarely / No Travel / Frequently
    remote_days_per_week INTEGER,                    -- Days per week working remotely (0-5)
    promotion_last_3yrs  VARCHAR(10),                -- Yes / No
    avg_monthly_overtime_hrs DECIMAL(6,2),           -- Average monthly overtime hours (some records have very high values e.g., 91.0)
    training_hours_last_year INTEGER,                -- Training hours in last year (0-59)
    job_satisfaction_1to5 DECIMAL(3,1),              -- Job satisfaction score (1.0-5.0)
    last_review_score_1to5 DECIMAL(3,1),             -- Last review score (1.0-5.0)
    bonus_pct_of_salary  DECIMAL(5,1),               -- Bonus as % of salary (0.0-19.5)
    absent_days_last_year DECIMAL(4,1),              -- Days absent in last year (nullable)
    attrition            VARCHAR(10),                -- Target: Yes / No (source has mixed case: Yes, No, no, yes — needs standardization)
    attrition_date       DATE,                       -- Date of attrition (nullable for active employees)
    exit_reason          VARCHAR(30)                -- Exit reason if left: Better Offer / Career Growth / Manager Issues / Relocation / Health/Personal / Work-Life Balance / Compensation / Performance (nullable)
);

-- ============================================================
-- Indexes for common analysis queries
-- ============================================================

-- Department-level segmentation
CREATE INDEX idx_emp_attr_department ON employee_attrition(department);

-- Job role analysis
CREATE INDEX idx_emp_attr_job_role ON employee_attrition(job_role);

-- Attrition analysis
CREATE INDEX idx_emp_attr_attrition ON employee_attrition(attrition);

-- Age group benchmarks
CREATE INDEX idx_emp_attr_age_group ON employee_attrition(age_group);

-- Tenure analysis
CREATE INDEX idx_emp_attr_tenure ON employee_attrition(tenure_years);

-- ============================================================
-- Data Quality Notes (for the data audit step)
-- ============================================================

-- 1. gender: source contains 'm', 'f', 'o' (lowercase/other variants) — needs standardization
-- 2. education_level: some NULL values exist
-- 3. monthly_salary_usd: negative values detected (e.g., -6776.0, -8779.0, -10585.0) — flag as data errors
-- 4. absenteeism: NULL values in absent_days_last_year
-- 5. attrition: mixed case ('Yes', 'No', 'no', 'yes') — standardize to uppercase before analysis
-- 6. attrition_date: NULL for employees still active (Attrition = 'No')
-- 7. full_name: some NULL values exist
-- ============================================================
