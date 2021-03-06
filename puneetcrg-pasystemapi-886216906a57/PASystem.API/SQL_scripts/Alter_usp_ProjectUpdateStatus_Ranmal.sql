USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdateStatus]    Script Date: 4/3/2019 1:59:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_ProjectUpdateStatus] 
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
	DECLARE @updatedBy NVARCHAR(255)
	SELECT @updatedBy = [Projects].CreatedBy
	FROM   [dbo].[Projects]
	WHERE  [ProjectId] = @ProjectId	

	SELECT *
	FROM   [dbo].[Projects]
	WHERE  [ProjectId] = @ProjectId	
	-- End Return Select <- do not remove
	DECLARE @status NVARCHAR(250)
	IF @InActive = 0
	BEGIN
		SET @status='Active';
	END
	ELSE
	BEGIN
		SET @status='InActive';
	END
	DECLARE @msg NVARCHAR(MAX) = 'Project Status Updated ='+ @status
	EXEC [dbo].[usp_ChangeLogInsert] @ProjectId,1, 'UPDATED', @msg, @updatedBy
	COMMIT
