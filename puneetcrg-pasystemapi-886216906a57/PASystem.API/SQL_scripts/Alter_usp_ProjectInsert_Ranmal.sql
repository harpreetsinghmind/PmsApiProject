USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectInsert]    Script Date: 5/3/2019 6:29:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectInsert] 
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
    @CreatedBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  Projects WHERE lower(Name) =LOWER(@Name))
    BEGIN
	DECLARE @projectCode NVARCHAR(MAX), @lastProjectId BIGINT, @initVal BIGINT =1
	SELECT TOP 1 @lastProjectId = ProjectId FROM Projects ORDER BY ProjectId DESC
	SELECT @lastProjectId = (ISNULL(@lastProjectId, 0) + @initVal)
	SET @projectCode = 'PRJ' + FORMAT(@lastProjectId,'00#')

	INSERT INTO [dbo].[Projects] 
		([Name], 
		[Code], 
		[ShortDescription], 
		[Description], 
		[Status], 
		[CustomerId], 
		[ProjectTypeId], 
		[ProjectSourceId],
		[OfficeId], 
		[ManagerId], 
		[SalesPersonId], 
		[ContactPersonId], 
		[InActive],
		[StartDate],
		[EndDate],
		[ActualDate], 
		[CreatedBy], 
		[CreatedDate])
	SELECT 
		@Name, 
		@projectCode, 
		@ShortDes,
		@Desc, 
		@Status,
		@CustomerId,
		@ProjectTypeId,
		@ProjectSourceId,
		@OfficeId,
		@ManagerId,
		@SalesPersonId,
		@ContactPersonId,
		@InActive,
		@StartDate,
		@EndDate,
		@ActualDate,
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
