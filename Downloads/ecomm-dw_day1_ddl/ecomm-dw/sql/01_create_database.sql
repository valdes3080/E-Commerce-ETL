/*
  01_create_database.sql
  Creates ECommDW with explicit file paths derived from the instance defaults.
  Rerunnable: drops DB only if you uncomment the DROP line intentionally.
*/

-- -- Optional: uncomment next line if you need to rebuild from scratch
-- -- USE master; IF DB_ID('ECommDW') IS NOT NULL ALTER DATABASE ECommDW SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE ECommDW;
USE master;
GO

DECLARE @dataPath NVARCHAR(4000) = CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS NVARCHAR(4000));
DECLARE @logPath  NVARCHAR(4000) = CAST(SERVERPROPERTY('InstanceDefaultLogPath')  AS NVARCHAR(4000));

IF @dataPath IS NULL OR @logPath IS NULL
BEGIN
    RAISERROR('Instance default data/log paths not found. Run on a SQL Server 2016+ instance or set paths manually.', 16, 1);
    RETURN;
END

DECLARE @sql NVARCHAR(MAX) = N'
CREATE DATABASE ECommDW
ON PRIMARY
(
    NAME = N''ECommDW_Data'',
    FILENAME = N''' + @dataPath + N'ECommDW_Data.mdf'',
    SIZE = 250MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 64MB
)
LOG ON
(
    NAME = N''ECommDW_Log'',
    FILENAME = N''' + @logPath + N'ECommDW_Log.ldf'',
    SIZE = 128MB,
    MAXSIZE = 2048GB,
    FILEGROWTH = 64MB
);';

EXEC(@sql);
GO

ALTER DATABASE ECommDW SET RECOVERY SIMPLE;
GO