/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_CitiesGetAll_NewExport]    Script Date: 8/8/2019 7:01:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_CitiesGetAll_NewExport] 
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes],States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType
ELSE
Begin
SELECT @SQLStatement = 'SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes], States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId  ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
GO

