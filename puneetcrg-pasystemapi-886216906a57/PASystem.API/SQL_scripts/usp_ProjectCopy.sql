USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectCopy]    Script Date: 4/4/2019 3:26:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectCopy] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @Name NVARCHAR(255),
    @ShortDes NVARCHAR(550),
    @Desc NVARCHAR(MAX),
    @Status INT,
    @CustomerId BIGINT,
    @ProjectTypeId BIGINT,
    @ProjectSourceId BIGINT,
    @OfficeId BIGINT,
    @ManagerId BIGINT,
    @SalesPersonId BIGINT,
	@ContactPersonId BIGINT,
    @InActive BIT,
    @CreatedBy NVARCHAR(255)


	SELECT 
		@Name= Name,
		@ShortDes = ShortDescription,
		@Desc = Description,
		@Status = Status,
		@CustomerId = CustomerId,
		@ProjectTypeId = ProjectTypeId,
		@ProjectSourceId = ProjectSourceId,
		@OfficeId = OfficeId,
		@ManagerId = ManagerId,
		@SalesPersonId = SalesPersonId,
		@ContactPersonId = ContactPersonId,
		@InActive =InActive,
		@CreatedBy = CreatedBy
	FROM 
		Projects
	WHERE ProjectId= @ProjectId

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
		@CreatedBy,
		GETDATE()
	
	COMMIT
