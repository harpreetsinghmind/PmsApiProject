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

/****** Object:  StoredProcedure [dbo].[usp_StatesGetAll_NewExport]    Script Date: 8/8/2019 7:01:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_StatesGetAll_NewExport] 
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
SELECT @SQLStatement = 'SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],''FALSE'' AS IsDeleted
	FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],''FALSE'' AS IsDeleted
	FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
-- Execute the SQL statement

Select @CountStatement ='Select Count(*) as FilterCount from States inner join Countries on Countries.CountryId=States.CountryId ' +@Condition
END
EXEC(@SQLStatement)
EXEC(@CountStatement)


	COMMIT
GO

