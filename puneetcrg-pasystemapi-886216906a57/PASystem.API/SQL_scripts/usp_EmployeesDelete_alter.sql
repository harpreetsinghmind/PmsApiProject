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

/****** Object:  StoredProcedure [dbo].[usp_EmployeesDelete]    Script Date: 3/28/2019 4:13:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_EmployeesDelete] 
    @EmployeeId bigint,
	@UserId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[Employees]
	SET [Isdeleted] = 'true'
	WHERE  [EmployeeId] = @EmployeeId

	UPDATE [dbo].[Users]
	SET [InActive] = 'true'
	WHERE [UserId] = @UserId

	COMMIT
GO

