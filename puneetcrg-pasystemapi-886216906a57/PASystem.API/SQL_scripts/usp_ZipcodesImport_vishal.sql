ALTER PROC [dbo].[usp_ZipcodesImport] 
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
									SELECT TOP 1 ZipcodeId FROM [Zipcodes] WHERE LOWER(Zipcode) =LOWER(@Zipcode) --UPDATE
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
	