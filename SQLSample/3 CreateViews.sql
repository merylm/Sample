USE tempdb
GO

CREATE VIEW [dbo].[VStock]
AS
SELECT     TStock_2.ItemTypeID, dbo.TItemType.Description AS ItemType, dbo.TItemType.FinishedProduct, TStock_2.StockID, TStock_2.Name AS StockName, TStock_2.SKU, 
                      dbo.TStockGreen.KgsPerBag, dbo.TStockGreen.MinQty, dbo.TStockGreen.ReorderQty, TStock_2.Enabled, TStock_2.Notes, dbo.TStockRoast.GreenStockID, 
                      TStock_1.Name AS GreenStockName, dbo.TStockGreen.QtyInStock AS GreenQtyInStock, dbo.TStockRoast.QtyInStock AS RoastQtyInStock, 
                      dbo.TStockBlend.QtyInStock AS BlendQtyInStock, dbo.fnCombineValues(dbo.TStockGreen.QtyInStock, dbo.TStockRoast.QtyInStock, dbo.TStockBlend.QtyInStock) 
                      AS QtyInStock, dbo.TStockGreen.PricePerKg AS GreenPricePerKg, dbo.TStockBlend.PricePerKg AS BlendPricePerKg, 
                      dbo.fnCombineValues(dbo.TStockGreen.PricePerKg, NULL, dbo.TStockBlend.PricePerKg) AS PricePerKg, ISNULL(dbo.TStockGreen.ReplacedBy, 0) AS ReplacedBy, 
                      dbo.TStock.Name AS ReplacedByName
FROM         dbo.TStock RIGHT OUTER JOIN
                      dbo.TStockGreen ON dbo.TStock.StockID = dbo.TStockGreen.ReplacedBy RIGHT OUTER JOIN
                      dbo.TStockBlend RIGHT OUTER JOIN
                      dbo.TStock AS TStock_2 INNER JOIN
                      dbo.TItemType ON TStock_2.ItemTypeID = dbo.TItemType.ItemTypeID ON dbo.TStockBlend.StockID = TStock_2.StockID LEFT OUTER JOIN
                      dbo.TStock AS TStock_1 RIGHT OUTER JOIN
                      dbo.TStockRoast ON TStock_1.StockID = dbo.TStockRoast.GreenStockID ON TStock_2.StockID = dbo.TStockRoast.StockID ON 
                      dbo.TStockGreen.StockID = TStock_2.StockID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VStockBlend]
AS
SELECT     dbo.TStock.StockID, dbo.TStock.Name, dbo.TStock.Enabled, dbo.TStockBlend.QtyInStock, dbo.TStockBlend.PricePerKg
FROM         dbo.TStock INNER JOIN
                      dbo.TStockBlend ON dbo.TStock.StockID = dbo.TStockBlend.StockID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VStockGreen]
AS
SELECT     dbo.TStock.StockID, dbo.TStock.Name, dbo.TStock.SKU, dbo.TStockGreen.KgsPerBag, dbo.TStockGreen.MinQty, dbo.TStockGreen.ReorderQty, 
                      dbo.TStockGreen.QtyInStock, dbo.TStockGreen.PricePerKg, dbo.TStock.Enabled, dbo.TStockGreen.ReplacedBy
FROM         dbo.TStock INNER JOIN
                      dbo.TStockGreen ON dbo.TStock.StockID = dbo.TStockGreen.StockID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VStockRoast]
AS
SELECT     dbo.TStock.ItemTypeID, dbo.TStock.StockID, dbo.TStock.Name, dbo.TStock.SKU, dbo.TStockRoast.GreenStockID, TStock_1.Name AS GreenStockName, 
                      dbo.TStock.Enabled, dbo.TStock.Notes
FROM         dbo.TStock INNER JOIN
                      dbo.TStockRoast ON dbo.TStock.StockID = dbo.TStockRoast.StockID LEFT OUTER JOIN
                      dbo.TStock AS TStock_1 ON dbo.TStockRoast.GreenStockID = TStock_1.StockID
GO
CREATE VIEW [dbo].[VRoastCalculator]
AS
SELECT     dbo.TRoastCalculator.RoastReqID, dbo.TRoastCalculator.StockID, dbo.TStock.Name AS StockName, dbo.TRoastCalculator.RoastQtyForSingleOrigin, 
                      dbo.TRoastCalculator.RoastQtyForBlend, dbo.TRoastCalculator.RoastQtyInStock, dbo.TRoastCalculator.RoastQtySoFar, dbo.TRoastCalculator.LossPercentage, 
                      dbo.TRoastCalculator.GreenQtyToRoast, ISNULL(dbo.TRoastCalculator.RoastQtyForSingleOrigin, 0) + ISNULL(dbo.TRoastCalculator.RoastQtyForBlend, 0) 
                      AS TotalRoastQtyNeeded
FROM         dbo.TRoastCalculator INNER JOIN
                      dbo.TStock ON dbo.TRoastCalculator.StockID = dbo.TStock.StockID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VRoastBatches]
AS
SELECT     dbo.TRoastBatch.BatchID, dbo.TRoastBatch.MachineID, dbo.TRoastBatch.RoastDate, dbo.TRoastBatch.BatchNumber, dbo.TRoastBatch.StockID, dbo.TStock.Name, 
                      dbo.TRoastBatch.GreenQty, dbo.TRoastBatch.YieldQty, dbo.TRoastBatch.LossPercentage, dbo.TStockRoast.StockID AS RoastedStockID, dbo.TRoastBatch.Humidity, 
                      dbo.TRoastBatch.AmbientTemp, dbo.TRoastBatch.ChargeTemp, dbo.TRoastBatch.TurningPointTime, dbo.TRoastBatch.TurningPointTemp, dbo.TRoastBatch.TimeAt250,
                       dbo.TRoastBatch.TimeAt300, dbo.TRoastBatch.TimeChangeTo5050, dbo.TRoastBatch.TempChangeTo5050, dbo.TRoastBatch.TimeAt350, 
                      dbo.TRoastBatch.TimeChangeToFull, dbo.TRoastBatch.TempChangeToFull, dbo.TRoastBatch.FirstCrackTime, dbo.TRoastBatch.FirstCrackTemp, 
                      dbo.TRoastBatch.SecondCrackTime, dbo.TRoastBatch.SecondCrackTemp, dbo.TRoastBatch.DropTime, dbo.TRoastBatch.DropTemp, 
                      dbo.TRoastBatch.YellowToBrownTime, dbo.TRoastBatch.YellowToBrownTemp, dbo.TRoastBatch.Notes, dbo.TRoastBatch.NewGasCylinder, 
                      dbo.TRoastBatch.CaptureUser, dbo.TRoastBatch.CaptureDate
FROM         dbo.TRoastBatch INNER JOIN
                      dbo.TStock ON dbo.TRoastBatch.StockID = dbo.TStock.StockID INNER JOIN
                      dbo.TStockRoast ON dbo.TStock.StockID = dbo.TStockRoast.GreenStockID
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VRoastRequirement]
AS
SELECT     TOP (100) PERCENT dbo.TRoastRequirement.RoastReqID, dbo.TRoastRequirement.StockID, dbo.TStock.Name AS StockName, dbo.TStock.ItemTypeID, 
                      dbo.TRoastRequirement.RoastQtyNeeded, dbo.TRoastRequirement.RoastQtyInStock, dbo.TRoastRequirement.RoastQtySoFar, 
                      dbo.TRoastRequirement.SortOrder
FROM         dbo.TRoastRequirement INNER JOIN
                      dbo.TStock ON dbo.TRoastRequirement.StockID = dbo.TStock.StockID
ORDER BY dbo.TRoastRequirement.SortOrder, StockName
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VBlendComponent]
AS
SELECT     dbo.TBlendComponent.BlendStockID, dbo.TStock.Name AS BlendName, dbo.TBlendComponent.ComponentStockID, TStock_1.Name AS ComponentName, 
                      dbo.TBlendComponent.Percentage, dbo.TBlendComponent.Notes
FROM         dbo.TStock INNER JOIN
                      dbo.TBlendComponent ON dbo.TStock.StockID = dbo.TBlendComponent.BlendStockID INNER JOIN
                      dbo.TStock AS TStock_1 ON dbo.TBlendComponent.ComponentStockID = TStock_1.StockID
GO
