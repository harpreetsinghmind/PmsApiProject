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

/****** Object:  StoredProcedure [dbo].[usp_UsersInsert]    Script Date: 3/28/2019 4:12:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_UsersInsert] 
    @Email nvarchar(256) = NULL,
    @EmailConfirmed bit=NULL,
    @PasswordHash nvarchar(MAX) = NULL,
    @SecurityStamp nvarchar(MAX) = NULL,
    @PhoneNumber nvarchar(MAX) = NULL,
    @PhoneNumberConfirmed bit=NULL,
    @TwoFactorEnabled bit=NULL,
    @LockoutEndDateUtc datetime = NULL,
    @LockoutEnabled bit=NULL,
    @AccessFailedCount int=NULL,
    @UserName nvarchar(256),
    @isAuthorized bit=NULL,
    @InActive bit=NULL,
    @CreatedBy nvarchar(256) = NULL,
    @CreatedDate datetime = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from Users where lower(UserName) = LOWER(@UserName))
	BEGIN  
	INSERT INTO [dbo].[Users] ([Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [isAuthorized], [InActive], [CreatedBy], [CreatedDate])
	SELECT @Email, @EmailConfirmed, @PasswordHash, @SecurityStamp, @PhoneNumber, @PhoneNumberConfirmed, @TwoFactorEnabled, @LockoutEndDateUtc, @LockoutEnabled, @AccessFailedCount, @UserName, @isAuthorized, @InActive, @CreatedBy, @CreatedDate
	
	-- Begin Return Select <- do not remove
	SELECT  SCOPE_IDENTITY()
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END
               
	COMMIT
GO

