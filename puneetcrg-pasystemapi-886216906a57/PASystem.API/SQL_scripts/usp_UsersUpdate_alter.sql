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

/****** Object:  StoredProcedure [dbo].[usp_UsersUpdate]    Script Date: 4/10/2019 12:00:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_UsersUpdate] 
    @UserId bigint,
    @Email nvarchar(256),
	@UserName nvarchar(256),
	@PasswordHash nvarchar(MAX) = NULL,
	@SecurityStamp nvarchar(MAX),
	@EmailConfirmed bit,
	@InActive bit,
	@UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from Users where lower(UserName) = LOWER(@UserName))
	BEGIN
	IF @PasswordHash IS NULL
	BEGIN  
	UPDATE [dbo].[Users]
	SET    [Email] = @Email,[UserName] = @UserName,[SecurityStamp] = @SecurityStamp, [EmailConfirmed] = @EmailConfirmed, [InActive] = @InActive, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [UserId] = @UserId
	END
	
	ELSE
	BEGIN
	UPDATE [dbo].[Users]
	SET    [Email] = @Email,[UserName] = @UserName, [PasswordHash] = @PasswordHash, [SecurityStamp] = @SecurityStamp, [EmailConfirmed] = @EmailConfirmed, [InActive] = @InActive, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [UserId] = @UserId
	END
	-- Begin Return Select <- do not remove
	SELECT [Email],[UserName], [PasswordHash], [SecurityStamp], [EmailConfirmed], [InActive], [UpdatedBy], [UpdatedDate]
	FROM   [dbo].[Users]
	WHERE  [UserId] = @UserId	
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

