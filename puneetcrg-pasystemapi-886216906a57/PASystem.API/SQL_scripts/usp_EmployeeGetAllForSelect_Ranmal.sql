USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeGetAllForSelect]    Script Date: 4/15/2019 4:00:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_EmployeeGetAllForSelect] 
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
		 BillingRate AS Billing,
		 BillingTarget AS BillingTarget,
		 0 AS Overtime,
         0 AS PaidLeave,
         0 AS NotBilling,
         0 AS TotalProject,
		 Countries.CountryName + ', ' + States.StateName AS Address
	FROM  
		[dbo].[Employees]
		INNER JOIN Countries ON Countries.CountryId = Employees.CountryId
		INNER JOIN States ON States.StateId = Employees.StateId
		INNER JOIN Cities ON Cities.CityId = Employees.CityId
	WHERE 
		Employees.InActive =0
	
	COMMIT
