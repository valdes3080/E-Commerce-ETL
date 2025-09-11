IF OBJECT_ID('dw.FactSales') IS NOT NULL DROP TABLE dw.FactSales;
CREATE TABLE dw.FactSales (
    DateKey       int           NOT NULL,
    CustomerKey   int           NOT NULL,
    ProductKey    int           NOT NULL,
    ShipStatusKey int           NOT NULL,
    Quantity      int           NOT NULL,
    UnitPrice     decimal(12,2) NOT NULL,
    TotalPrice    decimal(12,2) NOT NULL,
    ShippingFee   decimal(12,2) NOT NULL,
    CONSTRAINT PK_FactSales PRIMARY KEY (DateKey, CustomerKey, ProductKey, ShipStatusKey),
    CONSTRAINT FK_Fact_Date       FOREIGN KEY (DateKey)       REFERENCES dw.DimDate(DateKey),
    CONSTRAINT FK_Fact_Cust       FOREIGN KEY (CustomerKey)   REFERENCES dw.DimCustomer(CustomerKey),
    CONSTRAINT FK_Fact_Prod       FOREIGN KEY (ProductKey)    REFERENCES dw.DimProduct(ProductKey),
    CONSTRAINT FK_Fact_ShipStatus FOREIGN KEY (ShipStatusKey) REFERENCES dw.DimShipStatus(ShipStatusKey),
    CONSTRAINT CK_Positive CHECK (Quantity >= 0 AND UnitPrice >= 0 AND TotalPrice >= 0 AND ShippingFee >= 0)
);
GO

-- Helpful indexes
CREATE INDEX IX_DimCustomer_Natural ON dw.DimCustomer(CustomerNaturalId);
CREATE INDEX IX_DimProduct_Natural  ON dw.DimProduct(ProductNaturalId);
CREATE INDEX IX_FactSales_Date      ON dw.FactSales(DateKey);
GO