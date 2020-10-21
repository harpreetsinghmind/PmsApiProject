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

/****** Object:  StoredProcedure [dbo].[usp_KeywordGetAll_NewExport]    Script Date: 8/14/2019 11:12:07 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_KeywordGetAll_NewExport] 
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement nvarchar(MAX)
	DECLARE @CountStatement nvarchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId order by ' + @FieldName+ ' '+ @SortType
ELSE
Begin
SELECT @SQLStatement = 'SELECT m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[LanguageMaster] ' +@Condition
End

print @SQLStatement

EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
GO

