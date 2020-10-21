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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonInsert]    Script Date: 4/1/2019 3:07:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_SalesPersonInsert] 
    @STitle nvarchar(50),
    @FirstName nvarchar(100),
    @MiddleName nvarchar(100) = NULL,
    @LastName nvarchar(100) = NULL,
    @DOB datetime = NULL,
    @Gender nvarchar(50) = NULL,
    @WorkEmail nvarchar(100) = NULL,
    @OtherEmail nvarchar(100) = NULL,
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
	IF NOT EXISTS(select * from SalesPerson where lower(WorkEmail) = LOWER(@WorkEmail) or lower(OtherEmail) = LOWER(@OtherEmail) or lower(MobileNo) = LOWER(@MobileNo))
	BEGIN
	INSERT INTO [dbo].[SalesPerson] ([STitle], [FirstName], [MiddleName], [LastName], [DOB], [Gender], [WorkEmail], [OtherEmail], [MobileNo], [TelephoneNo], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[Notes])
	SELECT @STitle, @FirstName, @MiddleName, @LastName, @DOB, @Gender, @WorkEmail, @OtherEmail, @MobileNo, @TelephoneNo, @InActive, @CreatedBy, @CreatedDate, @UpdatedBy, @UpdatedDate,@Notes
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
	-- End Return Select <- do not remove
    END
	ELSE
	BEGIN
	SELECT -1
	END           
	COMMIT
GO

