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

/****** Object:  StoredProcedure [dbo].[usp_CustomersGetAllForSelect]    Script Date: 7/10/2019 2:44:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomersGetAllForSelect] 
	@UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
		BEGIN
			SELECT [CustomerId],[CustomerName], [CustomerCode]
			FROM   [dbo].[Customers] where InActive=0
		END
	ELSE
		BEGIN
			select DISTINCT * from((SELECT Customers.[CustomerId],[CustomerName], [CustomerCode]
			FROM   [dbo].[Customers]
			inner join Projects on Projects.CustomerId = Customers.CustomerId 
			inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
			inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
			where Employees.UserId = @UserId and Customers.InActive=0)
			UNION
			(SELECT Customers.[CustomerId],[CustomerName], [CustomerCode]
			FROM   [dbo].[Customers]
			inner join Projects on Projects.CustomerId = Customers.CustomerId 
			inner join Employees on Employees.EmployeeId = Projects.ManagerId
			where Employees.UserId = @UserId and Customers.InActive=0)) x
		END
	COMMIT
GO

