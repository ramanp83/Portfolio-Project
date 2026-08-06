# 📊 Data Analytics & SQL Portfolio Project

A comprehensive data analytics portfolio demonstrating **end-to-end data cleaning**, **SQL-based exploratory data analysis (EDA)**, **data modeling**, and **interactive visualization** using **Microsoft SQL Server** and **Tableau**.

---

## 📂 Repository Structure

```text
.
├── data/
│   ├── raw/                                   # Source datasets
│   └── tableau/                               # Excel files used in Tableau dashboards
├── sql/
│   ├── 01_covid_data_exploration.sql          # SQL Exploratory Data Analysis
│   ├── 02_tableau_queries.sql                 # Queries used to create Tableau datasets
│   └── 03_nashville_housing_cleaning.sql      # Data Cleaning using SQL
├── visualizations/
│   └── covid_data_analysis.twbx                # Tableau Workbook
└── README.md
```

---

# 🦠 Project 1: COVID-19 Global Data Exploration & Tableau Visualization

## 📌 Overview

This project explores global COVID-19 trends using SQL to analyze infections, mortality, vaccination progress, and country-wise statistics. The cleaned and aggregated data is then visualized in Tableau dashboards for interactive analysis.

---

## 🛠️ SQL Concepts Used

### 🔹 Data Exploration
- Filtering and sorting large datasets
- Aggregate Functions (`SUM`, `MAX`, `AVG`)
- Grouping data using `GROUP BY`
- Percentage calculations

### 🔹 Joins
- Inner Join between:
  - `CovidDeaths`
  - `CovidVaccinations`

Joined using:

- Location
- Date

---

### 🔹 Window Functions

Rolling vaccination count using:

```sql
SUM(new_vaccinations)
OVER (
    PARTITION BY location
    ORDER BY date
)
```

---

### 🔹 Common Table Expressions (CTEs)

Used to calculate:

- Rolling People Vaccinated
- Percentage of Population Vaccinated

---

### 🔹 Temporary Tables

Created temporary tables to store intermediate calculations for further analysis.

Example:

```sql
#PercentPopulationVaccinated
```

---

### 🔹 Views

Created reusable SQL View:

```sql
PercentPopulationVaccinated
```

This allows Tableau to connect directly without rewriting complex SQL queries.

---

## 📊 Tableau Dashboards

The SQL queries generate summary datasets exported to Excel, which are then connected to Tableau for visualization.

Dashboard includes:

### 🌍 Global Summary
- Total Cases
- Total Deaths
- Global Death Percentage

---

### ☠️ Death Count by Continent

Compare total COVID deaths across continents.

---

### 📈 Infection Rate Analysis

Displays:

- Highest Infection Count
- Percentage of Population Infected

Country-wise comparison.

---

### 💉 Vaccination Progress

Rolling vaccination trend over time using Window Functions.

---

### 📅 Time-Series Analysis

Track infection and vaccination progress over time.

---

# 🏠 Project 2: Nashville Housing Data Cleaning

## 📌 Overview

This project demonstrates real-world SQL data cleaning techniques using the Nashville Housing dataset.

The goal is to transform messy raw data into a structured, analysis-ready dataset suitable for reporting and visualization.

---

## 🛠️ Data Cleaning Operations

### 📅 Date Standardization

Converted datetime values into SQL `DATE` format.

---

### 🏠 Populate Missing Property Addresses

Filled missing property addresses using self joins based on matching Parcel IDs.

---

### 📍 Address Decomposition

Split addresses into separate columns.

Created:

- Property Address
- Property City
- Owner Address
- Owner City
- Owner State

Used:

- `SUBSTRING()`
- `CHARINDEX()`
- `PARSENAME()`

---

### 🔄 Standardize Categorical Values

Converted:

| Original | Updated |
|----------|---------|
| Y | Yes |
| N | No |

Using SQL `CASE` statements.

---

### 🗑️ Remove Duplicate Records

Used:

```sql
ROW_NUMBER()
OVER(
    PARTITION BY ParcelID,
                 PropertyAddress,
                 SalePrice,
                 LegalReference
    ORDER BY UniqueID
)
```

to identify and remove duplicate rows.

---

### 🧹 Remove Unused Columns

Dropped unnecessary columns after cleaning, including:

- PropertyAddress
- OwnerAddress
- TaxDistrict
- SaleDate

to improve schema quality.

---

# 🛠️ Tech Stack

| Category | Tools |
|----------|-------|
| Database | Microsoft SQL Server (T-SQL) |
| IDE | SQL Server Management Studio (SSMS) |
| Visualization | Tableau Desktop / Tableau Public |
| Data Formats | SQL, Excel (.xlsx), Tableau Workbook (.twb) |
| Version Control | Git & GitHub |

---

# 📚 SQL Skills Demonstrated

- Data Cleaning
- Exploratory Data Analysis (EDA)
- Joins
- Aggregate Functions
- Window Functions
- Common Table Expressions (CTEs)
- Temporary Tables
- Views
- String Functions
- Date Functions
- CASE Statements
- Data Transformation
- Data Modeling

---

# 📷 Dashboard Preview

<img width="1327" height="685" alt="visualizationscovid_dashboard" src="https://github.com/user-attachments/assets/ba73d8d4-9c9c-4ac0-aa71-31d6d4d369d7" />

### Dashboard Highlights

- 📌 **Global KPIs**
  - Total Cases
  - Total Deaths
  - Global Death Percentage

- 🌍 **Geographical Analysis**
  - Interactive world map showing the percentage of population infected by country.
  - Color gradients help identify heavily affected regions.

- 📈 **Continent-wise Death Analysis**
  - Compare total COVID-19 deaths across continents.
  - Quickly identify regions with the highest mortality.

- 📅 **Time-Series Trend Analysis**
  - Visualize the growth in infection percentage over time.
  - Compare trends across multiple countries.

- 🔍 **Interactive Filters**
  - Explore infection rates by country.
  - Dynamic filtering enables deeper analysis.

---

# 🎯 Learning Outcomes

Through this project, I strengthened my skills in:

- Writing optimized SQL queries
- Cleaning messy real-world datasets
- Exploratory Data Analysis (EDA)
- Building reusable SQL Views
- Using Window Functions and CTEs
- Creating Tableau dashboards
- Data storytelling
- GitHub project documentation

---

# 👨‍💻 Author

**Raman Pinate**

Aspiring Data Analyst passionate about SQL, Power BI, Tableau, Python, and turning raw data into meaningful business insights.

- GitHub: https://github.com/ramanp83
- LinkedIn: https://www.linkedin.com/in/raman-pinate-12653223a/

---

## ⭐ If you found this project useful, consider giving it a Star!
