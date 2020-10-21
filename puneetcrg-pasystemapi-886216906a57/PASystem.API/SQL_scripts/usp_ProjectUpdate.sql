USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdate]    Script Date: 3/20/2019 2:48:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectUpdate] 
	@ProjectId bigint,
   	@Name nvarchar(255),
    @Code nvarchar(250),
    @ShortDes nvarchar(550),
    @Desc text,
    @SquareFootage nvarchar(max),
    @Type nvarchar(50),
	@GroundUp bit,
    @BuildingContractCost numeric(18,2),
    @Status int,
    @CustomerId bigint,
    @ProjectTypeId bigint,
    @ProjectSourceId bigint,
    @OfficeId bigint,
    @ManagerId bigint,
    @SalesPersonId bigint,
    @InActive bit,
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
			[Code] = @Code, 
			[ShortDescription] = @ShortDes, 
			[Description] = @Desc, 
			[SquareFootage] = @SquareFootage,
			[Type] = @Type, 
			[GroundUp] = @GroundUp,
			[BuildingContractCost] = @BuildingContractCost, 
			[Status] = @Status, 
			[CustomerId] = @CustomerId, 
			[ProjectTypeId] = @ProjectTypeId , 
			[ProjectSourceId] = @ProjectSourceId,
			[OfficeId] = @OfficeId, 
			[ManagerId] = @ManagerId, 
			[SalesPersonId] = @SalesPersonId, 
			[InActive] = @InActive, 
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
GO


