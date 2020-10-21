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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsUpdate]    Script Date: 4/1/2019 3:08:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomerContactsUpdate] 
    @CContactId bigint,
    @CustomerId bigint,
    @CTitle nvarchar(50),
    @FirstName nvarchar(100),
    @MiddleName nvarchar(100) = NULL,
    @LastName nvarchar(100) = NULL,
    @DOB datetime = NULL,
    @Gender nvarchar(50) = NULL,
    @WorkEmail nvarchar(100) = NULL,
    @OtherEmail nvarchar(100) = NULL,
    @Department nvarchar(300) = NULL,
    @Designation nvarchar(300) = NULL,
    @AddressId bigint= NULL,
    @MobileNo nvarchar(50) = NULL,
    @TelephoneNo nvarchar(50) = NULL,
    @InActive bit,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@Notes nvarchar(MAX)=NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from CustomerContacts where lower(WorkEmail) = LOWER(@WorkEmail) or lower(OtherEmail) = LOWER(@OtherEmail) or lower(MobileNo) = LOWER(@MobileNo))
	BEGIN
	UPDATE [dbo].[CustomerContacts]
	SET    [CustomerId] = @CustomerId, [CTitle] = @CTitle, [FirstName] = @FirstName, [MiddleName] = @MiddleName, [LastName] = @LastName, [DOB] = @DOB, [Gender] = @Gender, [WorkEmail] = @WorkEmail, [OtherEmail] = @OtherEmail, [Department] = @Department, [Designation] = @Designation, [AddressId] = @AddressId, [MobileNo] = @MobileNo, [TelephoneNo] = @TelephoneNo, [InActive] = @InActive, [CreatedBy] = @CreatedBy, [CreatedDate] = @CreatedDate, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate, [Notes]=@Notes 
	WHERE  [CContactId] = @CContactId
	
	-- Begin Return Select <- do not remove
	SELECT [CContactId], [CustomerId], [CTitle], [FirstName], [MiddleName], [LastName], [DOB], [Gender], [WorkEmail], [OtherEmail], [Department], [Designation], [AddressId], [MobileNo], [TelephoneNo], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[Notes] 
	FROM   [dbo].[CustomerContacts]
	WHERE  [CContactId] = @CContactId	
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

