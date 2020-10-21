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

/****** Object:  StoredProcedure [dbo].[usp_GetChangeLogById]    Script Date: 8/19/2019 7:03:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_GetChangeLogById] 
    @entityId BIGINT,
	@moduleId BIGINT
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		Id,
		ModuleId,
		EntityId,
		Change,
		Detail,
		UpdatedDate AS Date,
		UpdatedBy
	FROM  [dbo].[ChangeLog] 
	WHERE  EntityId = @entityId  AND ModuleId = @moduleId order by Date desc

	COMMIT
GO

