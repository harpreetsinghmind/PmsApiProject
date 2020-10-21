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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsUpdate]    Script Date: 4/30/2019 11:20:57 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_CustomerContactsUpdate] 
    @CContactId bigint,
    @CTitle nvarchar(50),
    @FirstName nvarchar(100),
    @MiddleName nvarchar(100) = NULL,
    @LastName nvarchar(100) = NULL,
    @Gender nvarchar(50) = NULL,
    @WorkEmail nvarchar(100) = NULL,
    @OtherEmail nvarchar(100) = NULL,
    @Department nvarchar(300) = NULL,
    @Designation nvarchar(300) = NULL,
    @MobileNo nvarchar(50) = NULL,
    @TelephoneNo nvarchar(50) = NULL,
    @InActive bit,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@Notes nvarchar(MAX)=NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF NOT EXISTS(select * from CustomerContacts where lower(WorkEmail) = LOWER(@WorkEmail) and CContactId <> @CContactId)
	BEGIN
		IF NOT EXISTS(select * from CustomerContacts where MobileNo = @MobileNo and CContactId <> @CContactId)
		BEGIN
		UPDATE [dbo].[CustomerContacts]
		SET    [CTitle] = @CTitle, [FirstName] = @FirstName, [MiddleName] = @MiddleName, [LastName] = @LastName, [Gender] = @Gender, [WorkEmail] = @WorkEmail, [OtherEmail] = @OtherEmail, [Department] = @Department, [Designation] = @Designation, [MobileNo] = @MobileNo, [TelephoneNo] = @TelephoneNo, [InActive] = @InActive, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate, [Notes]=@Notes 
		WHERE  [CContactId] = @CContactId
	
		-- Begin Return Select <- do not remove
		select * from CustomerContacts where CContactId = @CContactId
		-- End Return Select <- do not remove
		END
		ELSE
		BEGIN
		SELECT -2
		END
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT

GO

