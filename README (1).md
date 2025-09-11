# 📘 README — E-Commerce ETL Data Warehouse

## 📝 Overview
This project builds a small e-commerce sales **data warehouse** from flat-file CSV sources using  
- Microsoft SQL Server (T-SQL)  
- SQL Server Integration Services (SSIS) for ETL  
- SQL Server Reporting Services (SSRS) for reporting  

The system loads raw sales data into a staging schema (`stg`), transforms and cleans it, then loads conformed data into a star schema in the `dw` schema.  

---

## 🪜 Step-by-Step Build Plan

### **Step 1 — Create the database**
- Database name: `ECommDW`
- Recovery model: `SIMPLE` (for dev)
- Uses default `InstanceDefaultDataPath` and `InstanceDefaultLogPath`
- Script: `sql/01_create_database.sql`

```sql
USE master;
DECLARE @dataPath NVARCHAR(4000)=CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(4000));
DECLARE @logPath  NVARCHAR(4000)=CAST(SERVERPROPERTY('InstanceDefaultLogPath') AS NVARCHAR(4000));

EXEC(N'
CREATE DATABASE ECommDW
ON PRIMARY (
    NAME = N''ECommDW_Data'',
    FILENAME = N''' + @dataPath + 'ECommDW_Data.mdf'')
LOG ON (
    NAME = N''ECommDW_Log'',
    FILENAME = N''' + @logPath + 'ECommDW_Log.ldf'')
');
ALTER DATABASE ECommDW SET RECOVERY SIMPLE;
```

---

### **Step 2 — Create schemas**
- `stg`: staging (raw data)
- `dw`: dimensional model
- Script: `sql/02_create_schemas.sql`

```sql
USE ECommDW;
CREATE SCHEMA stg;
CREATE SCHEMA dw;
```

---

### **Step 3 — Create staging table**
- Table: `stg.SalesRaw`
- Accepts raw CSV rows exactly as received
- Script: `sql/03_create_staging.sql`

```sql
CREATE TABLE stg.SalesRaw (
  SourceFileName NVARCHAR(255),
  CustomerID NVARCHAR(50),
  Gender NVARCHAR(20),
  Region NVARCHAR(50),
  Age NVARCHAR(10),
  ProductName NVARCHAR(200),
  Category NVARCHAR(100),
  UnitPrice DECIMAL(10,2),
  Quantity INT,
  TotalPrice DECIMAL(12,2),
  ShippingFee DECIMAL(10,2),
  ShippingStatus NVARCHAR(50),
  OrderDate DATE,
  LoadDT DATETIME2 DEFAULT SYSUTCDATETIME()
);
```

---

### **Step 4 — Create data warehouse tables**
- Script: `sql/04_create_dw_tables.sql`
- **Dimensions**
  - `dw.DimCustomer` — CustomerID (business key)
  - `dw.DimProduct` — ProductName+Category (business key)
  - `dw.DimDate` — DateKey (YYYYMMDD)
- **Fact**
  - `dw.FactSales` — CustomerKey, ProductKey, DateKey, Quantity, Price, Fees, etc.

---

### **Step 5 — Version control (Git)**
- All SQL DDL and docs are versioned in Git.
- Basic repo structure:
```
/ecomm-dw
  /sql
  /docs
  .gitignore
  README.md
```
- Commands:
```bash
git init
git add .
git commit -m "Day 1: initial schema"
git branch -M main
git remote add origin https://github.com/<you>/E-Commerce-ETL.git
git push -u origin main
```

---

### **Step 6 — Create ETL service account**
- Provides **least privilege** credentials for SSIS and SQL Agent jobs.
- Use in OLE DB connection managers.

```sql
CREATE LOGIN etl_service WITH PASSWORD = 'StrongP@ssw0rd';
USE ECommDW;
CREATE USER etl_service FOR LOGIN etl_service;
GRANT SELECT, INSERT ON SCHEMA::stg TO etl_service;
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dw TO etl_service;
```

---

### **Step 7 — Smoke test queries**
Run these after your first SSIS load to staging:

```sql
SELECT COUNT(*) FROM stg.SalesRaw;

SELECT
 SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomers,
 SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NullOrders
FROM stg.SalesRaw;

SELECT TOP 20 * FROM stg.SalesRaw ORDER BY LoadDT DESC;
```

---

### **Step 8 — Optional quick `BULK INSERT` test**
Before SSIS is ready, you can test load the CSV manually:

```sql
BULK INSERT stg.SalesRaw
FROM 'C:\ETL\Data\realistic_e_commerce_sales_data.csv'
WITH (
  FIRSTROW = 2,
  FIELDTERMINATOR = ',',
  ROWTERMINATOR = '0x0d0a',
  CODEPAGE = '65001',
  TABLOCK
);
```

*(Only for dev smoke tests — SSIS will handle real loads.)*

---

### **Step 9 — Add lightweight indexes & constraints**
- Improves join/lookup performance
- Prevents duplicate dimension keys

```sql
CREATE INDEX IX_StgSalesRaw_OrderDate ON stg.SalesRaw(OrderDate);

ALTER TABLE dw.DimCustomer
  ADD CONSTRAINT UQ_DimCustomer_CustomerID UNIQUE (CustomerID);

ALTER TABLE dw.DimProduct
  ADD CONSTRAINT UQ_DimProduct_Name_Category UNIQUE (ProductName, Category);

CREATE INDEX IX_FactSales_DateKey ON dw.FactSales(DateKey);
```

---

### **Step 10 — Document assumptions & decisions**
- Capture these in `README.md` so others (and future you) know:
  - CSV format: UTF-8, comma-delimited, header row at line 1
  - Grain: one fact row per order line (Customer+Product+Date)
  - Surrogate keys on dimensions (INT identity)
  - Null/blank handling rules (Age can be null)
  - ETL uses SSIS → staging, then T-SQL → dimensions/facts
  - Recovery model: SIMPLE in dev
  - Indexes & constraints added for performance and data integrity
  - Validation queries and known expected results
- Commit and tag your baseline:
```bash
git add README.md
git commit -m "Docs: assumptions, build steps, validation"
git tag day10-readme
git push origin main --tags
```

---

## ✅ Validation Checklist
- [ ] `ECommDW` created with `stg` + `dw` schemas
- [ ] `stg.SalesRaw` has rows from CSV
- [ ] Null & data-type checks pass
- [ ] Dimension tables empty and ready
- [ ] Git repo initialized and pushed
- [ ] README explains build & design clearly
