# ECommDW — Day 1 DDL (Version Controlled)

This folder contains **runnable** T-SQL scripts to create the development data warehouse.

## Order of execution
1. `01_create_database.sql` — creates `ECommDW` with file paths based on server defaults and sets SIMPLE recovery.
2. `02_create_schemas.sql` — creates `stg` and `dw` schemas.
3. `03_create_staging.sql` — creates `stg.SalesRaw` for raw CSV loads.
4. `04_create_dw_tables.sql` — creates dimension and fact tables.

> Tip: Re-run scripts safely; they are mostly idempotent (check existence before create).

## How to run

- Open **SSMS**, connect to your instance.
- Run each script in order. The database files will be created at:
  - Data path: `SELECT SERVERPROPERTY('InstanceDefaultDataPath')`
  - Log path:  `SELECT SERVERPROPERTY('InstanceDefaultLogPath')`

## Notes

- The staging table is permissive to avoid load errors.
- Foreign keys on the fact are deferred until after initial loads.
- For production, consider FULL recovery, backups, and stricter permissions.