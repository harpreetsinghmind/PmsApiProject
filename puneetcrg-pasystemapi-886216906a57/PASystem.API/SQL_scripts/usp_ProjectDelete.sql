USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectDelete]    Script Date: 3/20/2019 2:50:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectDelete] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	DELETE
	FROM [dbo].[Projects]
	WHERE  [ProjectId] = @ProjectId

	COMMIT
GO


