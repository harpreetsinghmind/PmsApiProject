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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureGetAll_NewExport]    Script Date: 8/21/2019 3:58:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_OrgStructureGetAll_NewExport] 
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
SELECT @SQLStatement = 'SELECT [Name], [Description], [InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted FROM   [dbo].[OrgStructure] order by ' + @FieldName+ ' '+ @SortType
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT [Name], [Description], [InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted FROM   [dbo].[OrgStructure] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[OrgStructure] ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

COMMIT
GO

