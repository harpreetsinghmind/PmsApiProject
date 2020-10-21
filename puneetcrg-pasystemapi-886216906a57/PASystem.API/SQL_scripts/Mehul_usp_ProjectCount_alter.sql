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

/****** Object:  StoredProcedure [dbo].[usp_ProjectCount]    Script Date: 7/16/2019 12:31:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectCount] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
	BEGIN
	SELECT Count(*) as RecCount
	FROM   [dbo].[Projects] 
	END
	ELSE
	BEGIN
	SELECT Count(*) as RecCount(SELECT DISTINCT Count(*) FROM((SELECT Projects.ProjectId
	FROM   [dbo].[Projects] 
	LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 WHERE  Employees.UserId = @UserId)
		 UNION
		 (SELECT Projects.ProjectId
	FROM   [dbo].[Projects] 
	LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
		 inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
		 WHERE  Employees.UserId = @UserId)) x)
	END
	COMMIT
GO

