USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdateStatus]    Script Date: 3/20/2019 2:47:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_ProjectUpdateStatus] 
    @ProjectId bigint,
    @InActive bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Projects]
	SET     [InActive] = @InActive
	WHERE  [ProjectId] = @ProjectId
	
	-- Begin Return Select <- do not remove
	SELECT *
	FROM   [dbo].[Projects]
	WHERE  [ProjectId] = @ProjectId	
	-- End Return Select <- do not remove

	COMMIT
GO


