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

/****** Object:  StoredProcedure [dbo].[usp_KeywordGetAll]    Script Date: 4/10/2019 5:50:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_KeywordGetAll] 
    @PageNo bigint,
	@NoOfRecords bigint,
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
SELECT @SQLStatement = 'SELECT m.Id, m.LanguageId, m.Keyword, m.Value, m.CreatedBy,m.CreatedDate, l.DisplayName FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
Begin
SELECT @SQLStatement = 'SELECT m.Id, m.LanguageId, m.Keyword, m.Value, m.CreatedBy,m.CreatedDate, l.DisplayName FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[LanguageMaster] ' +@Condition
End

print @SQLStatement

EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
GO

