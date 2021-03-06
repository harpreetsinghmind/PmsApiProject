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
/****** Object:  StoredProcedure [dbo].[usp_OrgStructureMapUpdate]    Script Date: 2/1/2019 4:35:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_OrgStructureMapUpdate]
	@OrgStructureMapId bigint, 
    @OrgStructureId bigint,
	@OrgStructureLevelId bigint,
	@UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE[dbo].[OrgStructureMapping]
	SET [OrgStructureId]= @OrgStructureId, [OrgSructureLevelId] = @OrgStructureLevelId , [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [OrgStructureMapId] = @OrgStructureMapId 

	-- Begin Return Select <- do not remove
	SELECT [OrgStructureMapId]
	FROM   [dbo].[OrgStructureMapping]
	WHERE  [OrgStructureMapId] = @OrgStructureMapId	
	-- End Return Select <- do not remove

	COMMIT
GO
