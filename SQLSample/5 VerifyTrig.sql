use tempdb
GO

SELECT StockID, StockName, QtyInStock, PricePerKg FROM VStock WHERE StockID = 15

SET IDENTITY_INSERT TStockPurchase ON
INSERT INTO TStockPurchase (PurchaseID, PurchaseDate, StockID, QtyPurchased, PricePerKg, Notes)
	VALUES(99, '2014-10-10', 15, 100, 65, '')
SET IDENTITY_INSERT TStockPurchase OFF
SELECT StockID, StockName, QtyInStock, PricePerKg FROM VStock WHERE StockID = 15

UPDATE TStockPurchase SET QtyPurchased = 200, PricePerKg = 75 WHERE PurchaseID = 99
SELECT StockID, StockName, QtyInStock, PricePerKg FROM VStock WHERE StockID = 15

DELETE FROM TStockPurchase WHERE PurchaseID = 99
SELECT StockID, StockName, QtyInStock, PricePerKg FROM VStock WHERE StockID = 15
