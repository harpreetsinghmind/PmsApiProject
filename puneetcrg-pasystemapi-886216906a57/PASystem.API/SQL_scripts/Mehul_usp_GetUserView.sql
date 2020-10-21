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

/****** Object:  StoredProcedure [dbo].[usp_GetUserView]    Script Date: 4/4/2019 3:47:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetUserView] 
   @EmployeeId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

select 
Employees.UserNumber,
Employees.EmpTitle as Title,
Employees.FirstName,
Employees.LastName,
Employees.JoiningDate,
Employees.DOB,Employees.Gender,
Employees.PersonalEmail,
ISNULL(e2.FirstName,'') + ' ' +ISNULL(e2.MiddleName,'') + ' ' +ISNULL(e2.LastName,'') as ReportingTo,
Employees.FatherName,
Employees.MobileNo,
Employees.CreatedDate,
Employees.EmpType as UserType,
Employees.BillingRate,
Employees.CostRate,
Employees.BillingTarget,
Employees.ExpenseEntry,
Employees.RateSGroup,
Employees.PaymentMethod,
Employees.VendorID,
Employees.PayrollState,
Employees.HomePhoneNo,
Employees.EthnicOrigin,
Employees.MaritalStaus,
Employees.Address,
Countries.CountryName as Country,
States.StateName as State,
Cities.CityName as City,
Zipcodes.Zipcode
from Employees Employees inner join Countries on Countries.CountryId = Employees.CountryId
 inner join States on States.StateId = Employees.StateId
 inner join Cities on Cities.CityId = Employees.CityId
 inner join Zipcodes on Zipcodes.ZipcodeId = Employees.ZipcodeId
 inner join Employees e2 on Employees.ReportingTo = e2.EmployeeId where Employees.EmployeeId = @EmployeeId


	

	COMMIT
GO

