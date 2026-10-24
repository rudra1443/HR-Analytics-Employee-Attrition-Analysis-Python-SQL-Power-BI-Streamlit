"""
📊 Employee Attrition Dashboard
Ravvion Compass AI | Project 19
Professional Power BI-style interactive dashboard
Run: streamlit run powerbi/attrition_dashboard.py
"""
import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
from datetime import datetime

# ── Page Configuration ──────────────────────────────────────────────
st.set_page_config(
    page_title="Employee Attrition Dashboard",
    page_icon="📊",
    layout="wide",
    initial_sidebar_state="expanded"
)

# ── Custom CSS (Professional Power BI Style) ──────────────────────
st.markdown("""
<style>
    /* Main container */
    .main {
        padding: 0rem 1rem;
    }
    
    /* Title styling */
    .title-text {
        font-family: 'Segoe UI', 'Arial', sans-serif;
        font-size: 28px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 0.5rem;
    }
    
    .subtitle-text {
        font-family: 'Segoe UI', 'Arial', sans-serif;
        font-size: 14px;
        color: #666;
        margin-bottom: 2rem;
    }
    
    /* KPI cards */
    .kpi-card {
        background: linear-gradient(135deg, #1a1a2e, #16213e);
        border-radius: 10px;
        padding: 1.5rem;
        color: white;
        margin-bottom: 1rem;
        box-shadow: 0 4px 6px rgba(0,0,0,0.1);
    }
    
    .kpi-card.positive {
        background: linear-gradient(135deg, #2ecc71, #27ae60);
        box-shadow: 0 4px 6px rgba(46, 204, 113, 0.2);
    }
    
    .kpi-card.negative {
        background: linear-gradient(135deg, #e74c3c, #c0392b);
        box-shadow: 0 4px 6px rgba(231, 76, 60, 0.2);
    }
    
    .kpi-card.info {
        background: linear-gradient(135deg, #3498db, #2980b9);
        box-shadow: 0 4px 6px rgba(52, 152, 219, 0.2);
    }
    
    .kpi-label {
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        opacity: 0.8;
        margin-bottom: 0.5rem;
    }
    
    .kpi-value {
        font-size: 28px;
        font-weight: 700;
    }
    
    /* Dashboard title bar */
    .dashboard-header {
        background: linear-gradient(135deg, #1a1a2e, #16213e);
        padding: 1rem 2rem;
        border-radius: 8px;
        margin-bottom: 2rem;
    }
    
    /* Table styling */
    .stTable {
        font-size: 14px;
    }
    
    /* Filter panel */
    .stSidebar {
        background: #f8f9fa;
    }
    
    /* Chart containers */
    .chart-container {
        background: white;
        border-radius: 8px;
        padding: 1rem;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    }
    
    /* Stat number */
    .stat-number {
        font-size: 32px;
        font-weight: 700;
        color: #1a1a2e;
    }
    
    /* Responsive */
    @media (max-width: 768px) {
        .title-text {
            font-size: 22px;
        }
        .kpi-value {
            font-size: 22px;
        }
    }
</style>
""", unsafe_allow_html=True)

# ── Load Data ──────────────────────────────────────────────────────
@st.cache_data
def load_data():
    df = pd.read_csv('data/employee_attrition_raw.csv')
    df['Attrition'] = df['Attrition'].str.upper()
    df['Gender'] = df['Gender'].str.upper()
    df['Age_Group'] = pd.cut(df['Age'], bins=[18, 25, 35, 45, 60], labels=['18-25', '26-35', '36-45', '46-60'])
    df['Tenure_Bucket'] = pd.cut(df['Tenure_Years'], bins=[0, 2, 5, 10, 20], labels=['0-2', '2-5', '5-10', '10+'])
    return df

df = load_data()

# Calculate key metrics
total_employees = len(df)
attrition_counts = df['Attrition'].value_counts()
attrition_rate = (attrition_counts.get('YES', 0) / total_employees) * 100
avg_salary = df['Monthly_Salary_USD'].mean()
avg_tenure = df['Tenure_Years'].mean()

# ── Header ─────────────────────────────────────────────────────────
st.markdown("""
<div class="dashboard-header">
    <h1 class="title-text">📊 Employee Attrition Dashboard</h1>
    <p class="subtitle-text">Ravvion Compass AI | Project 19 | HR Analytics | Last Updated: """ + datetime.now().strftime("%Y-%m-%d") + """</p>
</div>
""", unsafe_allow_html=True)

# ── KPI Cards Row 1 ────────────────────────────────────────────────
col1, col2, col3, col4 = st.columns(4)

with col1:
    st.markdown(f"""
    <div class="kpi-card negative">
        <div class="kpi-label">🔴 Overall Attrition Rate</div>
        <div class="kpi-value">{attrition_rate:.2f}%</div>
    </div>
    """, unsafe_allow_html=True)

with col2:
    st.markdown(f"""
    <div class="kpi-card info">
        <div class="kpi-label">👥 Total Employees</div>
        <div class="kpi-value">{total_employees:,}</div>
    </div>
    """, unsafe_allow_html=True)

with col3:
    st.markdown(f"""
    <div class="kpi-card">
        <div class="kpi-label">💰 Average Monthly Salary</div>
        <div class="kpi-value">${avg_salary:,.2f}</div>
    </div>
    """, unsafe_allow_html=True)

with col4:
    st.markdown(f"""
    <div class="kpi-card">
        <div class="kpi-label">📅 Average Tenure</div>
        <div class="kpi-value">{avg_tenure:.2f} Years</div>
    </div>
    """, unsafe_allow_html=True)

# ── Two-column layout for main visuals ─────────────────────────────
col_left, col_right = st.columns(2)

# ── Left Column ────────────────────────────────────────────────────
with col_left:
    st.markdown("### 🏢 Attrition Rate by Department", unsafe_allow_html=True)
    
    dept_attrition = df.groupby('Department')['Attrition'].apply(
        lambda x: (x == 'YES').mean() * 100
    ).sort_values(ascending=False).head(10)
    
    fig1, ax1 = plt.subplots(figsize=(8, 4))
    colors = plt.cm.RdYlGn_r(np.linspace(0.2, 0.8, len(dept_attrition)))
    bars = ax1.barh(dept_attrition.index, dept_attrition.values, color=colors, edgecolor='white')
    ax1.set_title('Attrition Rate by Department (%)', fontsize=14, fontweight='bold')
    ax1.set_xlabel('Attrition Rate (%)')
    ax1.set_xlim(0, 100)
    ax1.invert_yaxis()
    for bar, val in zip(bars, dept_attrition.values):
        ax1.text(val + 1, bar.get_y() + bar.get_height()/2, f'{val:.1f}%', va='center', fontsize=10)
    st.pyplot(fig1)
    plt.close(fig1)
    
    st.markdown("---", unsafe_allow_html=True)
    
    st.markdown("### 💰 Salary Distribution by Attrition", unsafe_allow_html=True)
    
    fig2, ax2 = plt.subplots(figsize=(8, 4))
    sns.boxplot(data=df, x='Attrition', y='Monthly_Salary_USD', palette=['#2ecc71', '#e74c3c'], ax=ax2)
    ax2.set_title('Monthly Salary by Attrition', fontsize=14, fontweight='bold')
    ax2.set_xlabel('Attrition')
    ax2.set_ylabel('Monthly Salary (USD)')
    st.pyplot(fig2)
    plt.close(fig2)

# ── Right Column ───────────────────────────────────────────────────
with col_right:
    st.markdown("### 🎯 Job Satisfaction vs Attrition Rate", unsafe_allow_html=True)
    
    satisfaction_order = [1, 2, 3, 4, 5]
    satisfaction_attrition = df.groupby('Job_Satisfaction_1to5')['Attrition'].apply(
        lambda x: (x == 'YES').mean() * 100
    ).reindex(satisfaction_order)
    
    fig3, ax3 = plt.subplots(figsize=(8, 4))
    colors = plt.cm.RdYlGn_r(np.linspace(0.2, 0.8, len(satisfaction_attrition)))
    bars = ax3.bar(satisfaction_attrition.index.astype(str), satisfaction_attrition.values, color=colors, edgecolor='white')
    ax3.set_title('Job Satisfaction vs Attrition Rate (%)', fontsize=14, fontweight='bold')
    ax3.set_xlabel('Job Satisfaction (1-5)')
    ax3.set_ylabel('Attrition Rate (%)')
    ax3.set_ylim(0, max(satisfaction_attrition.max(), 50))
    for bar, val in zip(bars, satisfaction_attrition.values):
        ax3.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 1, f'{val:.1f}%', ha='center', fontsize=11)
    st.pyplot(fig3)
    plt.close(fig3)
    
    st.markdown("---", unsafe_allow_html=True)
    
    st.markdown("### 📅 Tenure (Years) vs Attrition Rate", unsafe_allow_html=True)
    
    tenure_attrition = df.groupby('Tenure_Years')['Attrition'].apply(
        lambda x: (x == 'YES').mean() * 100
    ).sort_index()
    
    fig4, ax4 = plt.subplots(figsize=(8, 4))
    ax4.plot(tenure_attrrition.index, tenure_attrition.values, marker='o', linewidth=2.5, markersize=8, color='#e74c3c')
    ax4.fill_between(tenure_attrition.index, tenure_attrition.values, alpha=0.3, color='#e74c3c')
    ax4.set_title('Tenure vs Attrition Rate (%)', fontsize=14, fontweight='bold')
    ax4.set_xlabel('Years at Company')
    ax4.set_ylabel('Attrition Rate (%)')
    ax4.set_ylim(0, max(tenure_attrition.max(), 50))
    for x, y in zip(tenure_attrition.index, tenure_attrition.values):
        ax4.text(x, y + 1, f'{y:.1f}%', ha='center', fontsize=10, fontweight='bold')
    st.pyplot(fig4)
    plt.close(fig4)

# ── Bottom Row ─────────────────────────────────────────────────────
col_bottom1, col_bottom2 = st.columns(2)

with col_bottom1:
    st.markdown("### 💼 Top 10 Job Roles by Attrition Rate", unsafe_allow_html=True)
    
    role_attrition = df.groupby('Job_Role')['Attrition'].apply(
        lambda x: (x == 'YES').mean() * 100
    ).sort_values(ascending=False).head(10)
    
    fig5, ax5 = plt.subplots(figsize=(8, 5))
    colors = plt.cm.RdYlGn_r(np.linspace(0.2, 0.8, len(role_attrition)))
    bars = ax5.barh(role_attrition.index, role_attrition.values, color=colors, edgecolor='white')
    ax5.set_title('Top 10 Job Role Attrition Rate (%)', fontsize=14, fontweight='bold')
    ax5.set_xlabel('Attrition Rate (%)')
    ax5.set_xlim(0, 100)
    ax5.invert_yaxis()
    for bar, val in zip(bars, role_attrition.values):
        ax5.text(val + 1, bar.get_y() + bar.get_height()/2, f'{val:.1f}%', va='center', fontsize=9)
    st.pyplot(fig5)
    plt.close(fig5)

with col_bottom2:
    st.markdown("### 🔍 Exit Reasons Analysis", unsafe_allow_html=True)
    
    exit_data = df[df['Attrition'] == 'YES']['Exit_Reason'].value_counts().head(8)
    
    fig6, ax6 = plt.subplots(figsize=(8, 4))
    colors = ['#e74c3c', '#e67e22', '#9b59b6', '#1abc9c', '#3498db', '#2ecc71', '#f39c12', '#95a5a6']
    bars = ax6.bar(range(len(exit_data)), exit_data.values, color=colors[:len(exit_data)], edgecolor='white')
    ax6.set_title('Top 8 Exit Reasons (Attrition)', fontsize=14, fontweight='bold')
    ax6.set_xlabel('Count')
    ax6.set_ylabel('Number of Exits')
    ax6.set_xticks(range(len(exit_data)))
    ax6.set_xticklabels(exit_data.index, rotation=45, ha='right', fontsize=10)
    for bar, val in zip(bars, exit_data.values):
        ax6.text(bar.get_x() + bar.get_width()/2, bar.get_height() + 0.5, str(val), ha='center', fontsize=10, fontweight='bold')
    st.pyplot(fig6)
    plt.close(fig6)

# ── Sidebar Filters ────────────────────────────────────────────────
st.sidebar.title("🔍 Filters")
st.sidebar.markdown("---")

selected_dept = st.sidebar.multiselect("Department", options=df['Department'].unique(), placeholder="Select department")
selected_role = st.sidebar.multiselect("Job Role", options=df['Job_Role'].unique(), placeholder="Select job role")
selected_age = st.sidebar.multiselect("Age Group", options=df['Age_Group'].dropna().unique(), placeholder="Select age group")
selected_band = st.sidebar.multiselect("Salary Band", options=df['Salary_Band'].unique(), placeholder="Select salary band")
selected_gender = st.sidebar.multiselect("Gender", options=df['Gender'].dropna().unique(), placeholder="Select gender")

# Apply filters
filtered_df = df.copy()
if selected_dept:
    filtered_df = filtered_df[filtered_df['Department'].isin(selected_dept)]
if selected_role:
    filtered_df = filtered_df[filtered_df['Job_Role'].isin(selected_role)]
if selected_age:
    filtered_df = filtered_df[filtered_df['Age_Group'].isin(selected_age)]
if selected_band:
    filtered_df = filtered_df[filtered_df['Salary_Band'].isin(selected_band)]
if selected_gender:
    filtered_df = filtered_df[filtered_df['Gender'].isin(selected_gender)]

# ── Filter Summary ─────────────────────────────────────────────────
st.markdown("### 📋 Filter Summary", unsafe_allow_html=True)
col_a, col_b = st.columns(2)

with col_a:
    st.metric("Total Records", f"{len(filtered_df):,}")
    st.metric("Attrition Rate", f"{(filtered_df['Attrition']=='YES').mean()*100:.2f}%")
    st.metric("Avg Salary", f"${filtered_df['Monthly_Salary_USD'].mean():,.2f}")

with col_b:
    st.metric("Departments", f"{filtered_df['Department'].nunique()}")
    st.metric("Job Roles", f"{filtered_df['Job_Role'].nunique()}")
    st.metric("Avg Tenure", f"{filtered_df['Tenure_Years'].mean():.2f} years")

# ── Data Preview ───────────────────────────────────────────────────
st.markdown("### 📋 Sample Data (First 10 rows)")
st.dataframe(filtered_df.head(10), use_container_width=True)

# ── Export Options ─────────────────────────────────────────────────
st.markdown("### 💾 Export")
col1, col2 = st.columns(2)
with col1:
    if st.button("⬇️ Download Filtered Data (CSV)"):
        filtered_df.to_csv('report/filtered_data.csv', index=False)
        st.success("✅ Download started!")
with col2:
    if st.button("⬇️ Download Full Dataset (CSV)"):
        df.to_csv('report/full_data.csv', index=False)
        st.success("✅ Download started!")

# ── Footer ─────────────────────────────────────────────────────────
st.markdown("---")
st.markdown("""
<div style="text-align: center; padding: 1rem; color: #666; font-size: 12px;">
    📊 Ravvion Compass AI | Project 19: Employee Attrition Analysis | 
    Create by: Rudra's Thakur | Python/SQL/PowerBI /AI Researcher
</div>
""", unsafe_allow_html=True)
