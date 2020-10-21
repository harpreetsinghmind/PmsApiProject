/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectCopy]    Script Date: 6/7/2019 11:30:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[usp_ProjectCopy] 
    @ProjectId bigint,
	@NewCustomerId bigint,
	@ProjectName NVARCHAR(255),
	@NewSalesPersonId bigint = NULL,
	@NewContactPersonId bigint = NULL,
	@NewOfficeId bigint = NULL
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
	@PlannedStartDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ActualDate DATETIME,
    @CreatedBy NVARCHAR(255),
	@PaymentType int,
	@WorkingDays nvarchar(255)


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
		@PlannedStartDate  = PlannedStartDate,
		@StartDate = StartDate,
		@EndDate = EndDate,
		@ActualDate = ActualDate,
		@CreatedBy = CreatedBy,
		@PaymentType = PaymentType,
		@WorkingDays = WorkingDays
	FROM 
		Projects
	WHERE ProjectId= @ProjectId

	DECLARE @projectCode NVARCHAR(MAX), @lastProjectId BIGINT, @initVal BIGINT =1
	SELECT TOP 1 @lastProjectId = ProjectId FROM Projects ORDER BY ProjectId DESC
	SELECT @lastProjectId = (ISNULL(@lastProjectId, 0) + @initVal)
	SET @projectCode = 'PRJ' + FORMAT(@lastProjectId,'00#')
IF NOT EXISTS(select * from Projects where LOWER(Name) = @ProjectName and CustomerId = @NewCustomerId)
BEGIN
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
		[PlannedStartDate],
		[StartDate],
		[EndDate],
		[ActualDate], 
		[PaymentType],
		[WorkingDays],
		[CreatedBy], 
		[CreatedDate])
	SELECT 
		@ProjectName, 
		@projectCode, 
		@ShortDes,
		@Desc, 
		@Status,
		@NewCustomerId,
		@ProjectTypeId,
		@ProjectSourceId,
		CASE WHEN @NewOfficeId IS NULL
			THEN @OfficeId
			ELSE @NewOfficeId
			END,
		@ManagerId,
		CASE WHEN @NewSalesPersonId IS NULL
			THEN @SalesPersonId
			ELSE @NewSalesPersonId
			END,
		CASE WHEN @NewContactPersonId IS NULL
			THEN @ContactPersonId
			ELSE @NewContactPersonId
			END,
		@InActive,
		@PlannedStartDate,
		@StartDate,
		@EndDate,
		@ActualDate,
		@PaymentType,
		@WorkingDays,
		@CreatedBy,
		GETDATE()
END
ELSE
BEGIN
SELECT -1
END
	COMMIT
GO

