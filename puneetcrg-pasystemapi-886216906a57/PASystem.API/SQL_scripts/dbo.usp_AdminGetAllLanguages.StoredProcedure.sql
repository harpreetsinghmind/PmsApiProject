/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [PASystemTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_AdminGetAllLanguages]    Script Date: 2/28/2019 1:11:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_AdminGetAllLanguages] 
	@PageNo bigint,
	@NoOfRecords bigint,
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
SELECT @SQLStatement = 'SELECT * FROM  [dbo].[Languages] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT * FROM  [dbo].[Languages] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Languages] ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

COMMIT
GO
