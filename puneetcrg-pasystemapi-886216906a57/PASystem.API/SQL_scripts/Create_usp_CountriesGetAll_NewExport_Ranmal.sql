USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CountriesGetAll]    Script Date: 8/7/2019 10:53:53 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[usp_CountriesSelect]    Script Date: 16-11-2018 18:54:27 ******/

Create PROC [dbo].[usp_CountriesGetAll_NewExport] 
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
SELECT @SQLStatement = 'SELECT [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], [InActive], [Notes], ''FALSE'' AS IsDeleted
	FROM   [dbo].[Countries] order by ' + @FieldName+ ' '+ @SortType 
else
Begin
SELECT @SQLStatement = 'SELECT [CountryName], [CountryAbbr],[CurrencyCode], [Currency], [CurrencySymbol], [CountryCode], [InActive], [Notes], ''FALSE'' AS IsDeleted
	FROM   [dbo].[Countries] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount from Countries ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)
	

	COMMIT
