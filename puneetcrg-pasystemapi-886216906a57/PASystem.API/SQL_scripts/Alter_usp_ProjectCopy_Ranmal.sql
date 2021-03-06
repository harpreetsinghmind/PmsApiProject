USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectCopy]    Script Date: 6/11/2019 3:36:53 PM ******/
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
	
		DECLARE @newProjectId BIGINT
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
			NULL,
			@EndDate,
			NULL,
			@PaymentType,
			@WorkingDays,
			@CreatedBy,
			GETDATE()

		SET @newProjectId = SCOPE_IDENTITY()

		DECLARE Phase_CURSOR CURSOR FAST_FORWARD
		FOR  
			SELECT
				[Id] 
			FROM 
				[dbo].[ProjectPhase] WITH (UPDLOCK)
			WHERE
				ProjectId = @ProjectId
				
		DECLARE @phaseId BIGINT  
		OPEN Phase_CURSOR  
		FETCH NEXT FROM Phase_CURSOR INTO @phaseId
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			DECLARE @newPhaseId BIGINT
			INSERT INTO [dbo].[ProjectPhase]
				([Name]
				,[ProjectId]
				,[StartDate]
				,[EndDate]
				,[Revenue]
				,[Budget]
				,[TargetCost]
				,[VendorTarget]
				,[LaborTarget]
				,[BillingType]
				,[CreatedBy]
				,[CreatedDate]
				,[UpdatedBy]
				,[UpdatedDate]
				,[ActualDate]
				,[Locked]
				,[EstimatedStartDate])
			 SELECT 
				[Name]
			   ,@newProjectId
			   ,NULL
			   ,[EndDate]
			   ,[Revenue]
			   ,[Budget]
			   ,[TargetCost]
			   ,[VendorTarget]
			   ,[LaborTarget]
			   ,[BillingType]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate]
			   ,NULL
			   ,[Locked]
			   ,[EstimatedStartDate] 
			 FROM
				[dbo].[ProjectPhase]
			WHERE 
				Id = @phaseId

			SET @newPhaseId = SCOPE_IDENTITY()

			INSERT INTO [dbo].[ProjectSubPhase]
			   ([Name]
			   ,[PhaseId]
			   ,[StartDate]
			   ,[EndDate]
			   ,[TargetCost]
			   ,[VendorTarget]
			   ,[LaborTarget]
			   ,[BillingType]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate]
			   ,[ActualDate]
			   ,[EstimatedStartDate])
			 SELECT 
				[Name]
			   ,@newPhaseId
			   ,NULL
			   ,[EndDate]
			   ,[TargetCost]
			   ,[VendorTarget]
			   ,[LaborTarget]
			   ,[BillingType]
			   ,[CreatedBy]
			   ,[CreatedDate]
			   ,[UpdatedBy]
			   ,[UpdatedDate]
			   ,NULL
			   ,[EstimatedStartDate] 
			 FROM
				[dbo].[ProjectSubPhase]
			 WHERE 
				PhaseId = @phaseId

			FETCH  FROM Phase_CURSOR INTO  @phaseId
		END  
		CLOSE Phase_CURSOR  
		DEALLOCATE Phase_CURSOR  

	END
	ELSE
	BEGIN
		SELECT -1
	END
	COMMIT
