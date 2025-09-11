USE ECommDW2;
GO
-- Row count check
SELECT COUNT(*) AS StagingRows FROM stg.SalesRaw;

-- Nulls in important columns
SELECT
  SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) AS NullCustomerID,
  SUM(CASE WHEN OrderDate IS NULL THEN 1 ELSE 0 END) AS NullOrderDate,
  SUM(CASE WHEN TotalPrice IS NULL THEN 1 ELSE 0 END) AS NullTotalPrice
FROM stg.SalesRaw;

-- Simple sanity check
SELECT TOP 20 CustomerID, ProductName, OrderDate, TotalPrice FROM stg.SalesRaw ORDER BY LoadDT DESC;

