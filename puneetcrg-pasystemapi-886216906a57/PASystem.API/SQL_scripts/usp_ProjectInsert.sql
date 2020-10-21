USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectInsert]    Script Date: 3/20/2019 2:48:56 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectInsert] 
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
    @CreatedBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  Projects WHERE lower(Name) =LOWER(@Name))
    BEGIN
	INSERT INTO [dbo].[Projects] 
		([Name], 
		[Code], 
		[ShortDescription], 
		[Description], 
		[SquareFootage],
		[Type], 
		[GroundUp],
		[BuildingContractCost], 
		[Status], 
		[CustomerId], 
		[ProjectTypeId], 
		[ProjectSourceId],
		[OfficeId], 
		[ManagerId], 
		[SalesPersonId], 
		[InActive], 
		[CreatedBy], 
		[CreatedDate])
	SELECT 
		@Name, 
		@Code, 
		@ShortDes,
		@Desc, 
		@SquareFootage, 
		@Type, 
		@GroundUp,
		@BuildingContractCost,
		@Status,
		@CustomerId,
		@ProjectTypeId,
		@ProjectSourceId,
		@OfficeId,
		@ManagerId,
		@SalesPersonId,
		@InActive,
		@CreatedBy,
		GETDATE()
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
    end
	ELSE
	BEGIN
	SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
GO


