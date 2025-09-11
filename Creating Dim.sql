-- DimDate (calendar)
IF OBJECT_ID('dw.DimDate') IS NOT NULL DROP TABLE dw.DimDate;
CREATE TABLE dw.DimDate (
    DateKey     int         NOT NULL PRIMARY KEY,  -- yyyymmdd
    [Date]      date        NOT NULL,
    [Year]      int         NOT NULL,
    [Quarter]   tinyint     NOT NULL,
    [Month]     tinyint     NOT NULL,
    [MonthName] varchar(9)  NOT NULL,
    [Day]       tinyint     NOT NULL,
    IsWeekend   bit         NOT NULL
);
GO

-- DimCustomer
IF OBJECT_ID('dw.DimCustomer') IS NOT NULL DROP TABLE dw.DimCustomer;
CREATE TABLE dw.DimCustomer (
    CustomerKey      int IDENTITY(1,1) PRIMARY KEY,
    CustomerNaturalId varchar(50)   NOT NULL UNIQUE,
    Gender           varchar(20)    NULL,
    Region           varchar(100)   NULL,
    Age              decimal(5,2)   NULL
);
GO

-- DimProduct
IF OBJECT_ID('dw.DimProduct') IS NOT NULL DROP TABLE dw.DimProduct;
CREATE TABLE dw.DimProduct (
    ProductKey       int IDENTITY(1,1) PRIMARY KEY,
    ProductNaturalId varchar(200)  NOT NULL UNIQUE,   -- using Product Name as natural key
    ProductName      varchar(200)  NOT NULL,
    Category         varchar(100)  NULL
);
GO

-- DimShipStatus (tiny text dimension)
IF OBJECT_ID('dw.DimShipStatus') IS NOT NULL DROP TABLE dw.DimShipStatus;
CREATE TABLE dw.DimShipStatus (
    ShipStatusKey    int IDENTITY(1,1) PRIMARY KEY,
    ShipStatus       varchar(50) NOT NULL UNIQUE
);
GO