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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonImport]    Script Date: 9/11/2019 12:39:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_SalesPersonImport] 
    @Title nvarchar(MAX),
	@FirstName nvarchar(MAX),
	@MiddleName nvarchar(MAX),
	@LastName nvarchar(MAX),
	@Gender nvarchar(MAX),
	@WorkEmail nvarchar(MAX),
	@OtherEmail nvarchar(MAX),
	@MobileNo nvarchar(MAX),
	@TelephoneNo nvarchar(MAX),
    @InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF NOT EXISTS(SELECT * FROM SalesPerson WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo))
		BEGIN
			IF @IsDeleted = 0
				BEGIN
					IF @allowAdd = 1
						BEGIN
							INSERT INTO SalesPerson
							(STitle,
							FirstName,
							MiddleName,
							LastName,
							Gender,
							WorkEmail,
							OtherEmail,
							MobileNo,
							TelephoneNo,
							InActive,
							Notes,
							CreatedDate
							)
							SELECT
							@Title,
							@FirstName,
							@MiddleName,
							@LastName,
							@Gender,
							@WorkEmail,
							@OtherEmail,
							@MobileNo,
							@TelephoneNo,
							@InActive,
							@Notes,
							GETDATE()

							SELECT SCOPE_IDENTITY()
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
					DELETE FROM SalesPerson WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo)
					SELECT 3 --DELETE
				END
			ELSE
				BEGIN
					IF @allowEdit = 1
						BEGIN
							UPDATE SalesPerson
							SET STitle = @Title,
								FirstName = @FirstName,
								MiddleName = @MiddleName,
								LastName = @LastName,
								Gender = @Gender,
								WorkEmail = @WorkEmail,
								OtherEmail = @OtherEmail,
								MobileNo = @MobileNo,
								TelephoneNo = @TelephoneNo,
								InActive = @InActive,
								Notes = @Notes,
								UpdatedDate = GETDATE()
							WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo)
							SELECT 1 --UPDATE
						END
					ELSE
						BEGIN
							SELECT 5
						END
				END
		END
GO

