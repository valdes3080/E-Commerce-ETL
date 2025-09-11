-- Speed up date lookups on your staging data
CREATE INDEX IX_StgSalesRaw_OrderDate ON stg.SalesRaw(OrderDate);

-- Speed up fact lookups by DateKey
CREATE INDEX IX_FactSales_DateKey ON dw.FactSales(DateKey);
