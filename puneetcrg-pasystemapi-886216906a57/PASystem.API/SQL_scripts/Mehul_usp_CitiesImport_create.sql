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

/****** Object:  StoredProcedure [dbo].[usp_CitiesImport]    Script Date: 8/12/2019 3:05:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_CitiesImport] 
    @CountryName nvarchar(255),
    @StateName nvarchar(255),
	@CityName nvarchar(255),
	@AreaCode nvarchar(255),
	@CityCode nvarchar(255),
	@County nvarchar(255),
    @InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF EXISTS(SELECT * FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName)) 
	AND EXISTS(SELECT * FROM States WHERE LOWER(StateName) = LOWER(@StateName) AND CountryId = (SELECT CountryId FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName)))
		BEGIN
			IF NOT EXISTS(SELECT * FROM  Cities WHERE LOWER(CityName) =LOWER(@CityName))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[Cities] 
									   ([CityName], 
										[StateId],
										[AreaCode],
										[CityCode],
										[County],
										[InActive], 
										[CreatedDate], 
										[Notes])
									SELECT 
										@CityName, 
										(select StateId from States where LOWER(StateName) =LOWER(@StateName)),
										@AreaCode,
										@CityCode,
										@County,
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
							DELETE FROM [Cities] WHERE LOWER(CityName) =LOWER(@CityName)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [Cities] 
										SET [CityName] = @CityName, 
											[StateId] = (select StateId from States where LOWER(StateName) =LOWER(@StateName)),
											[AreaCode] = @AreaCode,
											[CityCode] = @CityCode,
											[County] = @County,
											[InActive] = @InActive, 
											[UpdatedDate]= GETDATE(), 
											[Notes] = @Notes
									WHERE LOWER(CityName) =LOWER(@CityName)
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

