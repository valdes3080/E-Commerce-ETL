/*
  03_create_staging.sql
  Raw landing table for CSV loads. Keep permissive types to avoid load errors.
*/
USE ECommDW;
GO

IF OBJECT_ID('stg.SalesRaw') IS NULL
BEGIN
    CREATE TABLE stg.SalesRaw (
        SourceFileName NVARCHAR(255) NULL,
        CustomerID NVARCHAR(50),
        Gender NVARCHAR(20),
        Region NVARCHAR(50),
        Age INT NULL,
        ProductName NVARCHAR(200),
        Category NVARCHAR(100),
        UnitPrice DECIMAL(10,2) NULL,
        Quantity INT NULL,
        TotalPrice DECIMAL(12,2) NULL,
        ShippingFee DECIMAL(10,2) NULL,
        ShippingStatus NVARCHAR(50),
        OrderDate DATE NULL,
        LoadDT DATETIME2 DEFAULT SYSUTCDATETIME()
    );
END
GO