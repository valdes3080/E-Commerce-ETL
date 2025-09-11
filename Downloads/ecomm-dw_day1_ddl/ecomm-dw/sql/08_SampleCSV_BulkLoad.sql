BULK INSERT stg.SalesRaw
FROM 'C:\Users\Tatiana Valdes\Downloads\stg_SalesRaw.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a',
    CODEPAGE = '65001',
    TABLOCK
);


ALTER TABLE stg.SalesRaw
ALTER COLUMN Age NVARCHAR(10) NULL;

UPDATE stg.SalesRaw
SET Age = NULL
WHERE TRY_CONVERT(INT, Age) IS NULL;

