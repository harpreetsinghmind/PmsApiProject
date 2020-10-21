USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetChangeLogById]    Script Date: 4/1/2019 5:50:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_GetChangeLogById] 
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
	WHERE  EntityId = @entityId  AND ModuleId = @moduleId

	COMMIT
