USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdateActualEndDate]    Script Date: 7/1/2019 6:02:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectUpdateActualEndDate] 
	@ProjectId bigint,
	@EndDate DATETIME,
	@ShortDesc nvarchar(Max),
    @UpdatedBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF EXISTS(SELECT * FROM  Projects WHERE ProjectId = @ProjectId)
    BEGIN
		IF @ShortDesc IS NOT NULL
		BEGIN
			UPDATE  [dbo].[Projects] 
			SET 
				[ActualDate] = NULL,
				[EndDate] =@EndDate, 
				[UpdatedBy] = @UpdatedBy, 
				[UpdatedDate] = GETDATE()
			WHERE 
				ProjectId = @ProjectId
		
		
			INSERT INTO [dbo].[ProjectReOpenDetail]
				   ([ProjectId]
				   ,[ReOpenDate]
				   ,[Reason]
				   ,[CreatedBy]
				   ,[CreatedDate])
			 VALUES
				   (@ProjectId
				   ,GETDATE()
				   ,@ShortDesc
				   ,@UpdatedBy
				   ,GETDATE())
		END
		ELSE
		BEGIN
			UPDATE  [dbo].[Projects] 
			SET 
				[ActualDate] = @EndDate,
				[UpdatedBy] = @UpdatedBy, 
				[UpdatedDate] = GETDATE()
			WHERE 
				ProjectId = @ProjectId
		END
		-- Begin Return Select <- do not remove
		SELECT 
			ProjectId
		FROM   
			[dbo].[Projects]
		WHERE 
			 ProjectId = @ProjectId	
    END
	ELSE
	BEGIN
		SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
