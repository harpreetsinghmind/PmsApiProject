USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseInsertUpdate]    Script Date: 4/3/2019 5:50:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectPhaseInsertUpdate] 
	@phaseId BIGINT = NULL,
   	@name NVARCHAR(255),
    @startDate DATETIME,
    @endDate DATETIME,
    @projectId BIGINT,
    @revenue NUMERIC(18,2),
    @budget NUMERIC(18,2),
    @targetCost NUMERIC(18,2),
    @vendorTarget NUMERIC(18,2),
    @laborTarget NUMERIC(18,2),
    @billingType INT = NULL,
    @createdBy NVARCHAR(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF @phaseId IS NULL
	BEGIN
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
           ,[CreatedDate])
		 VALUES
           (@name
           ,@projectId
           ,@startDate
           ,@endDate
           ,@revenue
           ,@budget
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
		IF EXISTS(SELECT * FROM [dbo].[ProjectPhase] WHERE Id = @phaseId)
		BEGIN
			UPDATE [dbo].[ProjectPhase]
			SET [Name] = @name
			  ,[StartDate] = @startDate
			  ,[EndDate] = @endDate
			  ,[Revenue] = @revenue
			  ,[Budget] = @budget
			  ,[TargetCost] = @targetCost
			  ,[VendorTarget] = @vendorTarget
			  ,[LaborTarget] = @laborTarget
			  ,[BillingType] = @billingType
			  ,[UpdatedBy] = @createdBy
			  ,[UpdatedDate] = GETDATE()
			WHERE ProjectPhase.Id = @phaseId
			SELECT @phaseId
		END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
	COMMIT
GO


