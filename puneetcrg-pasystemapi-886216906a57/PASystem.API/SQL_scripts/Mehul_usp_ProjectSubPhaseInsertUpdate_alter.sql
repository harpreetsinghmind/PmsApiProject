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

/****** Object:  StoredProcedure [dbo].[usp_ProjectSubPhaseInsertUpdate]    Script Date: 5/17/2019 3:14:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_ProjectSubPhaseInsertUpdate] 
	@subPhaseId BIGINT = NULL,
	@phaseId BIGINT,
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
	IF @subPhaseId IS NULL
	BEGIN
		INSERT INTO [dbo].[ProjectSubPhase]
           ([Name]
           ,[PhaseId]
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
           ,@phaseId
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
		IF EXISTS(SELECT * FROM [dbo].[ProjectSubPhase] WHERE Id = @subPhaseId)
		BEGIN
			UPDATE [dbo].[ProjectSubPhase]
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
			WHERE ProjectSubPhase.Id = @subPhaseId
			SELECT @subPhaseId
		END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
	COMMIT
GO

