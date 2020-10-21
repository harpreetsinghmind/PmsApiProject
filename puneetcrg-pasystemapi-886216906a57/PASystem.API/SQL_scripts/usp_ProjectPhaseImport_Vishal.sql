CREATE PROC [dbo].[usp_ProjectPhaseImport] 
   	@phaseName NVARCHAR(255),
	@eStartDate DATETIME,
    @startDate DATETIME,
    @endDate DATETIME,
	@actualDate DATETIME,
    @projectName NVARCHAR(250),
    @revenue NUMERIC(18,2),
    @budget NUMERIC(18,2),
    @targetCost NUMERIC(18,2),
    @vendorTarget NUMERIC(18,2),
    @laborTarget NUMERIC(18,2),
    @billingType int = NULL,
	@Locked bit = NULL,
    @createdBy nvarchar(255) = NULL,
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit,
	@subphasename NVARCHAR(255),
	@subeStartDate DATETIME,
    @substartDate DATETIME,
    @subendDate DATETIME,
	@subactualDate DATETIME,
    @subtargetCost NUMERIC(18,2),
    @subvendorTarget NUMERIC(18,2),
    @sublaborTarget NUMERIC(18,2),
    @subbillingType int = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DECLARE @ProjectId BIGINT, @phaseId BIGINT

	SET @ProjectId = (SELECT TOP 1 ProjectId FROM Projects WHERE [Name] = @projectName)
	SET @phaseId = (SELECT TOP 1 Id FROM [ProjectPhase] WHERE [Name] = @phaseName)

	IF(@ProjectId IS NOT NULL AND @ProjectId <> '')
		BEGIN

			IF @phaseId is NULL 
				BEGIN
					IF @IsDeleted = 0 
					BEGIN
						IF @allowAdd = 1
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
												   (@phaseName
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
								SET @phaseId = SCOPE_IDENTITY()

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
																   (@subphasename
																   ,@phaseId
																   ,@subeStartDate
																   ,@substartDate
																   ,@subendDate
																   ,@subactualDate
																   ,@subtargetCost
																   ,@subvendorTarget
																   ,@sublaborTarget
																   ,@subbillingType
																   ,@createdBy
																   ,GETDATE())

								SELECT @phaseId
							END
					ELSE
						BEGIN
							SELECT 5
							END
				END
			ELSE
				BEGIN
					SELECT 2 --NOT FOUND
				END
		END
			ELSE
				BEGIN
					IF EXISTS(SELECT * FROM [dbo].[ProjectPhase] WHERE Id = @phaseId)
					BEGIN
						IF @IsDeleted = 1
						BEGIN
							--DELETE FROM [Countries] WHERE LOWER(CountryName) =LOWER(@CountryName)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
						IF @allowEdit = 1
						BEGIN

								UPDATE [dbo].[ProjectPhase]
														SET [Name] = @phaseName
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

								DECLARE @subPhaseId INT

								SET @subPhaseId = (SELECT TOP 1 Id FROM ProjectSubPhase WHERE [Name] = @subphasename)

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
										   (@subphasename
										   ,@phaseId
										   ,@subeStartDate
										   ,@substartDate
										   ,@subendDate
										   ,@subactualDate
										   ,@subtargetCost
										   ,@subvendorTarget
										   ,@sublaborTarget
										   ,@subbillingType
										   ,@createdBy
										   ,GETDATE())
										SELECT SCOPE_IDENTITY()
									END
								ELSE
									BEGIN
											IF EXISTS(SELECT * FROM [dbo].[ProjectSubPhase] WHERE Id = @subPhaseId)
											BEGIN
													UPDATE [dbo].[ProjectSubPhase]
																				SET [Name] = @subphasename
																				  ,[EstimatedStartDate] = @subeStartDate
																				  ,[StartDate] = @substartDate
																				  ,[EndDate] = @subendDate
																				  ,[ActualDate] = @subactualDate
																				  ,[TargetCost] = @subtargetCost
																				  ,[VendorTarget] = @subvendorTarget
																				  ,[LaborTarget] = @sublaborTarget
																				  ,[BillingType] = @subbillingType
																				  ,[UpdatedBy] = @createdBy
																				  ,[UpdatedDate] = GETDATE()
													WHERE ProjectSubPhase.Id = @subPhaseId
													SELECT @subPhaseId
											END
											ELSE
											BEGIN
												SELECT -3
											END
									END

						END
					ELSE
						BEGIN
							SELECT 5
						END

				END
        END
		ELSE
		BEGIN
			SELECT -1
		END
	END
	
		END
	ELSE
		BEGIN
			SELECT -2
		END


	COMMIT

