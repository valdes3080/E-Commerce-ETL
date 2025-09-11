-- Calendar for 2024-01-01 to 2026-12-31 (change start/end as needed)
WITH N AS (
  SELECT TOP (1096) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
  FROM sys.all_objects
),
D AS (
  SELECT DATEADD(day, n, CAST('2023-01-01' AS date)) AS [Date] FROM N
)
INSERT INTO dw.DimDate (DateKey,[Date],[Year],[Quarter],[Month],[MonthName],[Day],IsWeekend)
SELECT CONVERT(int,FORMAT([Date],'yyyyMMdd')),
       [Date],
       DATEPART(year,[Date]),
       DATEPART(quarter,[Date]),
       DATEPART(month,[Date]),
       DATENAME(month,[Date]),
       DATEPART(day,[Date]),
       CASE WHEN DATENAME(weekday,[Date]) IN ('Saturday','Sunday') THEN 1 ELSE 0 END
FROM D
WHERE NOT EXISTS (SELECT 1 FROM dw.DimDate x WHERE x.[Date] = D.[Date]);
GO