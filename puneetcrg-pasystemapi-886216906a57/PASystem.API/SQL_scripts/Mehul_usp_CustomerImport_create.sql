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

/****** Object:  StoredProcedure [dbo].[usp_CustomerImport]    Script Date: 9/9/2019 2:14:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Batch submitted through debugger: SQLQuery5.sql|20|0|C:\Users\Administrator\AppData\Local\Temp\~vs5000.sql


CREATE PROC [dbo].[usp_CustomerImport] 
	@CustomerName nvarchar(1000),
	@CustomerCode nvarchar(50),
	@BusinessTypeName nvarchar(MAX),
	@FaxNo nvarchar(MAX),
	@Website nvarchar(MAX),
	@Status nvarchar(MAX),
	@ParentCustomerName nvarchar(MAX),
	@ContactPersonTitle nvarchar(MAX),
	@ContactPersonFirstName nvarchar(MAX),
	@ContactPersonLastName nvarchar(MAX),
	@ContactPersonMiddleName nvarchar(MAX),
	@ContactPersonEmail nvarchar(MAX),
	@ContactPersonMobileNo nvarchar(MAX),
	@EmailId nvarchar(MAX),
	@Purpose nvarchar(MAX),
	@IsPrimary nvarchar(MAX),
	@MobileNo nvarchar(MAX),
	@TelephoneNo nvarchar(MAX),
	@AddressLine1 nvarchar(MAX),
	@AddressLine2 nvarchar(MAX),
	@CountryName nvarchar(MAX),
	@StateName nvarchar(MAX),
	@CityName nvarchar(MAX),
	@Zipcode nvarchar(MAX),
	@AddressCode nvarchar(MAX),
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@AllowEdit bit,
	@AllowAdd bit,
	@AddressAllowEdit bit,
	@AddressAllowAdd bit,
	@ContactAllowAdd bit,
	@BusinessAllowAdd bit
AS

SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

IF (@ParentCustomerName IS NOT NULL AND @ParentCustomerName <> '')  AND NOT EXISTS(SELECT * FROM Customers WHERE LOWER(CustomerName) = LOWER(@ParentCustomerName))
	BEGIN
		SELECT -1;
	END
ELSE
BEGIN
	DECLARE @CustomerId BIGINT;
	DECLARE @AddressId BIGINT;
	DECLARE @ParenId BIGINT;
	SET @ParenId = (select CustomerId from Customers where LOWER(CustomerName) = LOWER(@ParentCustomerName))
	DECLARE @BusinessId BIGINT;
	IF EXISTS(select * from BusinessTypes where LOWER(BTName) = LOWER(@BusinessTypeName))
		BEGIN
			SET @BusinessId = (select BusinessTypeId from BusinessTypes where LOWER(BTName) = LOWER(@BusinessTypeName))
		END
	ELSE
		BEGIN
			IF @BusinessAllowAdd = 1
				BEGIN
					INSERT INTO [dbo].[BusinessTypes]
					(
					 BTName
					,InActive
					,CreatedDate
					)
					SELECT
					@BusinessTypeName,
					0,
					GETDATE()

					SET @BusinessId = SCOPE_IDENTITY();
				END
			ELSE
				BEGIN
					SELECT 5
				END
			
		END

	BEGIN
		IF NOT EXISTS(SELECT * FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName))
		AND NOT EXISTS(SELECT * FROM States WHERE LOWER(StateName) = LOWER(@StateName) AND CountryId = (SELECT CountryId FROM  Countries WHERE LOWER(CountryName) =LOWER(@CountryName)))
		AND  NOT EXISTS(SELECT * FROM  Cities WHERE LOWER(CityName) =LOWER(@CityName) AND StateId = (SELECT StateId FROM States WHERE LOWER(StateName) = LOWER(@StateName)))
			BEGIN
				SELECT -2;
			END
		ELSE
			BEGIN
				IF NOT EXISTS(SELECT * FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))
					BEGIN
						IF @IsDeleted = 0
							BEGIN
								IF @allowAdd = 1
									BEGIN
									IF @ContactPersonEmail IS NOT NULL AND @ContactPersonMobileNo IS NOT NULL
											BEGIN
												IF NOT EXISTS(SELECT * FROM CustomerContacts WHERE LOWER(WorkEmail) = LOWER(@ContactPersonEmail))
													BEGIN
														IF NOT EXISTS(SELECT * FROM CustomerContacts WHERE LOWER(MobileNo) = LOWER(@ContactPersonMobileNo))
															BEGIN
																INSERT INTO [CustomerContacts]
																(
																CTitle,
																FirstName,
																MiddleName,
																LastName,
																WorkEmail,
																MobileNo,
																InActive,
																Gender,
																CreatedDate
																)
																SELECT
																@ContactPersonTitle,
																@ContactPersonFirstName,
																@ContactPersonMiddleName,
																@ContactPersonLastName,
																@ContactPersonEmail,
																@ContactPersonMobileNo,
																0,
																CASE @ContactPersonTitle
																	WHEN 'Mr.' THEN 'Male'
																	WHEN 'Mr' THEN 'Male'
																	WHEN 'Ms' THEN 'Female'
																	WHEN 'Mrs' THEN 'Female'
																END,
																GETDATE()
															END
														ELSE
															BEGIN
																SELECT -6 --Duplicate @ContactPersonMobileNo
															END
													END
												ELSE
													BEGIN
														SELECT -7 --Duplicate @ContactPersonEmail
													END
											END
										INSERT INTO [dbo].[Customers]
										(
										CustomerName,
										CustomerCode,
										BusinessTypeId,
										Website,
										ParentId,
										InActive,
										IsDeleted,
										Notes,
										CreatedDate
										)
										SELECT
										@CustomerName,
										@CustomerCode,
										@BusinessId,
										@Website,
										@ParenId,
										CASE @Status
											WHEN 'Active' THEN 0
											WHEN 'InActive' THEN 1
										END,
										0,
										@Notes,
										GETDATE()
										SET @CustomerId = SCOPE_IDENTITY();

										IF EXISTS(SELECT * FROM Addresses WHERE LOWER(AddressCode) = LOWER(@AddressCode))
											BEGIN
												IF @AddressAllowEdit = 1
													BEGIN
														UPDATE [Addresses]
														SET AddressLine1 = @AddressLine1,
															AddressLine2 = @AddressLine2,
															CountryId = (select CountryId from Countries where LOWER(CountryName) = LOWER(@CountryName)),
															StateId = (select StateId from States where LOWER(StateName) =LOWER(@StateName)),
															CityId = (select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
															ZipCodeId = (select ZipcodeId from Zipcodes where LOWER(Zipcode) = LOWER(@Zipcode)),
															EmailId = @EmailId,
															TelephoneNo = @TelephoneNo,
															MobileNo = @MobileNo,
															FaxNo = @FaxNo,
															InActive = 0,
															UpdatedDate = GETDATE()
														WHERE LOWER(AddressCode) = LOWER(@AddressCode)

														IF @IsPrimary = 'Yes'
															BEGIN
																UPDATE CustomerAdresses
																SET IsDefault = 0
																WHERE CustomerId = @CustomerId
															END

														UPDATE [CustomerAdresses]
														SET AddressId = (SELECT AddressId FROM Addresses WHERE LOWER(AddressCode) = LOWER(@AddressCode)),
															IsDefault = CASE @IsPrimary WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END,
															Purpose = @Purpose,
															UpdatedDate = GETDATE()
														WHERE CustomerId = @CustomerId
													END
												ELSE
													BEGIN
														SELECT 5
													END
											END
										ELSE
											BEGIN
												IF @AddressAllowAdd = 1
													BEGIN
														INSERT INTO [dbo].[Addresses]
														(AddressLine1,
														AddressLine2,
														AddressCode,
														CountryId,
														StateId,
														CityId,
														ZipCodeId,
														EmailId,
														TelephoneNo,
														MobileNo,
														FaxNo,
														InActive,
														CreatedDate
														)
														SELECT
														@AddressLine1,
														@AddressLine2,
														@AddressCode,
														(select CountryId from Countries where LOWER(CountryName) = LOWER(@CountryName)),
														(select StateId from States where LOWER(StateName) =LOWER(@StateName)),
														(select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
														(select ZipcodeId from Zipcodes where LOWER(Zipcode) = LOWER(@Zipcode)),
														@EmailId,
														@TelephoneNo,
														@MobileNo,
														@FaxNo,
														0,
														GETDATE()
														SET @AddressId = SCOPE_IDENTITY();

														IF @IsPrimary = 'Yes'
															BEGIN
																UPDATE CustomerAdresses
																SET IsDefault = 0
																WHERE CustomerId = @CustomerId
															END

														INSERT INTO [dbo].[CustomerAdresses]
														(
														CustomerId,
														AddressId,
														IsDefault,
														Purpose,
														CreatedDate
														)
														SELECT
														@CustomerId,
														@AddressId,
														CASE @IsPrimary
															WHEN 'Yes' THEN 1
															WHEN 'No' THEN 0
														END,
														@Purpose,
														GETDATE()
															END
												ELSE
													BEGIN
														SELECT 5
													END
												
											END
										
										SELECT @CustomerId;
									END
								ELSE
									BEGIN
										SELECT 5;
									END
							END
						ELSE
							BEGIN
								SELECT 2 --NOT FOUND;
							END
					END
				ELSE
					BEGIN
						IF @IsDeleted = 1
							BEGIN
								DELETE FROM [dbo].[Customers] WHERE LOWER(CustomerName) = LOWER(@CustomerName);
								SELECT -3 --DELETE
							END
						ELSE
							BEGIN
								IF @AllowEdit = 1
									BEGIN
									IF @ContactPersonEmail IS NOT NULL AND @ContactPersonMobileNo IS NOT NULL
											BEGIN
												IF NOT EXISTS(SELECT * FROM CustomerContacts WHERE LOWER(WorkEmail) = LOWER(@ContactPersonEmail))
													BEGIN
														IF NOT EXISTS(SELECT * FROM CustomerContacts WHERE LOWER(MobileNo) = LOWER(@ContactPersonMobileNo))
															BEGIN
																INSERT INTO [CustomerContacts]
																(
																CTitle,
																FirstName,
																MiddleName,
																LastName,
																WorkEmail,
																MobileNo,
																InActive,
																Gender,
																CreatedDate
																)
																SELECT
																@ContactPersonTitle,
																@ContactPersonFirstName,
																@ContactPersonMiddleName,
																@ContactPersonLastName,
																@ContactPersonEmail,
																@ContactPersonMobileNo,
																0,
																CASE @ContactPersonTitle
																	WHEN 'Mr.' THEN 'Male'
																	WHEN 'Mr' THEN 'Male'
																	WHEN 'Ms' THEN 'Female'
																	WHEN 'Mrs' THEN 'Female'
																END,
																GETDATE()
															END
														ELSE
															BEGIN
																SELECT -6 --Duplicate @ContactPersonMobileNo
															END
													END
												ELSE
													BEGIN
														SELECT -7 --Duplicate @ContactPersonEmail
													END
											END
										UPDATE [Customers]
										SET CustomerName = @CustomerName,
											CustomerCode = @CustomerCode,
											BusinessTypeId = @BusinessId,
											Website = @Website,
											ParentId = @ParenId,
											InActive = CASE @Status WHEN 'Active' THEN 0 WHEN 'InActive' THEN 1 END,
											IsDeleted = 0,
											UpdatedDate = GETDATE()
										WHERE LOWER(CustomerName) = LOWER(@CustomerName)

										IF EXISTS(SELECT * FROM Addresses WHERE LOWER(AddressCode) = LOWER(@AddressCode))
											BEGIN
												IF @AddressAllowEdit = 1
													BEGIN
														UPDATE [Addresses]
														SET AddressLine1 = @AddressLine1,
															AddressLine2 = @AddressLine2,
															CountryId = (select CountryId from Countries where LOWER(CountryName) = LOWER(@CountryName)),
															StateId = (select StateId from States where LOWER(StateName) =LOWER(@StateName)),
															CityId = (select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
															ZipCodeId = (select ZipcodeId from Zipcodes where LOWER(Zipcode) = LOWER(@Zipcode)),
															EmailId = @EmailId,
															TelephoneNo = @TelephoneNo,
															MobileNo = @MobileNo,
															FaxNo = @FaxNo,
															InActive = 0,
															UpdatedDate = GETDATE()
														WHERE LOWER(AddressCode) = LOWER(@AddressCode)

														IF @IsPrimary = 'Yes'
															BEGIN
																UPDATE CustomerAdresses
																SET IsDefault = 0
																WHERE CustomerId = (SELECT CustomerId FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))												
															END

														UPDATE [CustomerAdresses]
														SET AddressId = (SELECT AddressId FROM Addresses WHERE LOWER(AddressCode) = LOWER(@AddressCode)),
															IsDefault = CASE @IsPrimary WHEN 'Yes' THEN 1 WHEN 'No' THEN 0 END,
															Purpose = @Purpose,
															UpdatedDate = GETDATE()
														WHERE CustomerId = (SELECT CustomerId FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))												
													END
												ELSE
													BEGIN
														SELECT 5
													END
											END
										ELSE
											BEGIN
												IF @AddressAllowAdd = 1
													BEGIN
														INSERT INTO [dbo].[Addresses]
														(AddressLine1,
														AddressLine2,
														AddressCode,
														CountryId,
														StateId,
														CityId,
														ZipCodeId,
														EmailId,
														TelephoneNo,
														MobileNo,
														FaxNo,
														InActive,
														CreatedDate
														)
														SELECT
														@AddressLine1,
														@AddressLine2,
														@AddressCode,
														(select CountryId from Countries where LOWER(CountryName) = LOWER(@CountryName)),
														(select StateId from States where LOWER(StateName) =LOWER(@StateName)),
														(select CityId from Cities where LOWER(CityName) = LOWER(@CityName)),
														(select ZipcodeId from Zipcodes where LOWER(Zipcode) = LOWER(@Zipcode)),
														@EmailId,
														@TelephoneNo,
														@MobileNo,
														@FaxNo,
														0,
														GETDATE()
														SET @AddressId = SCOPE_IDENTITY();

														IF @IsPrimary = 'Yes'
															BEGIN
																UPDATE CustomerAdresses
																SET IsDefault = 0
																WHERE CustomerId = (SELECT CustomerId FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))												
															END

														INSERT INTO [dbo].[CustomerAdresses]
														(
														CustomerId,
														AddressId,
														IsDefault,
														Purpose,
														CreatedDate
														)
														SELECT
														(SELECT CustomerId FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName)),
														@AddressId,
														CASE @IsPrimary
															WHEN 'Yes' THEN 1
															WHEN 'No' THEN 0
														END,
														@Purpose,
														GETDATE()
															END
												ELSE
													BEGIN
														SELECT 5
													END
												
											END
										
											SELECT 1 --UPDATE
									END
								ELSE
									BEGIN
										SELECT 5
									END
							END
					END
			END
	END
END	
	COMMIT
	

	
GO

