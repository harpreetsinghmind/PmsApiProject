USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserView]    Script Date: 6/13/2019 12:00:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetUserView] 
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
CASE Employees.ExpenseEntry
WHEN 1 THEN 'Yes'
WHEN 2 THEN 'No'
ELSE ''
END AS ExpenseEntry,
Employees.RateSGroup as RateScheduleGroup,
Employees.VendorID as VendorId,
Employees.PayrollState,
Employees.EthnicOrigin,
CASE Employees.MaritalStaus
WHEN 0 THEN 'Married'
WHEN 1 THEN 'Single'
ELSE ''
END AS MaritalStaus,
Employees.Address,
Countries.CountryName as Country,
States.StateName as State,
Cities.CityName as City,
Zipcodes.Zipcode
from Employees Employees inner join Countries on Countries.CountryId = Employees.CountryId
 inner join States on States.StateId = Employees.StateId
 inner join Cities on Cities.CityId = Employees.CityId
 inner join Zipcodes on Zipcodes.ZipcodeId = Employees.ZipcodeId
 left outer join Employees e2 on Employees.ReportingTo = e2.EmployeeId where Employees.EmployeeId = @EmployeeId


	

	COMMIT
