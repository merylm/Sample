USE tempdb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Create date: 30/8/2012
-- Description:	Return the value stored in system
-- variable "ItemTypeRoast"
-- =============================================
CREATE FUNCTION [dbo].[fnItemTypeRoast]
(
	-- (No parameters)
	
)
RETURNS INT
AS
BEGIN

	RETURN (SELECT CAST(Value AS INTEGER)
		FROM TSystemVariable
		WHERE SysVarName = 'ItemTypeRoast')


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Create date: 10/6/2012
-- Description:	Return the value stored in system
-- variable "ItemTypeGreenBean"
-- =============================================
CREATE FUNCTION [dbo].[fnItemTypeGreen]
(
	-- (No parameters)
	
)
RETURNS INT
AS
BEGIN

	RETURN (SELECT CAST(Value AS INTEGER)
		FROM TSystemVariable
		WHERE SysVarName = 'ItemTypeGreenBean')


END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Create date: 10/6/2012
-- Description:	Return the value stored in system
-- variable "ItemTypeBlend"
-- =============================================
CREATE FUNCTION [dbo].[fnItemTypeBlend]
(
	-- (No parameters)
	
)
RETURNS INT
AS
BEGIN

	RETURN (SELECT CAST(Value AS INTEGER)
		FROM TSystemVariable
		WHERE SysVarName = 'ItemTypeBlend')

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Create date: 2012/7/1
-- Description:	Calculate the default batch number
--		Format is XXX-YYMM000 where
--		XXX = Machine
--		YY  = Year (12,13,14,...)
--		MM  = Month (01...12)
--		000 = Sequence no for the month: 001,002,...999,
--				then A01,A02,...A99,
--				then B01,... and so on, up to Z99
-- =============================================
CREATE FUNCTION [dbo].[fnDefaultBatchNumber]
(
	@MachineID INT,
	@RoastDate DATE
)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @Default AS VARCHAR(20)
	DECLARE @MaxBatch AS VARCHAR(20)
	DECLARE @Sequence AS CHAR(3)
	DECLARE @Alpha AS CHAR(1)
	DECLARE @Seq AS CHAR(2)
	DECLARE @Done AS BIT = 0
	DECLARE @True AS BIT = 1
	
	SELECT @MaxBatch = MAX(BatchNumber)
		FROM TRoastBatch
		WHERE MachineID = @MachineID
				AND DATEPART(yyyy, RoastDate) = DATEPART(yyyy, @RoastDate)
				AND DATEPART(mm, RoastDate) = DATEPART(mm, @RoastDate)
				
		-- If no batches exist for the machine/roast month ...
		IF @MaxBatch IS NULL
			SELECT @Default = Abbreviation + '-'
				+ RIGHT(
					CAST(DATEPART(yy, @RoastDate) AS CHAR(4)), 2)
				+ dbo.fnZeroFill(
					DATEPART(mm, @RoastDate), 2)
				+ '001'
			FROM TMachine
			WHERE MachineID = @MachineID
			
		ELSE
			BEGIN
			
				SELECT @Sequence = RIGHT(RTRIM(@MaxBatch), 3)
				WHILE @Done = 0
					BEGIN
					
						-- Increment the sequence number
						IF ISNUMERIC(@Sequence) = @True AND @Sequence BETWEEN '000' AND '998'
							SELECT @Sequence = dbo.fnZeroFill(								
									CAST(@Sequence AS INT) + 1, 3)
						
						-- If necessary, carry on to A01
						ELSE IF @Sequence = '999'
							SELECT @Sequence = 'A01'
							
						ELSE IF LEFT(@Sequence, 1) BETWEEN 'A' AND 'Z'
						
							BEGIN
								SELECT @Alpha = LEFT(@Sequence, 1)
								SELECT @Seq = RIGHT(@Sequence, 2)
								
								-- Go from eg. A01 to A02
								IF ISNUMERIC(@Seq) = @True AND @Seq BETWEEN '00' AND '98'
									BEGIN
										SELECT @Seq = dbo.fnZeroFill(											
												CAST(@Seq AS INT) + 1, 2)
									END
									
								ELSE
									BEGIN
										-- Go from eg. A99 to B01
										SELECT @Alpha = CHAR(
											ASCII(@Alpha) + 1)
										SELECT @Seq = '00'
									END
									
									SELECT @Sequence = @Alpha + @Seq
									
							END
							
						ELSE
							-- @MaxBatch has unexpected format, start trying from 'A01'
							SELECT @Sequence = 'A01'

						SELECT @Default = Abbreviation + '-'
							+ RIGHT(
								CAST(DATEPART(yy, @RoastDate) AS CHAR(4)), 2)
							+ dbo.fnZeroFill(
								DATEPART(mm, @RoastDate), 2)
							+ @Sequence
						FROM TMachine
						WHERE MachineID = @MachineID
						
						-- Check that the batch number has not already been used (incorrectly)
						IF NOT EXISTS
							(SELECT 0 FROM TRoastBatch
								WHERE BatchNumber = @Default)
							SELECT @Done = 1
							
						-- Avoid infinite loop
						IF @Sequence = 'Z99'
							SELECT @Done = 1
					END
	
			END
 
	RETURN @Default

END
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Meryl
-- Create date: 7/6/2012
-- Description:	Calculate the average loss %
-- for a particular bean, for the last 6 roasts
-- =============================================
CREATE FUNCTION [dbo].[fnCalcLossPercentage]
(
	@StockID INT,
	@Date DATE
)
RETURNS DECIMAL(8, 2)
AS
BEGIN
	DECLARE @SumYieldQty DECIMAL(9, 3)
	DECLARE @SumGreenQty DECIMAL(9, 3)
	DECLARE @AverageLossPerc DECIMAL(8, 2)

	SELECT @SumYieldQty = SUM(YieldQty),
		@SumGreenQty = SUM(GreenQty)
		FROM TRoastBatch t1
		WHERE StockID = @StockID
			AND BatchID IN
				(SELECT TOP 6 BatchID
					FROM TRoastBatch t2
					WHERE t1.StockID = t2.StockID
					AND RoastDate <= @Date
					ORDER BY RoastDate DESC, BatchNumber DESC)
					
	IF @SumYieldQty = 0
		SELECT @AverageLossPerc = 0
	ELSE
		SELECT @AverageLossPerc = (@SumGreenQty - @SumYieldQty) / @SumYieldQty * 100
					
	RETURN @AverageLossPerc

END
GO
-- =============================================
-- Author:		Meryl
-- Create date: 2012/08/29
-- Description:	Add 3 decimal values together,
--		providing they are not all null.
--		In practice only one of the 3 will be non-null
--		(see view VStock)
-- =============================================
CREATE FUNCTION [dbo].[fnCombineValues]
(
	@Num1 DECIMAL(9, 4),
	@Num2 DECIMAL(9, 4),
	@Num3 DECIMAL(9, 4)
)
RETURNS DECIMAL(9, 4)
AS
BEGIN
	DECLARE @Result DECIMAL(9, 4)

	IF @Num1 IS NULL AND @Num2 IS NULL AND @Num3 IS NULL
		SELECT @Result = NULL
	ELSE
		SELECT @Result = ISNULL(@Num1, 0) + ISNULL(@Num2, 0) + ISNULL(@Num3, 0)

	RETURN @Result

END
GO

-- =============================================
-- Author:		Meryl
-- Create date: 15/07/2012
-- Description:	Return the number as a string
--		padded with leading zeroes
--		(max 50 characters)
-- =============================================
CREATE FUNCTION [dbo].[fnZeroFill]
(
	@Value AS INT,
	@TotChars AS INT
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Result AS VARCHAR(50)
	declare @TempString AS VARCHAR(50)

	-- Left pad the string with zeroes, then take the rightmost characters
		SELECT @TempString = Replicate('0', @TotChars) + CAST(@Value AS VARCHAR(50))
		SELECT @Result = RIGHT(@TempString, @TotChars)

	RETURN @Result

END
GO

-- =============================================
-- Author:		Meryl
-- Create date: 7/9/2012
-- Description:	Round upwards to half.
--		If the number is negative, return 0
--		Otherwise round the number upwards to the nearest 0.5
-- Example: fnRoundUpToHalf(1.4) = 1.5, fnRoundUpToHalf(1.6) = 2,
--		fnRoundUpToHalf(-1.4) = 0
-- =============================================
CREATE FUNCTION [dbo].[fnRoundUpToHalf]
(
	@Number DECIMAL(9, 3)
)
RETURNS DECIMAL(9, 3)
AS
BEGIN
	DECLARE @Result DECIMAL(9, 3)
	DECLARE @Significance DECIMAL(2, 1) = 0.5
	
	IF @Number < 0
		SELECT @Result = 0
	ELSE
		BEGIN
			SELECT @Result = CEILING(@Number)
			IF @Result - @Number >= @Significance
				SELECT @Result = @Result - @Significance
		END

	RETURN @Result

END
GO
