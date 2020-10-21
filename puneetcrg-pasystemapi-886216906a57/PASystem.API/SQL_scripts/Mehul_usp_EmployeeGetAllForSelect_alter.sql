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

/****** Object:  StoredProcedure [dbo].[usp_EmployeeGetAllForSelect]    Script Date: 5/29/2019 7:57:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_EmployeeGetAllForSelect] 
	
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	SELECT 
		 EmployeeId,
		 EmpCode AS EmploeeCode,
		 (LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
		 CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
		 END +
		 LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS EmployeeName,
		 0 AS Billing,
		 BillingTarget AS BillingTarget,
		 0 AS Overtime,
         0 AS PaidLeave,
         0 AS NotBilling,
         (select count(DISTINCT ProjectId) from ProjectAssign where ProjectAssign.EmployeeId = Employees.EmployeeId) AS TotalProject,
		 Countries.CountryName + ', ' + States.StateName AS Address
	FROM  
		[dbo].[Employees]
		INNER JOIN Countries ON Countries.CountryId = Employees.CountryId
		INNER JOIN States ON States.StateId = Employees.StateId
		INNER JOIN Cities ON Cities.CityId = Employees.CityId
		LEFT JOIN UserRoles on UserRoles.UserId = Employees.UserId
		LEFT JOIN Roles on Roles.RoleId = UserRoles.RoleId
	WHERE 
		Employees.InActive =0
		AND
		(Employees.Isdeleted = 'false' 
		OR 
		Employees.Isdeleted IS NULL)
		AND 
		(Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
	
	COMMIT
GO

