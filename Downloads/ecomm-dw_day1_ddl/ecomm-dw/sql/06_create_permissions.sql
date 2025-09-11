-- (Run on the server-level: create Login then DB user)
CREATE LOGIN [etl_service] WITH PASSWORD = 'P@ssw0rd';
CREATE USER [etl_service] FOR LOGIN [etl_service];
-- give minimal rights: insert/select/execute on stg and exec rights for load proc
GRANT INSERT, SELECT ON SCHEMA::stg TO [etl_service];
GRANT INSERT, SELECT, UPDATE, DELETE ON SCHEMA::dw TO [etl_service];
-- limit as appropriate for production

