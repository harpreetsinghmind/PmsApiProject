ALTER PROC [dbo].[usp_KeywordImport] 
    @LanguageName nvarchar(MAX),
    @Keyword nvarchar(MAX),
	@Value nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF EXISTS(SELECT * FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName))
		BEGIN
			IF NOT EXISTS(SELECT * FROM  LanguageMaster WHERE LOWER(Keyword) =LOWER(@Keyword) AND LanguageId = (SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName)))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[LanguageMaster] 
									   ([LanguageId], 
										[Keyword],
										[Value],
										[CreatedDate])
									SELECT 
										(SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName)), 
										@Keyword,
										@Value, 
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
							DELETE FROM [LanguageMaster] WHERE LOWER(Keyword) =LOWER(@Keyword) AND LanguageId = (SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName))
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [LanguageMaster] 
										SET [Keyword] = @Keyword,
											[Value] = @Value,
											[UpdatedDate]= GETDATE()
									WHERE LOWER(Keyword) =LOWER(@Keyword) AND LanguageId = (SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName))
									--SELECT 1 --UPDATE
									SELECT TOP 1 LanguageMaster.Id FROM  LanguageMaster WHERE LOWER(Keyword) =LOWER(@Keyword) AND LanguageId = (SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName))
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
	-- End Return Select <- do not remove
               
