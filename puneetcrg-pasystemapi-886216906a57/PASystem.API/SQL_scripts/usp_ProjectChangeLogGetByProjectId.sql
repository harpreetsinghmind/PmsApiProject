USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectChangeLogGetByProjectId]    Script Date: 3/20/2019 2:49:31 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectChangeLogGetByProjectId] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT *
	FROM   [dbo].[ProjectChangeLog] 
	WHERE  [ProjectId] = @ProjectId

	COMMIT
GO


