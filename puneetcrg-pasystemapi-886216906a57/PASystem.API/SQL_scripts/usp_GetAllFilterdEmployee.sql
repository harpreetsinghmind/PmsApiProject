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

/****** Object:  StoredProcedure [dbo].[usp_GetAllFilterdEmployee]    Script Date: 4/23/2019 11:41:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetAllFilterdEmployee] 
   
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	select [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], Employees.[InActive], Employees.[CreatedBy], Employees.[CreatedDate], Employees.[UpdatedBy], Employees.[UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [PaymentMethod], [RateSGroup], [VendorID], [UserNumber], Employees.[UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],ISNULL(FirstName, '') + ' '+ISNULL(MiddleName, '')+' ' +ISNULL(LastName, '') as EmployeeName from Employees
LEFT join UserRoles on UserRoles.UserId = Employees.UserId
LEFT join Roles on Roles.RoleId = UserRoles.RoleId
where Employees.Isdeleted = 'false' or Employees.Isdeleted IS NULL
AND (Roles.RoleId IS NULL OR Roles.Name <> 'Admin')


	

	COMMIT
GO

