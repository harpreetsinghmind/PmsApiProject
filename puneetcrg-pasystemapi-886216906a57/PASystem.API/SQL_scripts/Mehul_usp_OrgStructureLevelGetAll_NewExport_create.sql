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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureLevelGetAll_NewExport]    Script Date: 8/22/2019 11:49:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_OrgStructureLevelGetAll_NewExport] 
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
SELECT @SQLStatement = 'SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted
	FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId order by ' + @FieldName+ ' '+ @SortType
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted 
	FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

COMMIT


GO

