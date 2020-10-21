ALTER PROC [dbo].[usp_ContactPersonImport] 
    @Title nvarchar(MAX),
	@FirstName nvarchar(MAX),
	@MiddleName nvarchar(MAX),
	@LastName nvarchar(MAX),
	@Gender nvarchar(MAX),
	@WorkEmail nvarchar(MAX),
	@OtherEmail nvarchar(MAX),
	@MobileNo nvarchar(MAX),
	@TelephoneNo nvarchar(MAX),
	@Department nvarchar(MAX),
	@Designation nvarchar(MAX),
    @InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF NOT EXISTS(SELECT * FROM CustomerContacts WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo))
		BEGIN
			IF @IsDeleted = 0
				BEGIN
					IF @allowAdd = 1
						BEGIN
							INSERT INTO CustomerContacts
							(CTitle,
							FirstName,
							MiddleName,
							LastName,
							Gender,
							WorkEmail,
							OtherEmail,
							MobileNo,
							TelephoneNo,
							Department,
							Designation,
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
							@Department,
							@Designation,
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
					DELETE FROM CustomerContacts WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo)
					SELECT 3 --DELETE
				END
			ELSE
				BEGIN
					IF @allowEdit = 1
						BEGIN
							UPDATE CustomerContacts
							SET CTitle = @Title,
								FirstName = @FirstName,
								MiddleName = @MiddleName,
								LastName = @LastName,
								Gender = @Gender,
								WorkEmail = @WorkEmail,
								OtherEmail = @OtherEmail,
								MobileNo = @MobileNo,
								TelephoneNo = @TelephoneNo,
								Designation = @Designation,
								Department = @Department,
								InActive = @InActive,
								Notes = @Notes,
								UpdatedDate = GETDATE()
							WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo)
							--SELECT 1 --UPDATE
							SELECT TOP 1 CContactId FROM CustomerContacts WHERE LOWER(WorkEmail) = LOWER(@WorkEmail) OR LOWER(MobileNo) = LOWER(@MobileNo)
						END
					ELSE
						BEGIN
							SELECT 5
						END
				END
		END