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

/****** Object:  StoredProcedure [dbo].[usp_KeywordImport]    Script Date: 8/21/2019 3:31:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_KeywordImport] 
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
									WHERE LanguageId = (SELECT LanguageId FROM  Languages WHERE LOWER(DisplayName) =LOWER(@LanguageName))
									SELECT 1 --UPDATE
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
               
	
GO

