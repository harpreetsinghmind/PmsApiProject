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

/****** Object:  StoredProcedure [dbo].[usp_BusinessTypesGetAll_NewExport]    Script Date: 8/13/2019 4:03:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_BusinessTypesGetAll_NewExport] 
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
SELECT @SQLStatement = 'SELECT [BTName] as BusinessType,InActive ,''FALSE'' AS IsDeleted
	FROM   [dbo].[BusinessTypes] order by ' + @FieldName+ ' '+ @SortType
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT [BTName] as BusinessType,InActive ,''FALSE'' AS IsDeleted
	FROM   [dbo].[BusinessTypes] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM   [dbo].[BusinessTypes] ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

	
	COMMIT
GO

