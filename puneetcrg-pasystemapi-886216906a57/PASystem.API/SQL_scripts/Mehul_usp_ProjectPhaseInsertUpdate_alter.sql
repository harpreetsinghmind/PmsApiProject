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

/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseInsertUpdate]    Script Date: 5/17/2019 3:15:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[usp_ProjectPhaseInsertUpdate] 
	@phaseId BIGINT = NULL,
   	@name NVARCHAR(255),
	@eStartDate DATETIME,
    @startDate DATETIME,
    @endDate DATETIME,
	@actualDate DATETIME,
    @projectId BIGINT,
    @revenue NUMERIC(18,2),
    @budget NUMERIC(18,2),
    @targetCost NUMERIC(18,2),
    @vendorTarget NUMERIC(18,2),
    @laborTarget NUMERIC(18,2),
    @billingType int = NULL,
	@Locked bit = NULL,
    @createdBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF @phaseId IS NULL
	BEGIN
		INSERT INTO [dbo].[ProjectPhase]
           ([Name]
           ,[ProjectId]
		   ,[EstimatedStartDate]
           ,[StartDate]
           ,[EndDate]
		   ,[ActualDate]
           ,[Revenue]
           ,[Budget]
           ,[TargetCost]
           ,[VendorTarget]
           ,[LaborTarget]
           ,[BillingType]
		   ,[Locked]
           ,[CreatedBy]
           ,[CreatedDate])
		 VALUES
           (@name
           ,@projectId
		   ,@eStartDate
           ,@startDate
           ,@endDate
		   ,@actualDate
           ,@revenue
           ,@budget
           ,@targetCost
           ,@vendorTarget
           ,@laborTarget
           ,@billingType
		   ,@Locked
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
				,[EstimatedStartDate] = @eStartDate
			  ,[StartDate] = @startDate
			  ,[EndDate] = @endDate
			  ,[ActualDate] = @actualDate
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

