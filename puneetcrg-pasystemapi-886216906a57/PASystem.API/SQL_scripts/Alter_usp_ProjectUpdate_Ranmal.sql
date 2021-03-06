USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdate]    Script Date: 5/3/2019 6:29:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectUpdate] 
	@ProjectId bigint,
   	@Name nvarchar(255),
    @ShortDes nvarchar(550),
    @Desc text,
    @Status int,
    @CustomerId bigint,
    @ProjectTypeId bigint,
    @ProjectSourceId bigint,
    @OfficeId bigint,
    @ManagerId bigint,
    @SalesPersonId bigint,
	@ContactPersonId bigint,
    @InActive bit,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ActualDate DATETIME,
    @UpdatedBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF EXISTS(SELECT * FROM  Projects WHERE ProjectId = @ProjectId)
    BEGIN
		UPDATE  [dbo].[Projects] 
		SET 
			[Name] = @Name, 
			[ShortDescription] = @ShortDes, 
			[Description] = @Desc, 
			[Status] = @Status, 
			[CustomerId] = @CustomerId, 
			[ProjectTypeId] = @ProjectTypeId , 
			[ProjectSourceId] = @ProjectSourceId,
			[OfficeId] = @OfficeId, 
			[ManagerId] = @ManagerId, 
			[SalesPersonId] = @SalesPersonId, 
			[ContactPersonId] = @ContactPersonId, 
			[InActive] = @InActive, 
			[StartDate] = @StartDate,
			[EndDate] = @EndDate,
			[ActualDate] = @ActualDate, 
			[UpdatedBy] = @UpdatedBy, 
			[UpdatedDate] = GETDATE()
		WHERE 
			ProjectId = @ProjectId
	
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
