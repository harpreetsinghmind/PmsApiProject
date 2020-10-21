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

/****** Object:  StoredProcedure [dbo].[usp_UsersSelectAll]    Script Date: 7/1/2019 4:10:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_UsersSelectAll] 
	AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
SELECT Users.[UserId], [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [isAuthorized], Users.[InActive], Users.[CreatedBy], Users.[CreatedDate], Users.[UpdatedBy], Users.[UpdatedDate] ,Employees.ReleavingDate
	FROM   [dbo].[Users] inner join Employees on Employees.UserId = Users.UserId where Users.InActive='false'
	

	COMMIT


	 
GO

