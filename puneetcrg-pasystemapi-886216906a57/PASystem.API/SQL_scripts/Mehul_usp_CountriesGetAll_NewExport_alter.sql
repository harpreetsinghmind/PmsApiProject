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

/****** Object:  StoredProcedure [dbo].[usp_CountriesGetAll_NewExport]    Script Date: 9/30/2019 3:09:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[usp_CountriesSelect]    Script Date: 16-11-2018 18:54:27 ******/

ALTER PROC [dbo].[usp_CountriesGetAll_NewExport] 
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
	DECLARE @ColumnName AS nvarchar(MAX)
	SELECT @ColumnName =  ISNULL(@ColumnName +',','') + QUOTENAME(AttributeLabel)
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].[Countries] C
	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Countries'
	LEFT JOIN AdHocAttributeValues AV ON C.CountryId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement

IF @Condition is null
	IF @ColumnName IS NULL
	BEGIN
		SELECT @SQLStatement = 'SELECT [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], C.[InActive], [Notes], ''FALSE'' AS IsDeleted
			FROM   [dbo].[Countries] C
			order by ' + @FieldName+ ' '+ @SortType
	END
	ELSE
	BEGIN
			SELECT @SQLStatement =  'SELECT * from
		(
			select [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], C.[InActive], [Notes],  AttributeLabel, FieldValue,''FALSE'' AS IsDeleted
			FROM  [dbo].[Countries] C
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Countries''
			LEFT JOIN AdHocAttributeValues AV ON C.CountryId = AV.TablePKId AND AV.AttributeId = A.AttributeId
		) x
		pivot
		(
		  MAX(FieldValue) FOR
		  AttributeLabel IN ('+ @ColumnName +')
		) pvt order by ' + @FieldName+ ' '+ @SortType
	END 
else
Begin
	IF @ColumnName IS NULL
	BEGIN
	SELECT @SQLStatement = 'SELECT [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], C.[InActive], [Notes], ''FALSE'' AS IsDeleted
		FROM   [dbo].[Countries] C
		'+@Condition+' order by ' + @FieldName+ ' '+ @SortType
	END
	ELSE
	BEGIN
	SELECT @SQLStatement =  'SELECT * from
		(
			select [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], C.[InActive], [Notes],  AttributeLabel, FieldValue,''FALSE'' AS IsDeleted
			FROM  [dbo].[Countries] C
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Countries''
			LEFT JOIN AdHocAttributeValues AV ON C.CountryId = AV.TablePKId AND AV.AttributeId = A.AttributeId
			'+@Condition+' 
		) x
		pivot
		(
		  MAX(FieldValue) FOR
		  AttributeLabel IN ('+ @ColumnName +')
		) pvt order by ' + @FieldName+ ' '+ @SortType
	END
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount from Countries ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)
	

	COMMIT
GO

