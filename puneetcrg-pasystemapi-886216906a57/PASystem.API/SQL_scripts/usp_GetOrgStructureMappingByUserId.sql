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

/****** Object:  StoredProcedure [dbo].[usp_GetOrgStructureMappingByUserId]    Script Date: 3/28/2019 4:10:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetOrgStructureMappingByUserId] 
    @UserId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [OrgStructureMapId], [ModuleId], [ModuleName], OrgStructureMapping.[OrgStructureId], OrgStructureMapping.[OrgSructureLevelId],[UserId], OrgStructure.Name as LevelName,OrgStructureLevel.Name as ElementName
	FROM   [dbo].[OrgStructureMapping],[dbo].[OrgStructure],[dbo].[OrgStructureLevel]
	WHERE  [UserId] = @UserId and [dbo].[OrgStructure].OrgStructureId = OrgStructureMapping.[OrgStructureId] and [dbo].[OrgStructureLevel].OrgStructureLevelId = OrgStructureMapping.[OrgSructureLevelId];

	COMMIT
GO

