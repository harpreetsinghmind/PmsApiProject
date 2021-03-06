/****** Object:  StoredProcedure [dbo].[usp_ProjectCopy]    Script Date: 22-12-2019 10:57:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectCopy] 
    @ProjectId bigint, @NewCustomerId bigint, @ProjectName NVARCHAR(255), 
	@NewSalesPersonId bigint = NULL, @NewContactPersonId bigint = NULL, @NewOfficeId bigint = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @Name NVARCHAR(255), @ShortDes NVARCHAR(550), @Desc NVARCHAR(MAX), @Status INT, @CustomerId BIGINT, @ProjectTypeId BIGINT,
			@ProjectSourceId BIGINT, @OfficeId BIGINT, @ManagerId BIGINT, @SalesPersonId BIGINT, @ContactPersonId BIGINT, @InActive BIT,
			@PlannedStartDate DATETIME, @StartDate DATETIME, @EndDate DATETIME, @ActualDate DATETIME, @CreatedBy NVARCHAR(255), 
			@PaymentType int, @WorkingDays nvarchar(255)

	SELECT @Name= Name, @ShortDes = ShortDescription, @Desc = Description, @Status = Status, @CustomerId = CustomerId, @ProjectTypeId = ProjectTypeId, @ProjectSourceId = ProjectSourceId,
			@OfficeId = OfficeId, @ManagerId = ManagerId, @SalesPersonId = SalesPersonId, @ContactPersonId = ContactPersonId, @InActive =InActive, @PlannedStartDate  = PlannedStartDate,
			@StartDate = StartDate, @EndDate = EndDate, @ActualDate = ActualDate, @CreatedBy = CreatedBy, @PaymentType = PaymentType, @WorkingDays = WorkingDays
	FROM Projects WHERE ProjectId= @ProjectId

	DECLARE @projectCode NVARCHAR(MAX), @lastProjectId BIGINT, @initVal BIGINT =1
	SELECT TOP 1 @lastProjectId = ProjectId FROM Projects ORDER BY ProjectId DESC
	SELECT @lastProjectId = (ISNULL(@lastProjectId, 0) + @initVal)
	SET @projectCode = 'PRJ' + FORMAT(@lastProjectId,'00#')
	
	IF NOT EXISTS(select * from Projects where LOWER(Name) = @ProjectName and CustomerId = @NewCustomerId)
	BEGIN
		DECLARE @newProjectId BIGINT
		INSERT INTO [dbo].[Projects] 
			([Name],[Code], [ShortDescription], [Description], [Status], [CustomerId], [ProjectTypeId], [ProjectSourceId], [OfficeId], [ManagerId], [SalesPersonId], [ContactPersonId], 
			[InActive], [PlannedStartDate], [StartDate], [EndDate], [ActualDate], [PaymentType], [WorkingDays], [CreatedBy], [CreatedDate])
		SELECT @ProjectName, @projectCode, @ShortDes, @Desc, @Status, @NewCustomerId, @ProjectTypeId, @ProjectSourceId,
			CASE WHEN @NewOfficeId IS NULL THEN @OfficeId ELSE @NewOfficeId END,
			@ManagerId,
			CASE WHEN @NewSalesPersonId IS NULL THEN @SalesPersonId ELSE @NewSalesPersonId END,
			CASE WHEN @NewContactPersonId IS NULL THEN @ContactPersonId ELSE @NewContactPersonId END,
			@InActive, @PlannedStartDate, NULL, @EndDate, NULL, @PaymentType, @WorkingDays, @CreatedBy, GETDATE()

		SET @newProjectId = SCOPE_IDENTITY()

		DECLARE @CopyProject TABLE(SNo INT IDENTITY(1,1) PRIMARY KEY NOT NULL, PSeqID INT, SPSeqID INT, TSeqID INT, STSeqID INT, Id INT, ParentId INT, PhLevel INT, Name varchar(max));
		INSERT INTO @CopyProject
		EXEC usp_ProjectPhaseLevels @ProjectId

		DECLARE @index INT, @rowCnt INT, @NewPhaseId INT, @NewSubPhaseId INT, @NewTaskId INT,  @PhLevel INT
		SELECT @index = 1, @rowCnt = COUNT(Id) FROM @CopyProject
		WHILE (@index <= @rowCnt)
		BEGIN
			IF ((SELECT PhLevel FROM @CopyProject WHERE SNo = @index) = 1)
			BEGIN
				INSERT INTO [dbo].[ProjectPhase]
					([Name] ,[ProjectId] ,[StartDate] ,[EndDate] ,[Revenue] ,[Budget] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy]
					,[UpdatedDate] ,[ActualDate] ,[Locked] ,[EstimatedStartDate])
				SELECT [Name] ,@newProjectId ,NULL ,[EndDate] ,[Revenue] ,[Budget] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy]
				   ,[UpdatedDate] ,NULL ,[Locked] ,[EstimatedStartDate] 
				FROM [dbo].[ProjectPhase] WHERE Id IN (SELECT Id FROM @CopyProject WHERE SNo = @index);
				 
				SET @NewPhaseId = SCOPE_IDENTITY();
			END

			IF ((SELECT PhLevel FROM @CopyProject WHERE SNo = @index) = 2)
			BEGIN
				INSERT INTO [dbo].[ProjectSubPhase]
					([Name] ,[PhaseId] ,[StartDate] ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,[ActualDate] ,[EstimatedStartDate])
				SELECT [Name] ,@NewPhaseId ,NULL ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,NULL ,[EstimatedStartDate] 
				FROM [dbo].[ProjectSubPhase] WHERE Id IN (SELECT Id FROM @CopyProject WHERE SNo = @index);

				SET @NewSubPhaseId = SCOPE_IDENTITY();
			END

			IF ((SELECT PhLevel FROM @CopyProject WHERE SNo = @index) = 3)
			BEGIN
				INSERT INTO [dbo].[ProjectTask]
					([Name] ,[SubPhaseId] ,[StartDate] ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,[ActualDate] ,[EstimatedStartDate])
				SELECT [Name] ,@NewSubPhaseId ,NULL ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,NULL ,[EstimatedStartDate] 
				FROM [dbo].[ProjectTask] WHERE Id IN (SELECT Id FROM @CopyProject WHERE SNo = @index);

				SET @NewTaskId = SCOPE_IDENTITY();
			END

			IF ((SELECT PhLevel FROM @CopyProject WHERE SNo = @index) = 4)
			BEGIN
				INSERT INTO [dbo].[ProjectSubTask]
					([Name] ,[TaskId] ,[StartDate] ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,[ActualDate] ,[EstimatedStartDate])
				SELECT [Name] ,@NewTaskId ,NULL ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,NULL ,[EstimatedStartDate] 
				FROM [dbo].[ProjectSubTask] WHERE Id IN (SELECT Id FROM @CopyProject WHERE SNo = @index);
			END

			SET @index = @index + 1;
		END

		--DECLARE Phase_CURSOR CURSOR FAST_FORWARD
		--FOR  
		--	SELECT [Id] FROM [dbo].[ProjectPhase] WITH (UPDLOCK)
		--	WHERE ProjectId = @ProjectId
				
		--DECLARE @phaseId BIGINT  
		--OPEN Phase_CURSOR  
		--FETCH NEXT FROM Phase_CURSOR INTO @phaseId
		--WHILE @@FETCH_STATUS = 0  
		--BEGIN 
		--	DECLARE @newPhaseId BIGINT
		--	INSERT INTO [dbo].[ProjectPhase]
		--		([Name] ,[ProjectId] ,[StartDate] ,[EndDate] ,[Revenue] ,[Budget] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy]
		--		,[UpdatedDate] ,[ActualDate] ,[Locked] ,[EstimatedStartDate])
		--	 SELECT [Name] ,@newProjectId ,NULL ,[EndDate] ,[Revenue] ,[Budget] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy]
		--	   ,[UpdatedDate] ,NULL ,[Locked] ,[EstimatedStartDate] 
		--	 FROM [dbo].[ProjectPhase] WHERE  Id = @phaseId

		--	SET @newPhaseId = SCOPE_IDENTITY()

		--	INSERT INTO [dbo].[ProjectSubPhase]
		--	   ([Name] ,[PhaseId] ,[StartDate] ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,[ActualDate] ,[EstimatedStartDate])
		--	SELECT [Name] ,@newPhaseId ,NULL ,[EndDate] ,[TargetCost] ,[VendorTarget] ,[LaborTarget] ,[BillingType] ,[CreatedBy] ,[CreatedDate] ,[UpdatedBy] ,[UpdatedDate] ,NULL ,[EstimatedStartDate] 
		--	FROM [dbo].[ProjectSubPhase] WHERE PhaseId = @phaseId

		--	FETCH  FROM Phase_CURSOR INTO  @phaseId
		--END  
		--CLOSE Phase_CURSOR  
		--DEALLOCATE Phase_CURSOR

	END
	ELSE
	BEGIN
		SELECT -1
	END
	COMMIT
