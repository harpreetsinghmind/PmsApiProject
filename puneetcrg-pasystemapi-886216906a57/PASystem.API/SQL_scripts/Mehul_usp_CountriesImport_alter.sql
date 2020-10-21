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

/****** Object:  StoredProcedure [dbo].[usp_CountriesImport]    Script Date: 9/30/2019 12:44:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CountriesImport] 
    @CountryName nvarchar(255),
    @CountryAbbr nvarchar(50),
	@CurrencyCode nvarchar(50),
    @Currency nvarchar(50),
    @CurrencySymbol nvarchar(50),
    @CountryCode nvarchar(50),
    @InActive bit,
    @CreatedBy nvarchar(255),
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF NOT EXISTS(SELECT * FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName))
    BEGIN
		IF @IsDeleted = 0 
		BEGIN
			IF @allowAdd = 1
			BEGIN
				INSERT INTO [dbo].[Countries] 
				   ([CountryName], 
					[CountryAbbr],
					[CurrencyCode], 
					[Currency], 
					[CurrencySymbol], 
					[CountryCode], 
					[InActive], 
					[CreatedBy], 
					[CreatedDate], 
					[Notes])
				SELECT 
					@CountryName, 
					@CountryAbbr,
					@CurrencyCode, 
					@Currency, 
					@CurrencySymbol, 
					@CountryCode, 
					@InActive, 
					@CreatedBy, 
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
			DELETE FROM [Countries] WHERE LOWER(CountryName) =LOWER(@CountryName)
			SELECT 3 --DELETE
		END
		ELSE
		BEGIN
			IF @allowEdit = 1
			BEGIN
				UPDATE [Countries] 
					SET [CountryName] = @CountryName, 
						[CountryAbbr] = @CountryAbbr,
						[CurrencyCode]= @CurrencyCode, 
						[Currency] = @Currency, 
						[CurrencySymbol] = @CurrencySymbol, 
						[CountryCode] = @CountryCode, 
						[InActive] = @InActive, 
						[UpdatedBy] = @CreatedBy, 
						[UpdatedDate]= GETDATE(), 
						[Notes] = @Notes
				WHERE LOWER(CountryName) =LOWER(@CountryName)
				SELECT 1 --UPDATE
			END
			ELSE
			BEGIN
				SELECT 5
			END
		END
	END
	-- End Return Select <- do not remove
               
	
GO

