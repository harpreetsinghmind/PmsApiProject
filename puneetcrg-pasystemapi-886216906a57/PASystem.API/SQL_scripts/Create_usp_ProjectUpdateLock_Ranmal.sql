USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdateLock]    Script Date: 5/3/2019 4:30:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_ProjectUpdateLock] 
    @ProjectId bigint,
    @Locked bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Projects]
	SET    [Locked] = @Locked
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
	IF @Locked = 0
	BEGIN
		SET @status='Locked';
	END
	ELSE
	BEGIN
		SET @status='UnLocked';
	END
	DECLARE @msg NVARCHAR(MAX) = 'Project Status Updated ='+ @status
	EXEC [dbo].[usp_ChangeLogInsert] @ProjectId,1, 'UPDATED', @msg, @updatedBy
	COMMIT
