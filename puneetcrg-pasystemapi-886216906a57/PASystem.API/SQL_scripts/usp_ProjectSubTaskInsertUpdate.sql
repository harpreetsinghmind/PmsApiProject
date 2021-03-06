/****** Object:  StoredProcedure [dbo].[usp_ProjectSubTaskInsertUpdate]    Script Date: 17-12-2019 10:48:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_ProjectSubTaskInsertUpdate] 
	@subTaskId BIGINT = NULL,
	@taskId BIGINT,
   	@name NVARCHAR(255),
	@eStartDate DATETIME,
    @startDate DATETIME,
    @endDate DATETIME,
	@actualDate DATETIME,
    @targetCost NUMERIC(18,2),
    @vendorTarget NUMERIC(18,2),
    @laborTarget NUMERIC(18,2),
    @billingType int = NULL,
    @createdBy nvarchar(255) = NULL
  
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF @subTaskId IS NULL
	BEGIN
		INSERT INTO [dbo].[ProjectSubTask]
           ([Name]
           ,[TaskId]
		   ,[EstimatedStartDate]
           ,[StartDate]
           ,[EndDate]
		   ,[ActualDate]
           ,[TargetCost]
           ,[VendorTarget]
           ,[LaborTarget]
           ,[BillingType]
           ,[CreatedBy]
           ,[CreatedDate])
		 VALUES
           (@name
           ,@taskId
		   ,@eStartDate
           ,@startDate
           ,@endDate
		   ,@actualDate
           ,@targetCost
           ,@vendorTarget
           ,@laborTarget
           ,@billingType
           ,@createdBy
           ,GETDATE())
		SELECT SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT * FROM [dbo].[ProjectSubTask] WHERE Id = @subTaskId)
		BEGIN
			UPDATE [dbo].[ProjectSubTask]
			SET [Name] = @name
			,[EstimatedStartDate] = @eStartDate
			  ,[StartDate] = @startDate
			  ,[EndDate] = @endDate
			  ,[ActualDate] = @actualDate
			  ,[TargetCost] = @targetCost
			  ,[VendorTarget] = @vendorTarget
			  ,[LaborTarget] = @laborTarget
			  ,[BillingType] = @billingType
			  ,[UpdatedBy] = @createdBy
			  ,[UpdatedDate] = GETDATE()
			WHERE ProjectsubTask.Id = @subTaskId
			SELECT @subTaskId
		END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
	COMMIT
