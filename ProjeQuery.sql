---------------------------STG TABLES---------------------------------------------

CREATE TABLE [stgProduct] (
    [ProductID] smallint,
    [Name] nvarchar(50),
    [ProductCode] nvarchar(10),
    [CategoryID] tinyint,
    [Cost] money,
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgProduct]

CREATE TABLE [stgRegion] (
    [RegionID] smallint,
    [Continent] nvarchar(20),
    [Country] nvarchar(40),
    [City] nvarchar(40),
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgRegion]

CREATE TABLE [stgCargo] (
    [CargoID] smallint,
    [Name] nvarchar(50),
    [TransportType] nvarchar(10),
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgCargo]

CREATE TABLE [stgCategory] (
    [CategoryID] tinyint,
    [Name] nvarchar(50),
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgCategory]

CREATE TABLE [stgCustomer] (
    [CustomerID] int,
    [Name] nvarchar(100),
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgCustomer]

CREATE TABLE [stgOrder] (
    [OrderID] int,
    [OrderDate] datetime,
    [DueDate] datetime,
    [CustomerID] int,
    [ProductID] smallint,
    [RegionID] smallint,
    [CargoID] smallint,
    [WarehouseID] tinyint,
    [ModifiedDate] datetime,
	[STGInsertDate] datetime default getdate()
)
--truncate table [stgOrder]

--------------------------DimandDump----------------------------------
select * from [stgProduct]

CREATE TABLE [DimProduct] (
    DWID int identity (1,1), 
    [DC_ProductID] int,
    [DC_Name] nvarchar(60),
    [DC_ProductCode] nvarchar(6),
    [DC_CategoryID] int,
    [DC_Cost] decimal(28,3),
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)
select DWID,DC_ProductID from dbo.[DimProduct]

CREATE TABLE [DimDumpProduct] (
    
    [DC_ProductID] int,
    [DC_Name] nvarchar(60),
    [DC_ProductCode] nvarchar(6),
    [DC_CategoryID] int,
    [DC_Cost] decimal(28,3),
    [DC_STGInsertDate] datetime,
    [DWID] int,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)
UPDATE dim
SET dim.[DC_Name]=dump.[DC_Name],
dim.[DC_ProductCode]=dump.[DC_ProductCode],
dim.[DC_CategoryID]=dump.[DC_CategoryID],
dim.[DC_Cost]=dump.[DC_Cost],
dim.DWUpdateDate=getdate()
FROM [dbo].[DimProduct] dim
JOIN [dbo].[DimDumpProduct] dump ON dim.DWID=dump.DWID

CREATE TABLE SSISExecutionLog
(
ID int identity(1,1),
TableName nvarchar(50),
PackageName nvarchar(50),
LastExecutionDateTime datetime
)

update SSISExecutionLog
set LastExecutionDateTime=getdate()
where TableName=? and PackageName=?

select DWID,DC_CategoryID from DimDumpCategory
--------------------Region
CREATE TABLE [DimRegion] (
    DWID int identity (1,1),
    [DC_RegionID] int,
    [DC_Continent] nvarchar(20),
    [DC_Country] nvarchar(40),
    [DC_City] nvarchar(40),
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

select DWID,[DC_RegionID] from dbo.[DimRegion]

CREATE TABLE [DimDumpRegion] (
    
    [DC_RegionID] int,
    [DC_Continent] nvarchar(20),
    [DC_Country] nvarchar(40),
    [DC_City] nvarchar(40),
    [DC_STGInsertDate] datetime,
    [DWID] int,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

UPDATE dim
SET dim.[DC_Continent]=dump.[DC_Continent],
dim.[DC_Country]=dump.[DC_Country],
dim.[DC_City]=dump.[DC_City],
dim.DWUpdateDate=getdate()
FROM [dbo].[DimRegion] dim
JOIN [dbo].[DimDumpRegion] dump ON dim.DWID=dump.DWID
--------------------------CARGO
CREATE TABLE [DimCargo] (
    DWID int identity (1,1),
    [DC_CargoID] int,
    [DC_Name] nvarchar(50),
    [DC_TransportType] nvarchar(10),
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)
select DWID,[DC_CargoID] from dbo.[DimCargo]

CREATE TABLE [DimandDumpCargo] (
    [DC_CargoID] int,
    [DC_Name] nvarchar(50),
    [DC_TransportType] nvarchar(10),
    [DC_STGInsertDate] datetime,
    [DWID] int,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

UPDATE dim
SET dim.[DC_Name]=dump.[DC_Name],
dim.[DC_TransportType]=dump.[DC_TransportType],
dim.DWUpdateDate=getdate()
FROM [dbo].[DimCargo] dim
JOIN [dbo].[DimandDumpCargo] dump ON dim.DWID=dump.DWID

update SSISExecutionLog
set LastExecutionDateTime=getdate()
where TableName=? and PackageName=?

-------------Category
CREATE TABLE [DimCategory] (
	DWID int identity (1,1),
    [DC_CategoryID] int,
    [DC_Name] nvarchar(50),
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

select DWID,[DC_CategoryID] from dbo.[DimCategory]

CREATE TABLE [DimDumpCategory] (
    [DC_CategoryID] int,
    [DC_Name] nvarchar(50),
    [DC_STGInsertDate] datetime,
    [DWID] int,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

UPDATE dim
SET dim.[DC_Name]=dump.[DC_Name],
dim.DWUpdateDate=getdate()
FROM [dbo].[DimCategory] dim
JOIN [dbo].[DimDumpCategory] dump ON dim.DWID=dump.DWID

update SSISExecutionLog
set LastExecutionDateTime=getdate()
where TableName=? and PackageName=?
------------Customer
CREATE TABLE [DimCustomer] (
	DWID int identity (1,1),
    [DC_CustomerID] int,
    [DC_Name] nvarchar(100),
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)
select DWID,[DC_CustomerID] from dbo.[DimCustomer]

CREATE TABLE [DimDumpCustomer] (
    [DC_CustomerID] int,
    [DC_Name] nvarchar(100),
    [DC_STGInsertDate] datetime,
    [DWID] int,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

UPDATE dim
SET dim.[DC_Name]=dump.[DC_Name],
dim.DWUpdateDate=getdate()
FROM [dbo].[DimCustomer] dim
JOIN [dbo].[DimDumpCustomer] dump ON dim.DWID=dump.DWID

update SSISExecutionLog
set LastExecutionDateTime=getdate()
where TableName=? and PackageName=?

------------------------------FACT TABLE--------------------------------------------

select DC_ProductID,DWID from DimDumpProduct

select DC_RegionID,DWID from DimDumpRegion

select DC_CargoID,DWID from DimandDumpCargo

select DC_CustomerID,DWID from DimDumpCustomer



-----FACT ORDER
CREATE TABLE [FactOrder] (
    [DWID] int identity (1,1),
    [DC_OrderID] int,
    [DC_OrderDate] datetime,
    [DC_DueDate] datetime,
    [DC_CustomerID] int,
    [DC_ProductID] int,
    [DC_RegionID] int,
    [DC_CargoID] int,
    [DC_WarehouseID] int,
    [DC_ModifiedDate] datetime,
    [DC_STGInsertDate] datetime,
	DWInsertDate datetime default getdate(),
    DWUpdateDate datetime   
)
select DWID,DC_OrderID,DC_CustomerID,DC_ProductID,DC_RegionID,DC_CargoID from FactOrder

CREATE TABLE [DumpFactOrder] (
    [DC_OrderID] int,
    [DC_OrderDate] datetime,
    [DC_DueDate] datetime,
    [DC_CustomerID] int,
    [DC_ProductID] int,
    [DC_RegionID] int,
    [DC_CargoID] int,
    [DC_WarehouseID] int,
    [DC_ModifiedDate] datetime,
    [DC_STGInsertDate] datetime,
	[DWID] int,
    DWInsertDate datetime default getdate(),
    DWUpdateDate datetime
)

UPDATE dim
SET dim.[DC_OrderDate]=dump.[DC_OrderDate],
dim.[DC_DueDate]=dump.[DC_DueDate],
dim.DWUpdateDate=getdate()
FROM [dbo].[FactOrder] dim
JOIN [dbo].[DumpFactOrder] dump ON dim.DWID=dump.DWID

update SSISExecutionLog
set LastExecutionDateTime=getdate()
where TableName=? and PackageName=?

select * from FactOrder

select DWID,DC_OrderID,DC_CustomerID,DC_ProductID,DC_RegionID,DC_CargoID from FactOrder