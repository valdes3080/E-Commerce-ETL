-- list created schemas and tables
SELECT s.name AS SchemaName, t.name AS TableName
FROM sys.schemas s
JOIN sys.tables t ON t.schema_id = s.schema_id
WHERE s.name IN ('stg','dw');
