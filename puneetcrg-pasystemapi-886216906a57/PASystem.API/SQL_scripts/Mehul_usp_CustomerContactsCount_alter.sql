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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsCount]    Script Date: 7/16/2019 12:30:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomerContactsCount] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
	BEGIN
	SELECT Count(*) as RecCount
	FROM   [dbo].[CustomerContacts] 
	left join Customers on Customers.CustomerId=CustomerContacts.CustomerId 
	left join addresses a on a.AddressId=CustomerContacts.AddressId 
	left join Countries sc on sc.CountryId=a.CountryId 
	left join States ss on ss.StateId=a.StateId 
	left join Cities scity on scity.CityId=a.CityId 
	left join Zipcodes sz on sz.ZipcodeId=a.ZipCodeId
	END
	ELSE
	BEGIN
	SELECT Count(*) as RecCount(SELECT DISTINCT Count(*) FROM((SELECT CustomerContacts.CContactId
	FROM   [dbo].[CustomerContacts] 
	left join Customers on Customers.CustomerId=CustomerContacts.CustomerId 
	left join addresses a on a.AddressId=CustomerContacts.AddressId 
	left join Countries sc on sc.CountryId=a.CountryId 
	left join States ss on ss.StateId=a.StateId 
	left join Cities scity on scity.CityId=a.CityId 
	left join Zipcodes sz on sz.ZipcodeId=a.ZipCodeId
	inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
	inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
	inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
	where CustomerContacts.InActive = 0 and Employees.UserId = @UserId)
	UNION
	(SELECT CustomerContacts.CContactId
	FROM   [dbo].[CustomerContacts] 
	left join Customers on Customers.CustomerId=CustomerContacts.CustomerId 
	left join addresses a on a.AddressId=CustomerContacts.AddressId 
	left join Countries sc on sc.CountryId=a.CountryId 
	left join States ss on ss.StateId=a.StateId 
	left join Cities scity on scity.CityId=a.CityId 
	left join Zipcodes sz on sz.ZipcodeId=a.ZipCodeId
	inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
	inner join Employees on Employees.EmployeeId = Projects.ManagerId
	where CustomerContacts.InActive = 0 and Employees.UserId = @UserId)) x)
	END
	COMMIT
GO

