IF OBJECT_ID('stg.SalesRaw') IS NOT NULL DROP TABLE stg.SalesRaw;
CREATE TABLE stg.SalesRaw (
    [Customer ID]    varchar(50)   NULL,
    [Gender]         varchar(20)   NULL,
    [Region]         varchar(100)  NULL,
    [Age]            decimal(5,2)  NULL,
    [Product Name]   varchar(200)  NULL,
    [Category]       varchar(100)  NULL,
    [Unit Price]     decimal(12,2) NULL,
    [Quantity]       int           NULL,
    [Total Price]    decimal(12,2) NULL,
    [Shipping Fee]   decimal(12,2) NULL,
    [Shipping Status] varchar(50)  NULL,
    [Order Date]     varchar(30)   NULL,   -- land raw; parse later or in data flow
    _FileName        varchar(260)  NULL,
    _LoadDts         datetime2      NOT NULL DEFAULT SYSUTCDATETIME()
);
GO