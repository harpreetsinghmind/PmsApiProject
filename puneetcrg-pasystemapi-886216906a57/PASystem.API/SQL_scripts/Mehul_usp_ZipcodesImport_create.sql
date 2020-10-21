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

/****** Object:  StoredProcedure [dbo].[usp_ZipcodesImport]    Script Date: 8/13/2019 3:54:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_ZipcodesImport] 
	@Zipcode nvarchar(50),
    @CountryName nvarchar(255),
    @StateName nvarchar(255),
	@CityName nvarchar(255),
    @InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF EXISTS(SELECT * FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName)) 
	AND EXISTS(SELECT * FROM States WHERE LOWER(StateName) = LOWER(@StateName) AND CountryId = (SELECT CountryId FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName)))
	AND EXISTS(SELECT * FROM Cities WHERE LOWER(CityName) = LOWER(@CityName) AND StateId = (SELECT StateId from States WHERE LOWER(StateName) = LOWER(@StateName)))
		BEGIN
			IF NOT EXISTS(SELECT * FROM  Zipcodes WHERE LOWER(Zipcode) =LOWER(@Zipcode))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[Zipcodes] 
									   ([Zipcode], 
										[StateId],
										[CityId],
										[InActive], 
										[CreatedDate], 
										[Notes])
									SELECT 
										@CityName, 
										(select StateId from States where LOWER(StateName) =LOWER(@StateName)),
										(select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
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
							DELETE FROM [Zipcodes] WHERE LOWER(Zipcode) =LOWER(@Zipcode)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [Zipcodes] 
										SET [Zipcode] = @Zipcode, 
											[StateId] = (select StateId from States where LOWER(StateName) =LOWER(@StateName)),
											[CityId] = (select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
											[InActive] = @InActive, 
											[UpdatedDate]= GETDATE(), 
											[Notes] = @Notes
									WHERE LOWER(Zipcode) =LOWER(@Zipcode)
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

