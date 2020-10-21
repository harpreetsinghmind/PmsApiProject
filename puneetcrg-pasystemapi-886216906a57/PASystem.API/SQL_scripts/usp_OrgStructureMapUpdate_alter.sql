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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureMapUpdate]    Script Date: 3/28/2019 4:08:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_OrgStructureMapUpdate]

	@OrgStructureMapId bigint, 
    @OrgStructureId bigint,
	@OrgStructureLevelId bigint,
	@UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@ModuleId bigint,
	@ModuleName nvarchar(255),
	@UserId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE[dbo].[OrgStructureMapping]
	SET [OrgStructureId]= @OrgStructureId, [OrgSructureLevelId] = @OrgStructureLevelId , [ModuleId] = @ModuleId,[ModuleName] = @ModuleName, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [OrgStructureMapId] = @OrgStructureMapId and [UserId] = @UserId

	-- Begin Return Select <- do not remove
	SELECT [OrgStructureMapId]
	FROM   [dbo].[OrgStructureMapping]
	WHERE  [OrgStructureMapId] = @OrgStructureMapId	and [UserId] = @UserId
	-- End Return Select <- do not remove

	COMMIT
GO

