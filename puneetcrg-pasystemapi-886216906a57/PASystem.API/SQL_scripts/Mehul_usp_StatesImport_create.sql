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

/****** Object:  StoredProcedure [dbo].[usp_StatesImport]    Script Date: 8/8/2019 7:02:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_StatesImport] 
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

