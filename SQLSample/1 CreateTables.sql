USE tempdb
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TYPE [dbo].[udtStockQty] FROM [decimal](9, 3) NULL
GO

CREATE TABLE [dbo].[TSystemVariable](
	[SysVarID] [int] IDENTITY(1,1) NOT NULL,
	[SysVarName] [varchar](30) NOT NULL,
	[Value] [varchar](50) NULL,
	[SysVarText] [varchar](50) NULL,
 CONSTRAINT [PK_TSystemVariable] PRIMARY KEY CLUSTERED 
(
	[SysVarID] ASC
)
)
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TSystemVariable] ON
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (1, N'ItemTypeGreenBean', N'1                                                 ', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (2, N'ItemTypeRoast', N'2', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (3, N'ItemTypeBlend', N'3                                                 ', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (4, N'LatestStockID', N'60', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (5, N'LatestDespatchID', N'41', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (6, N'FwdPlanningFactor', N'0.2                                               ', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (7, N'RoastExpiryDays', N'7', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (8, N'CurrentRoastReqID', N'0', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (9, N'DefaultLossPerc', N'20', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (10, N'ReasonStockLoss', N'1', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (11, N'ReasonStockGain', N'2', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (12, N'DestinationLossGain', N'35', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (13, N'MinLossPerc', N'10', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (14, N'MaxLossPerc', N'25', NULL)
INSERT [dbo].[TSystemVariable] ([SysVarID], [SysVarName], [Value], [SysVarText]) VALUES (15, N'LatestRoastBatchID', N'314', NULL)
SET IDENTITY_INSERT [dbo].[TSystemVariable] OFF
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TMachine](
	[MachineID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](30) NOT NULL,
	[Abbreviation] [varchar](3) NOT NULL,
	[RoasteryID] [int] NULL,
	[OptimumQtyPerRoast] [decimal](9, 3) NULL,
 CONSTRAINT [PK_TMachine] PRIMARY KEY CLUSTERED 
(
	[MachineID] ASC
)
)
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TMachine] ON
INSERT [dbo].[TMachine] ([MachineID], [Name], [Abbreviation], [RoasteryID], [OptimumQtyPerRoast]) VALUES (1, N'Buitenverwachting 12 Kg', N'B12', 1, NULL)
INSERT [dbo].[TMachine] ([MachineID], [Name], [Abbreviation], [RoasteryID], [OptimumQtyPerRoast]) VALUES (2, N'Wild Clover 2.5 Kg', N'KVL', 9, NULL)
SET IDENTITY_INSERT [dbo].[TMachine] OFF
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TItemType](
	[ItemTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](20) NOT NULL,
	[FinishedProduct] [bit] NOT NULL,
	[DoStockCount] [bit] NOT NULL,
 CONSTRAINT [PK_TItemType] PRIMARY KEY CLUSTERED 
(
	[ItemTypeID] ASC
)
)
GO

SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TItemType] ON
INSERT [dbo].[TItemType] ([ItemTypeID], [Description], [FinishedProduct], [DoStockCount]) VALUES (1, N'Green bean', 0, 1)
INSERT [dbo].[TItemType] ([ItemTypeID], [Description], [FinishedProduct], [DoStockCount]) VALUES (2, N'Roast', 1, 1)
INSERT [dbo].[TItemType] ([ItemTypeID], [Description], [FinishedProduct], [DoStockCount]) VALUES (3, N'Blend', 1, 1)
SET IDENTITY_INSERT [dbo].[TItemType] OFF
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TStock](
	[StockID] [int] IDENTITY(1,1) NOT NULL,
	[ItemTypeID] [int] NOT NULL,
	[Name] [varchar](30) NOT NULL,
	[SKU] [varchar](30) NULL,
	[Enabled] [bit] NOT NULL,
	[Notes] [varchar](255) NULL,
 CONSTRAINT [PK_TStock] PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
)
)
GO

SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TStock] ON
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (1, 1, N'Sul de Minas', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (2, 2, N'Sul de Minas (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (3, 1, N'Excelso', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (4, 2, N'Excelso (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (5, 1, N'Sidama', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (6, 2, N'Sidama (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (7, 1, N'Plantation A', NULL, 0, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (8, 2, N'Plantation A (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (9, 1, N'Bromelia', NULL, 0, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (10, 2, N'Bromelia (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (11, 1, N'Yirgacheffe', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (12, 2, N'Yirgacheffe (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (13, 1, N'Limu', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (14, 2, N'Limu (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (15, 1, N'La Piramide', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (16, 2, N'La Piramide (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (17, 1, N'Los Idolos', NULL, 0, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (18, 2, N'Los Idolos (Roasted)', NULL, 0, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (19, 1, N'Los Naranjos', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (20, 2, N'Los Naranjos (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (21, 1, N'Bugisu', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (22, 2, N'Bugisu (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (23, 1, N'Antigua', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (24, 2, N'Antigua (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (25, 1, N'Organica', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (26, 2, N'Organica (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (27, 1, N'Bututsi', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (28, 2, N'Bututsi (Roasted)', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (29, 3, N'House', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (30, 3, N'Armonizar', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (38, 3, N'Bunna', NULL, 1, NULL)
INSERT [dbo].[TStock] ([StockID], [ItemTypeID], [Name], [SKU], [Enabled], [Notes]) VALUES (39, 3, N'Half and Half', NULL, 0, NULL)
SET IDENTITY_INSERT [dbo].[TStock] OFF
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TStockGreen](
	[StockID] [int] NOT NULL,
	[KgsPerBag] [decimal](9, 3) NULL,
	[MinQty] [udtStockQty] NULL,
	[ReorderQty] [udtStockQty] NULL,
	[QtyInStock] [udtStockQty] NULL,
	[QtyInStorage] [udtStockQty] NULL,
	[PricePerKg] [money] NULL,
	[LeadTime] [int] NULL,
	[ReplacedBy] [int] NULL,
 CONSTRAINT [PK_TStockGreen] PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
)
)
GO

INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (1, NULL, NULL, NULL, CAST(16.000 AS Decimal(9, 3)), NULL, 120.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (3, NULL, NULL, NULL, CAST(13.000 AS Decimal(9, 3)), NULL, 150.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (5, NULL, NULL, NULL, CAST(0.000 AS Decimal(9, 3)), NULL, NULL, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (7, NULL, NULL, NULL, CAST(0.000 AS Decimal(9, 3)), NULL, NULL, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (9, NULL, NULL, NULL, CAST(0.000 AS Decimal(9, 3)), NULL, 80.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (11, NULL, NULL, NULL, CAST(0.000 AS Decimal(9, 3)), NULL, NULL, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (13, NULL, NULL, NULL, CAST(78.000 AS Decimal(9, 3)), NULL, 96.1111, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (15, NULL, NULL, NULL, CAST(211.000 AS Decimal(9, 3)), NULL, 350.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (17, NULL, NULL, NULL, CAST(58.000 AS Decimal(9, 3)), NULL, 200.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (19, NULL, NULL, NULL, CAST(30.000 AS Decimal(9, 3)), NULL, 200.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (21, NULL, NULL, NULL, CAST(1.000 AS Decimal(9, 3)), NULL, 0.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (23, NULL, NULL, NULL, CAST(14.000 AS Decimal(9, 3)), NULL, 90.0000, NULL, NULL)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (25, CAST(50.000 AS Decimal(9, 3)), NULL, NULL, CAST(-6.000 AS Decimal(9, 3)), NULL, 195.0000, NULL, 49)
INSERT [dbo].[TStockGreen] ([StockID], [KgsPerBag], [MinQty], [ReorderQty], [QtyInStock], [QtyInStorage], [PricePerKg], [LeadTime], [ReplacedBy]) VALUES (27, NULL, NULL, NULL, CAST(38.000 AS Decimal(9, 3)), NULL, 210.0000, NULL, NULL)
SET ANSI_NULLS ON
GO

CREATE TABLE [dbo].[TStockRoast](
	[StockID] [int] NOT NULL,
	[GreenStockID] [int] NOT NULL,
	[QtyInStock] [udtStockQty] NULL,
 CONSTRAINT [PK_TStockRoast] PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
),
 CONSTRAINT [UQ_GreenStockID] UNIQUE NONCLUSTERED 
(
	[GreenStockID] ASC
)
)
GO

INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (2, 1, CAST(128.255 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (4, 3, CAST(4.600 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (6, 5, CAST(16.825 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (8, 7, CAST(29.945 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (10, 9, CAST(101.050 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (12, 0, CAST(51.750 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (14, 13, CAST(19.200 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (16, 15, CAST(239.800 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (18, 17, CAST(2.100 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (20, 19, CAST(49.260 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (22, 21, NULL)
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (24, 23, CAST(240.350 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (26, 25, CAST(5.600 AS Decimal(9, 3)))
INSERT [dbo].[TStockRoast] ([StockID], [GreenStockID], [QtyInStock]) VALUES (28, 27, CAST(6.000 AS Decimal(9, 3)))

CREATE TABLE [dbo].[TStockBlend](
	[StockID] [int] NOT NULL,
	[QtyInStock] [udtStockQty] NULL,
	[PricePerKg] [money] NULL,
 CONSTRAINT [PK_TStockBlend] PRIMARY KEY CLUSTERED 
(
	[StockID] ASC
)
)
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[TStockBlend] ([StockID], [QtyInStock], [PricePerKg]) VALUES (29, CAST(7.250 AS Decimal(9, 3)), NULL)
INSERT [dbo].[TStockBlend] ([StockID], [QtyInStock], [PricePerKg]) VALUES (30, CAST(16.000 AS Decimal(9, 3)), 159.0000)
INSERT [dbo].[TStockBlend] ([StockID], [QtyInStock], [PricePerKg]) VALUES (38, CAST(206.000 AS Decimal(9, 3)), NULL)
INSERT [dbo].[TStockBlend] ([StockID], [QtyInStock], [PricePerKg]) VALUES (39, CAST(87.500 AS Decimal(9, 3)), 275)
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TBlendComponent](
	[BlendStockID] [int] NOT NULL,
	[ComponentStockID] [int] NOT NULL,
	[Percentage] [decimal](5, 2) NULL,
	[Notes] [varchar](255) NULL,
 CONSTRAINT [PK_TBlendItem] PRIMARY KEY CLUSTERED 
(
	[BlendStockID] ASC,
	[ComponentStockID] ASC
)
)
GO
SET ANSI_PADDING OFF
GO
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (29, 2, CAST(30.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (29, 4, CAST(20.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (29, 6, CAST(30.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (29, 28, CAST(20.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (30, 2, CAST(30.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (30, 4, CAST(40.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (30, 28, CAST(30.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (38, 8, CAST(20.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (38, 12, CAST(25.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (38, 14, CAST(30.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (38, 20, CAST(25.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (39, 16, CAST(50.00 AS Decimal(5, 2)), N'')
INSERT [dbo].[TBlendComponent] ([BlendStockID], [ComponentStockID], [Percentage], [Notes]) VALUES (39, 20, CAST(50.00 AS Decimal(5, 2)), N'')
SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[TRoastRequirement](
	[RoastReqID] [int] NOT NULL,
	[StockID] [int] NOT NULL,
	[RoastQtyNeeded] [udtStockQty] NULL,
	[RoastQtyInStock] [udtStockQty] NULL,
	[RoastQtySoFar] [udtStockQty] NULL,
	[SortOrder] [int] NULL,
 CONSTRAINT [PK_TRoastRequirement] PRIMARY KEY CLUSTERED 
(
	[RoastReqID] ASC,
	[StockID] ASC
)
)
GO

CREATE TABLE [dbo].[TRoastCalculator](
	[RoastReqID] [int] NOT NULL,
	[StockID] [int] NOT NULL,
	[RoastQtyForSingleOrigin] [udtStockQty] NULL,
	[RoastQtyForBlend] [udtStockQty] NULL,
	[RoastQtyInStock] [udtStockQty] NULL,
	[RoastQtySoFar] [udtStockQty] NULL,
	[LossPercentage] [decimal](8, 2) NULL,
	[GreenQtyToRoast] [udtStockQty] NULL,
 CONSTRAINT [PK_TRoastCalculator] PRIMARY KEY CLUSTERED 
(
	[RoastReqID] ASC,
	[StockID] ASC
)
)
GO

CREATE TABLE [dbo].[TRoastBatch](
	[BatchID] [int] IDENTITY(1,1) NOT NULL,
	[MachineID] [int] NOT NULL,
	[RoastDate] [date] NOT NULL,
	[BatchNumber] [varchar](20) NOT NULL,
	[StockID] [int] NOT NULL,
	[GreenQty] [udtStockQty] NULL,
	[YieldQty] [udtStockQty] NULL,
	[LossPercentage] [decimal](8, 2) NULL,
	[Humidity] [decimal](6, 2) NULL,
	[AmbientTemp] [decimal](6, 2) NULL,
	[ChargeTemp] [decimal](6, 2) NULL,
	[TurningPointTime] [time](0) NULL,
	[TurningPointTemp] [decimal](6, 2) NULL,
	[TimeAt250] [time](0) NULL,
	[TimeAt300] [time](0) NULL,
	[TimeChangeTo5050] [time](0) NULL,
	[TempChangeTo5050] [decimal](6, 2) NULL,
	[TimeAt350] [time](0) NULL,
	[TimeChangeToFull] [time](0) NULL,
	[TempChangeToFull] [decimal](6, 2) NULL,
	[FirstCrackTime] [time](0) NULL,
	[FirstCrackTemp] [decimal](6, 2) NULL,
	[SecondCrackTime] [time](0) NULL,
	[SecondCrackTemp] [decimal](6, 2) NULL,
	[DropTime] [time](0) NULL,
	[DropTemp] [decimal](6, 2) NULL,
	[YellowToBrownTime] [time](0) NULL,
	[YellowToBrownTemp] [decimal](6, 2) NULL,
	[Notes] [varchar](255) NULL,
	[TimeAt190] [time](0) NULL,
	[TimeAt220] [time](0) NULL,
	[NewGasCylinder] [bit] NOT NULL,
	[CaptureUser] [varchar](20) NULL,
	[CaptureDate] [date] NULL,
 CONSTRAINT [PK_TRoastBatch] PRIMARY KEY CLUSTERED 
(
	[BatchID] ASC
)
)
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_TRoastBatch] ON [dbo].[TRoastBatch] 
(
	[BatchNumber] ASC
)
GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[TRoastBatch] ON
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (1, 1, '2014-09-21', N'B12-1409001', 1, CAST(12.000 AS Decimal(9, 3)), CAST(10.360 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), NULL, NULL, CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'merylm', '2014-09-21')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (2, 2, '2014-09-30', N'KVL-1409001', 1, CAST(5.000 AS Decimal(9, 3)), CAST(4.29 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'merylm', '2014-09-30')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (4, 1, '2014-09-27', N'B12-1409002', 23, CAST(8.250 AS Decimal(9, 3)), CAST(7.620 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'warrenm', '2014-09-27')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (5, 1, '2014-10-03', N'B12-1410003', 23, CAST(1.000 AS Decimal(9, 3)), CAST(0.83 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL)
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (6, 2, '2014-09-19', N'KVL-1409002', 3, CAST(2.500 AS Decimal(9, 3)), CAST(2.042 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'merylm', '2014-10-03')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (7, 2, '2014-09-22', N'KVL-1409003', 7, CAST(9.9 AS Decimal(9, 3)), CAST(9.002 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'warrenm', '2014-09-19')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (8, 1, '2014-09-25', N'B12-1409004', 9, CAST(1.500 AS Decimal(9, 3)), CAST(1.266 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'warrenm', '2014-09-05')
INSERT [dbo].[TRoastBatch] ([BatchID], [MachineID], [RoastDate], [BatchNumber], [StockID], [GreenQty], [YieldQty], [LossPercentage], [Humidity], [AmbientTemp], [ChargeTemp], [TurningPointTime], [TurningPointTemp], [TimeAt250], [TimeAt300], [TimeChangeTo5050], [TempChangeTo5050], [TimeAt350], [TimeChangeToFull], [TempChangeToFull], [FirstCrackTime], [FirstCrackTemp], [SecondCrackTime], [SecondCrackTemp], [DropTime], [DropTemp], [YellowToBrownTime], [YellowToBrownTemp], [Notes], [TimeAt190], [TimeAt220], [NewGasCylinder], [CaptureUser], [CaptureDate]) VALUES (9, 1, '2014-09-30', N'B12-1409005', 5, CAST(12.000 AS Decimal(9, 3)), CAST(10.88 AS Decimal(9, 3)), CAST(15.83 AS Decimal(8, 2)), CAST(60.00 AS Decimal(6, 2)), CAST(18.00 AS Decimal(6, 2)), CAST(400.00 AS Decimal(6, 2)), CAST(0x00F8160000000000 AS Time), CAST(156.40 AS Decimal(6, 2)), CAST(0x0020490000000000 AS Time), CAST(0x00D8720000000000 AS Time), CAST(0x0040560000000000 AS Time), CAST(270.00 AS Decimal(6, 2)), CAST(0x00E8AD0000000000 AS Time), CAST(0x005CA30000000000 AS Time), CAST(340.00 AS Decimal(6, 2)), CAST(0x007CCE0000000000 AS Time), CAST(392.70 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), CAST(0x00C0E40000000000 AS Time), CAST(428.00 AS Decimal(6, 2)), NULL, NULL, NULL, NULL, NULL, 0, 'merylm', '2014-09-30')
SET IDENTITY_INSERT [dbo].[TRoastBatch] OFF
GO
