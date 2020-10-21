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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonUpdate]    Script Date: 4/1/2019 3:06:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_SalesPersonUpdate] 
    @SalesPersonId bigint,
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
	UPDATE [dbo].[SalesPerson]
	SET    [STitle] = @STitle, [FirstName] = @FirstName, [MiddleName] = @MiddleName, [LastName] = @LastName, [DOB] = @DOB, [Gender] = @Gender, [WorkEmail] = @WorkEmail, [OtherEmail] = @OtherEmail, [MobileNo] = @MobileNo, [TelephoneNo] = @TelephoneNo, [InActive] = @InActive, [CreatedBy] = @CreatedBy, [CreatedDate] = @CreatedDate, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate,[Notes]=@Notes
	WHERE  [SalesPersonId] = @SalesPersonId
	
	-- Begin Return Select <- do not remove
	SELECT [SalesPersonId],[STitle], [FirstName], [MiddleName], [LastName], [DOB], [Gender], [WorkEmail], [OtherEmail], [MobileNo], [TelephoneNo], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[Notes]
	FROM   [dbo].[SalesPerson]
	WHERE  [SalesPersonId] = @SalesPersonId	
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

