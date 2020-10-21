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

/****** Object:  StoredProcedure [dbo].[usp_CustomersCount]    Script Date: 7/16/2019 12:29:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_CustomersCount] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
	BEGIN
	SELECT Count(*) as RecCount
	FROM   [dbo].[Customers] where ParentId is null 
	END
	ELSE
	BEGIN
	SELECT Count(*) as RecCount(SELECT DISTINCT Count(*) FROM((SELECT Customers.CustomerId
	FROM   [dbo].[Customers]
	inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId 
	inner join Projects on Projects.CustomerId = Customers.CustomerId 
	inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
	inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
	where ParentId is null and Customers.InActive = 0 and Employees.UserId = @UserId)
	UNION
	(SELECT Customers.CustomerId
	FROM   [dbo].[Customers]
	inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId 
	inner join Projects on Projects.CustomerId = Customers.CustomerId 
	inner join Employees on Employees.EmployeeId = Projects.ManagerId
	where ParentId is null and Customers.InActive = 0 and Employees.UserId = @UserId)) x)
	END
	COMMIT
GO

