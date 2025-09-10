/*
  04_create_dw_tables.sql
  Star schema skeleton: dimensions and fact. FKs can be added after initial loads.
*/
USE ECommDW;
GO

IF OBJECT_ID('dw.DimCustomer') IS NULL
BEGIN
    CREATE TABLE dw.DimCustomer (
        CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
        CustomerID NVARCHAR(50) NOT NULL,
        Gender NVARCHAR(20),
        Region NVARCHAR(50),
        Age INT NULL,
        EffectiveFrom DATETIME2 NULL,
        EffectiveTo DATETIME2 NULL,
        IsCurrent BIT DEFAULT 1,
        CONSTRAINT UQ_DimCustomer_CustomerID UNIQUE (CustomerID)
    );
END

IF OBJECT_ID('dw.DimProduct') IS NULL
BEGIN
    CREATE TABLE dw.DimProduct (
        ProductKey INT IDENTITY(1,1) PRIMARY KEY,
        ProductName NVARCHAR(200) NOT NULL,
        Category NVARCHAR(100),
        EffectiveFrom DATETIME2 NULL,
        EffectiveTo DATETIME2 NULL,
        IsCurrent BIT DEFAULT 1,
        CONSTRAINT UQ_DimProduct_Name_Category UNIQUE (ProductName, Category)
    );
END

IF OBJECT_ID('dw.DimDate') IS NULL
BEGIN
    CREATE TABLE dw.DimDate (
        DateKey INT PRIMARY KEY, -- YYYYMMDD
        FullDate DATE NOT NULL,
        Year INT,
        Month INT,
        Day INT,
        Quarter INT
    );
END

IF OBJECT_ID('dw.FactSales') IS NULL
BEGIN
    CREATE TABLE dw.FactSales (
        SalesID BIGINT IDENTITY(1,1) PRIMARY KEY,
        CustomerKey INT NULL,
        ProductKey INT NULL,
        DateKey INT NULL,
        Quantity INT,
        UnitPrice DECIMAL(10,2),
        TotalPrice DECIMAL(12,2),
        ShippingFee DECIMAL(10,2),
        ShippingStatus NVARCHAR(50),
        SourceFileName NVARCHAR(255) NULL,
        LoadDT DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END
GO