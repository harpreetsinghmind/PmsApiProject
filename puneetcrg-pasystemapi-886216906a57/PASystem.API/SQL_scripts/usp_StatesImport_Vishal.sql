ALTER PROC [dbo].[usp_StatesImport] 
    @CountryName nvarchar(255),
    @StateName nvarchar(255),
	@StateCode nvarchar(255),
    @InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF EXISTS(SELECT * FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName))
		BEGIN
			IF NOT EXISTS(SELECT * FROM  States WHERE LOWER(StateName) =LOWER(@StateName))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[States] 
									   ([CountryId], 
										[StateName],
										[StateCode], 
										[InActive], 
										[CreatedDate], 
										[Notes])
									SELECT 
										(select CountryId from Countries where LOWER(CountryName) =LOWER(@CountryName)), 
										@StateName,
										@StateCode, 
										@InActive, 
										GETDATE(), 
										@Notes
	
									-- Begin Return Select <- do not remove
									select SCOPE_IDENTITY()
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
					IF @IsDeleted = 1
						BEGIN
							DELETE FROM [States] WHERE LOWER(StateName) =LOWER(@StateName)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [States] 
										SET [CountryId] = (select CountryId from Countries where LOWER(CountryName) =LOWER(@CountryName)), 
											[StateName] = @StateName,
											[StateCode] = @StateCode,
											[InActive] = @InActive, 
											[UpdatedDate]= GETDATE(), 
											[Notes] = @Notes
									WHERE LOWER(StateName) =LOWER(@StateName)
									SELECT TOP 1 StateId FROM [States] WHERE LOWER(StateName) =LOWER(@StateName)--UPDATE
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
				END
		END
	ELSE
		BEGIN
			SELECT -1
		END
