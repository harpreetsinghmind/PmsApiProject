ALTER PROC [dbo].[usp_LanguagesImport] 
	@Name nvarchar(10),
	@DisplayName nvarchar(100),
	@IsDefault bit,
    @InActive bit,
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
			IF NOT EXISTS(SELECT * FROM  Languages WHERE LOWER(Name) =LOWER(@Name))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[Languages] 
									   ([Name], 
										[DisplayName],
										[Isdefault],
										[InActive], 
										[CreatedDate])
									SELECT 
										@Name, 
										@DisplayName,
										@IsDefault,
										@InActive, 
										GETDATE()
	
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
							DELETE FROM [Languages] WHERE LOWER(Name) =LOWER(@Name)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [Languages] 
										SET [Name] = @Name, 
											[DisplayName] = @DisplayName,
											[Isdefault] = @IsDefault,
											[InActive] = @InActive, 
											[UpdatedDate]= GETDATE()
									WHERE LOWER(Name) =LOWER(@Name)
									SELECT TOP 1 LanguageId FROM [Languages] WHERE LOWER(Name) =LOWER(@Name)  --UPDATE
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
				END
	-- End Return Select <- do not remove
