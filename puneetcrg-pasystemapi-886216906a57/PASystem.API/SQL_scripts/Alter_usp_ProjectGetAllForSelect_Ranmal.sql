USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllForSelect]    Script Date: 7/9/2019 5:02:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_ProjectGetAllForSelect] 
	@UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	IF @UserType = 1 
	BEGIN
		SELECT * FROM(SELECT 
		 -1 AS RoleId,
		 Projects.ProjectId,
		 Projects.Name AS ProjectName,
		 Projects.Code AS ProjectCode,
		 Projects.Locked,
		 Projects.PaymentType,
		 Projects.PlannedStartDate,
		 Projects.StartDate,
		 Projects.EndDate,
		 Projects.ActualDate,
		 Projects.ShortDescription AS ShortDesc,
		 Customers.CustomerName,
		 Projects.ManagerId,
		 Employees.EmployeeId,
		 Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,
		(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,
		(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,
		CASE WHEN Projects.InActive = 0
			THEN
				CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN 'NOT-STARTED'
					WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN 'OPENED'
					ELSE 'CLOSED'
				END 
			ELSE 'ARCHIVED'
		END AS ProStatus 	 
		FROM [dbo].[Projects]
			LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
			LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
			LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
			INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId) x
	END
	ELSE
	BEGIN
		SELECT DISTINCT ProjectAssign.RoleId, x.* 
		FROM (
			(SELECT 
			 Projects.ProjectId,
			 Projects.Name AS ProjectName,
			 Projects.Code AS ProjectCode,
			 Projects.Locked,
			 Projects.PaymentType,
			 Projects.PlannedStartDate,
			 Projects.StartDate,
			 Projects.EndDate,
			 Projects.ActualDate,
			 Projects.ShortDescription AS ShortDesc,
			 Customers.CustomerName,
			 Projects.ManagerId,
			 Employees.EmployeeId,
			 Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,
			(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
			CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
				THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
				ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
			END +
			LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,
			(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
			CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
				THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
				ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
			END +
			LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,
			CASE WHEN Projects.InActive = 0
				THEN
					CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
						THEN 'NOT-STARTED'
						WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
						THEN 'OPENED'
						ELSE 'CLOSED'
					END 
				ELSE 'ARCHIVED'
			END AS ProStatus 	 
			FROM [dbo].[Projects]
				LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
				LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
				LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
				INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId
			WHERE Employees.UserId = @UserId  AND Projects.InActive <> 1)
		UNION
			(SELECT 
			 Projects.ProjectId,
			 Projects.Name AS ProjectName,
			 Projects.Code AS ProjectCode,
			 Projects.Locked,
			 Projects.PaymentType,
			 Projects.PlannedStartDate,
			 Projects.StartDate,
			 Projects.EndDate,
			 Projects.ActualDate,
			 Projects.ShortDescription AS ShortDesc,
			 Customers.CustomerName,
			 Projects.ManagerId,
			 Employees.EmployeeId,
			 Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,
			(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
			CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
				THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
				ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
			END +
			LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,
			(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
			CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
				THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
				ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
			END +
			LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,
			CASE WHEN Projects.InActive = 0
				THEN
					CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
						THEN 'NOT-STARTED'
						WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
						THEN 'OPENED'
						ELSE 'CLOSED'
					END 
				ELSE 'ARCHIVED'
			END AS ProStatus 	 
			FROM [dbo].[Projects]
				LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
				LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
				LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
				INNER JOIN ProjectAssign ON ProjectAssign.ProjectId = Projects.ProjectId
				INNER JOIN Employees ON ProjectAssign.EmployeeId = Employees.EmployeeId
			WHERE Employees.UserId = @UserId AND Projects.InActive <> 1 )
			) x
			LEFT JOIN 
			ProjectAssign ON ProjectAssign.ProjectId = x.ProjectId AND ProjectAssign.EmployeeId = x.EmployeeId
	END
	COMMIT
