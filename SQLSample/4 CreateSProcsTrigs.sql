USE tempdb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Description:	Calculate the quantity of green bean that
--		must be roasted in order to meet the requirements
--		captured into TRoastRequirement, and output the results
--		to table TRoastCalculator

-- Note: TRoastRequirement has entries for both blends and single roasts,
--		whereas TRoastCalculator has entries only for single roasts
-- =============================================
CREATE PROCEDURE [dbo].[spRoastCalculator] 
	@RoastReqID INT 
AS
BEGIN
	DECLARE @BlendStockID INT
	DECLARE @BlendQtyNeeded DECIMAL(9, 3)
	DECLARE @BlendQtyInStock DECIMAL(9, 3)
	DECLARE @BlendQtySoFar DECIMAL(9, 3)
	DECLARE @DefaultLossPerc DECIMAL(8,2)

	SET NOCOUNT ON;
	
	-- Clear previous calculation, if any
	DELETE FROM TRoastCalculator
		WHERE RoastReqID = @RoastReqID

    -- Create single roast entries in TRoastCalculator
	INSERT INTO TRoastCalculator
		(RoastReqID, StockID, RoastQtyForSingleOrigin, RoastQtyInStock, RoastQtySoFar)
		SELECT @RoastReqID, TStock.StockID, RoastQtyNeeded, RoastQtyInStock, RoastQtySoFar
		FROM TRoastRequirement, TStock
			WHERE TRoastRequirement.StockID = TStock.StockID
				AND TRoastRequirement.RoastReqID = @RoastReqID
				AND TStock.ItemTypeID = dbo.fnItemTypeRoast()
				
	-- Update each roast with the maximum loss % out of the last 6 roast batches
	UPDATE TRoastCalculator
		SET LossPercentage = 
			(SELECT MAX(LossPercentage) FROM TRoastBatch
				WHERE BatchID IN 
					(SELECT TOP 6 BatchID
						FROM TRoastBatch, TStockRoast
						WHERE TRoastCalculator.StockID = TStockRoast.StockID
							AND TStockRoast.GreenStockID = TRoastBatch.StockID
						ORDER BY RoastDate DESC, BatchID DESC))
						
	-- Where no loss % was found, use system default
	SELECT @DefaultLossPerc = CAST(Value AS DEC(8, 2))
		FROM TSystemVariable
		WHERE SysVarName = 'DefaultLossPerc'
		
	UPDATE TRoastCalculator
		SET LossPercentage = @DefaultLossPerc
			WHERE LossPercentage IS NULL
				OR LossPercentage = 0
								
	-- Loop through all blends in the requirements table
	DECLARE BlendCursor CURSOR FOR
		SELECT TStock.StockID, RoastQtyNeeded, RoastQtyInStock, RoastQtySoFar
		FROM TRoastRequirement, TStock
			WHERE TRoastRequirement.StockID = TStock.StockID
				AND TRoastRequirement.RoastReqID = @RoastReqID
				AND TStock.ItemTypeID = dbo.fnItemTypeBlend()

	OPEN BlendCursor	
	FETCH NEXT FROM BlendCursor
		INTO @BlendStockID, @BlendQtyNeeded, @BlendQtyInStock, @BlendQtySoFar
		
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @BlendQtyNeeded > 0
			-- Update each component's "roast quantity for blend" = blend qty * component percentage
			--		where blend qty = blend qty needed - blend qty in stock
			UPDATE TRoastCalculator
				SET RoastQtyForBlend = ISNULL(RoastQtyForBlend, 0) +
					(ISNULL(@BlendQtyNeeded, 0) - ISNULL(@BlendQtyInStock, 0))
						* TBlendComponent.Percentage/100
				FROM TBlendComponent
					WHERE TBlendComponent.BlendStockID = @BlendStockID
						AND TBlendComponent.ComponentStockID = TRoastCalculator.StockID
						AND TRoastCalculator.RoastReqID = @RoastReqID

		FETCH NEXT FROM BlendCursor
			INTO @BlendStockID, @BlendQtyNeeded, @BlendQtyInStock, @BlendQtySoFar
	END
	
	CLOSE BlendCursor
	DEALLOCATE BlendCursor
	
	-- Calculate the green qty needed to roast
	-- Loss% = ((Green - Yield) / Yield) * 100
	-- So Green = Yield (1 + Loss%/100)
	--		where the required yield = roast qty needed - roast qty in stock - roast qty so far
	UPDATE TRoastCalculator
		SET GreenQtyToRoast =
			dbo.fnRoundUpToHalf(
				(ISNULL(RoastQtyForSingleOrigin, 0) + ISNULL(RoastQtyForBlend, 0) - ISNULL(RoastQtyInStock, 0) - ISNULL(RoastQtySoFar, 0))
					* (1 + ISNULL(LossPercentage, 0)/100))
		WHERE RoastReqID = @RoastReqID

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Description:	Populate table TRoastRequirement with
--		all stock items that are flasgged as finished product
-- =============================================
CREATE PROCEDURE [dbo].[spNewRoastRequirement]
AS
BEGIN
	DECLARE @RoastReqID INT
	
	SET NOCOUNT ON;

	-- Get the next available ID
	SELECT @RoastReqID = MAX(RoastReqID) + 1
		FROM TRoastRequirement
		
	IF @RoastReqID IS NULL  -- (first time)
		SELECT @RoastReqID = 1
		
	-- Create one record for each possible stock item
	INSERT INTO TRoastRequirement
		(RoastReqID, StockID, RoastQtyNeeded, RoastQtyInStock, RoastQtySoFar, SortOrder)
		SELECT @RoastReqID, StockID, NULL, NULL, NULL, 0
		FROM TStock, TItemType
			WHERE TStock.ItemTypeID = TItemType.ItemTypeID
				AND TItemType.FinishedProduct = 1
				AND (TStock.Enabled = 1
					OR
					-- Also check whether the item is a component of an active blend
					EXISTS (SELECT 0 FROM TBlendComponent, TStock blend
						WHERE TStock.StockID = ComponentStockID
							AND blend.StockID = BlendStockID
							AND blend.Enabled = 1))
				
	-- Update qty in stock for item type = roast
	-- Also update sort order field so that roasted stock appears after blends
	UPDATE TRoastRequirement
		SET RoastQtyInStock = QtyInStock,
			SortOrder = 1
		FROM TStockRoast, TStock
		WHERE TRoastRequirement.StockID = TStockRoast.StockID
			AND TStockRoast.StockID = TStock.StockID
			AND ItemTypeID = dbo.fnItemTypeRoast()
				
	-- Update qty in stock for item type = blend
	UPDATE TRoastRequirement
		SET RoastQtyInStock = QtyInStock
		FROM TStockBlend, TStock
		WHERE TRoastRequirement.StockID = TStockBlend.StockID
			AND TStockBlend.StockID = TStock.StockID
			AND ItemTypeID = dbo.fnItemTypeBlend()
			
	-- Update system variable with the current roast req id
	-- This can be changed (manually) if the user wants to go back to a previous calculation
	UPDATE TSystemVariable
		SET Value = @RoastReqID
		WHERE SysVarName = 'CurrentRoastReqID'
				
END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Meryl
-- Description:	Stock Summary Report
-- =============================================
CREATE PROCEDURE [dbo].[spStockSummaryReport]
	@FromDate date, 
	@ToDate date
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @DecimalVar DECIMAL(9, 3) = 0
	DECLARE @MoneyVar MONEY = 0
	DECLARE @PercentVar DECIMAL(8, 2) = 0

	-- Create temporary table
	SELECT TStock.StockID,
		TStock.Name,
		OpeningBal = dbo.fnCalcStockBal(TStock.StockID, DATEADD(day, -1, @FromDate)),
		ClosingBal = dbo.fnCalcStockBal(TStock.StockID, @ToDate),
		OpeningPricePerKg = @MoneyVar, -- See below
		ClosingPricePerKg = @MoneyVar, -- See below
		SumQtyPurchased = (SELECT SUM(QtyPurchased) FROM TStockPurchase
				WHERE TStock.StockID = TStockPurchase.StockID
				AND PurchaseDate BETWEEN @FromDate AND @ToDate),
		SumGreenQty = (SELECT SUM(GreenQty) FROM TRoastBatch
				WHERE TStock.StockID = TRoastBatch.StockID
				AND RoastDate BETWEEN @FromDate AND @ToDate),
		SumYieldQty = (SELECT SUM(YieldQty) FROM TRoastBatch
				WHERE TStock.StockID = TRoastBatch.StockID
				AND RoastDate BETWEEN @FromDate AND @ToDate),
		SumValueRoasted = @MoneyVar -- See below
	INTO #StockSummary
	FROM TStock, TStockGreen
	WHERE TStock.StockID = TStockGreen.StockID
		AND Enabled = 1

	UPDATE #StockSummary
		SET OpeningPricePerKg = dbo.fnCalcFIFOPricePerKg(#StockSummary.StockID, DATEADD(day, -1, @FromDate), OpeningBal),
			ClosingPricePerKg = dbo.fnCalcFIFOPricePerKg(#StockSummary.StockID, @ToDate, ClosingBal),
			-- Value roasted = Qty roasted * Price per kg roasted
			--				 = GreenQty * CalcPricePerKG(StockID, RoastDate, Stock on hand at roast date)
			--				 = GreenQty * CalcPricePerKg(StockID, RoastDate, CalcStockBal(StockID, RoastDate)
			SumValueRoasted = (SELECT SUM(GreenQty * dbo.fnCalcFIFOPricePerKg(TRoastBatch.StockID, RoastDate, 
							dbo.fnCalcStockBal(TRoastBatch.StockID, RoastDate)))
				FROM TRoastBatch
				WHERE TRoastBatch.StockID = #StockSummary.StockID
					AND RoastDate BETWEEN @FromDate AND @ToDate)
	
	-- Return result set
	SELECT StockID = StockID,
		Item = Name,
		"Stock Start" = OpeningBal,
		Purch = SumQtyPurchased,
		Roasted = SumGreenQty,
		Yield = SumYieldQty,
		"Ave Loss" =
			CASE SumYieldQty
				WHEN 0 THEN 0
				WHEN NULL THEN NULL
				ELSE
					CAST((SumGreenQty - SumYieldQty) / SumYieldQty * 100 AS DECIMAL(8, 2))
				END,
		"Stock End" = ClosingBal,
		"Start Value" = CAST(OpeningBal * OpeningPricePerKg	AS DECIMAL(11, 2)),
		"End Value" = CAST(ClosingBal * ClosingPricePerKg AS DECIMAL(11, 2)),
		"Value Used" = CAST(SumValueRoasted AS DECIMAL(11, 2))
	FROM #StockSummary
	ORDER BY Name
	
	DROP TABLE #StockSummary
END
GO

-- =============================================
-- Author:		Meryl
-- Description:	After roast batch is inserted, updated or deleted
--		1. Calculate the loss percentage
--		2. Update the green bean qty in stock
--		3. Update the roasted bean qty in stock
-- =============================================
CREATE TRIGGER [dbo].[trgRoastBatchUpdate] 
   ON  [dbo].[TRoastBatch]
   AFTER INSERT, UPDATE, DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    UPDATE TRoastBatch
		SET LossPercentage =
			CASE YieldQty
				WHEN 0 THEN 0
				WHEN NULL THEN NULL
				ELSE
					(GreenQty - YieldQty) / YieldQty * 100
				END
		WHERE TRoastBatch.BatchID IN (SELECT BatchID FROM inserted)
		
		-------------------- GREEN BEAN --------------------
		
		-- Subtract the quantity roasted from the qty in stock (INSERT + UPDATE)
		UPDATE TStockGreen
			SET QtyInStock = ISNULL(QtyInStock, 0) - inserted.GreenQty
			FROM inserted
			WHERE inserted.StockID = TStockGreen.StockID
			
		-- Add back the original quantity to the qty in stock (UPDATE + DELETE)
		-- Note: On update, it is possible for the stock ID to have changed
		UPDATE TStockGreen
			SET QtyInStock = ISNULL(QtyInStock, 0) + deleted.GreenQty
			FROM deleted
			WHERE deleted.StockID = TStockGreen.StockID
			
		-------------------- ROASTED BEAN --------------------
		
		-- Add the quantity yielded to the qty in stock (INSERT + UPDATE)
		UPDATE TStockRoast
			SET QtyInStock = ISNULL(QtyInStock, 0) + inserted.YieldQty
			FROM inserted
			WHERE inserted.StockID = TStockRoast.GreenStockID
			
		-- Subtract the original quantity yielded from the qty in stock (UPDATE + DELETE)
		-- Note: As before, on update it is possible for the stock ID to have changed
		UPDATE TStockRoast
			SET QtyInStock = ISNULL(QtyInStock, 0) - deleted.YieldQty
			FROM deleted
			WHERE deleted.StockID = TStockRoast.GreenStockID
	
END
GO

-- =============================================
-- Author:		Meryl
-- Description:	When a stock purchase is deleted,
-- modify green stock quantity on hand and price per kg

-- NB: An Update must be treated as delete followed by insert
--		hence the use of sp_settriggerorder
--		When updating, this trigger must execute FIRST
-- =============================================
CREATE TRIGGER [dbo].[trgStockPurchaseDelete]
   ON  [dbo].[TStockPurchase]
   AFTER DELETE, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	
	DECLARE @TodaysDate AS DATE
	
	SELECT @TodaysDate = CAST(GETDATE() AS DATE)

    Update TStockGreen
		SET QtyInStock = QtyInStock - deleted.QtyPurchased,
			PricePerKg = dbo.fnCalcFIFOPricePerKg(deleted.StockID, @TodaysDate, QtyInStock - deleted.QtyPurchased)
		FROM deleted
		WHERE TStockGreen.StockID = deleted.StockID

END
GO
EXEC sp_settriggerorder @triggername=N'[dbo].[trgStockPurchaseDelete]', @order=N'First', @stmttype=N'UPDATE'
GO
-- =============================================
-- Author:		Meryl
-- Description:	When a stock purchase is entered,
--		update green stock quantity on hand and price per kg.
-- Also update the blend price per kg for all blends
--		that make use of the green bean

-- NB: An Update must be treated as delete followed by insert
--		hence the use of sp_settriggerorder
--		When updating, this trigger must execute LAST
-- =============================================
CREATE TRIGGER [dbo].[trgStockPurchaseInsert]
   ON  [dbo].[TStockPurchase]
   AFTER INSERT, UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

    UPDATE TStockGreen
		SET QtyInStock = ISNULL(QtyInStock, 0) + inserted.QtyPurchased,
			PricePerKg = dbo.fnCalcFIFOPricePerKg(inserted.StockID, PurchaseDate, ISNULL(QtyInStock, 0) + inserted.QtyPurchased)
		FROM inserted
		WHERE TStockGreen.StockID = inserted.StockID;
		
	-- Retrieve all active blends where the green bean is a component
    WITH Blends AS
		(SELECT BlendStockID
			FROM TStockRoast, TBlendComponent, TStock
			WHERE TStockRoast.GreenStockID IN (SELECT StockID FROM inserted)
				AND TStockRoast.StockID = TBlendComponent.ComponentStockID
				AND TBlendComponent.BlendStockID = TStock.StockID
				AND TStock.Enabled = 1)

			-- Update the price per kg for all these blends
			UPDATE TStockBlend SET PricePerKg = dbo.fnCalcBlendPricePerKg(StockID)
				WHERE StockID IN (SELECT BlendStockID FROM Blends)
END
GO
EXEC sp_settriggerorder @triggername=N'[dbo].[trgStockPurchaseInsert]', @order=N'Last', @stmttype=N'UPDATE'
GO

-- Create the first roast calculation
EXEC [dbo].[spNewRoastRequirement]
GO

