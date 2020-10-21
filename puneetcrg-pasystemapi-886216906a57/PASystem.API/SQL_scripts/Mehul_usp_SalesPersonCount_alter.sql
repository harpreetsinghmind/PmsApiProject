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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonCount]    Script Date: 7/16/2019 12:30:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_SalesPersonCount] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
	BEGIN
	SELECT Count(*) as RecCount
	FROM   [dbo].[SalesPerson] 
	END
	ELSE
	BEGIN
	SELECT Count(*) as RecCount(SELECT DISTINCT Count(*) FROM((SELECT SalesPerson.SalesPersonId
	FROM   [dbo].[SalesPerson]
	INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
	inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId  
	inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
	inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId 
	where Employees.UserId = @UserId)
	UNION
	(SELECT SalesPerson.SalesPersonId
	FROM   [dbo].[SalesPerson]
	INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
	inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId   
	inner join Employees on Employees.EmployeeId = Projects.ManagerId 
	where Employees.UserId = @UserId)) x)
	END
	COMMIT
GO

