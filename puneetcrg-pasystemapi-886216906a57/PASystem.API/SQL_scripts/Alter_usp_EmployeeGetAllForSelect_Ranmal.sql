USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeeGetAllForSelect]    Script Date: 7/20/2019 4:28:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_EmployeeGetAllForSelect] 
	@UserId bigint,
	@UserType int,
	@IsApprove int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1 
	BEGIN
		SELECT DISTINCT
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
	END
	ELSE
	BEGIN
		IF @IsApprove = 1
		BEGIN
			SELECT DISTINCT
			 Employees.EmployeeId,
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
			INNER JOIN ProjectAssign pr ON pr.EmployeeId = Employees.EmployeeId
		WHERE 
			Employees.InActive =0
			AND
			(Employees.Isdeleted = 'false' 
			OR 
			Employees.Isdeleted IS NULL)
			AND
			Employees.UserId <> @UserId
			AND
			pr.ReportingTo =  (SELECT EmployeeId from Employees where UserId =@UserId)
			AND
			(Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
		END
		ELSE
		BEGIN
			SELECT DISTINCT
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
			Employees.UserId = @UserId
			AND 
			(Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
		END
	END
	COMMIT
