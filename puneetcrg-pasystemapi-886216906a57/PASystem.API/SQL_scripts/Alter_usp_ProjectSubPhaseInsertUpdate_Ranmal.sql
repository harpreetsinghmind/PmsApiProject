USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectSubPhaseInsertUpdate]    Script Date: 4/19/2019 3:28:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectSubPhaseInsertUpdate] 
	@subPhaseId BIGINT = NULL,
	@phaseId BIGINT,
   	@name NVARCHAR(255),
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
	IF @subPhaseId IS NULL
	BEGIN
		INSERT INTO [dbo].[ProjectSubPhase]
           ([Name]
           ,[PhaseId]
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
           ,@phaseId
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
		IF EXISTS(SELECT * FROM [dbo].[ProjectSubPhase] WHERE Id = @subPhaseId)
		BEGIN
			UPDATE [dbo].[ProjectSubPhase]
			SET [Name] = @name
			  ,[StartDate] = @startDate
			  ,[EndDate] = @endDate
			  ,[ActualDate] = @actualDate
			  ,[TargetCost] = @targetCost
			  ,[VendorTarget] = @vendorTarget
			  ,[LaborTarget] = @laborTarget
			  ,[BillingType] = @billingType
			  ,[UpdatedBy] = @createdBy
			  ,[UpdatedDate] = GETDATE()
			WHERE ProjectSubPhase.Id = @subPhaseId
			SELECT @subPhaseId
		END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
	COMMIT
