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
/****** Object:  StoredProcedure [dbo].[usp_OrgStructureMapSelect]    Script Date: 2/1/2019 4:35:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_OrgStructureMapSelect] 
    @OrgStructureMapId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [OrgStructureMapId], [ModuleName], [ModuleId],[OrgStructureId],[OrgSructureLevelId],[Attribute1],[Attribute2],[Attribute3],[Attribute4] [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate] 
	FROM   [dbo].[OrgStructureMapping] 
	WHERE  ([OrgStructureMapId] = @OrgStructureMapId ) 

	COMMIT
GO
