/****** Object:  StoredProcedure [dbo].[usp_ProjectTaskInsertUpdate]    Script Date: 17-12-2019 10:47:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_ProjectTaskInsertUpdate] 
	@taskId BIGINT = NULL,
	@subPhaseId BIGINT,
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
	IF @taskId IS NULL
	BEGIN
		INSERT INTO [dbo].[ProjectTask]
           ([Name]
           ,[SubPhaseId]
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
           ,@subPhaseId
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
		IF EXISTS(SELECT * FROM [dbo].[ProjectTask] WHERE Id = @taskId)
		BEGIN
			UPDATE [dbo].[ProjectTask]
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
			WHERE ProjectTask.Id = @taskId
			SELECT @taskId
		END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
	COMMIT
GO
