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

/****** Object:  StoredProcedure [dbo].[usp_ProjectAssignGetAllForSelect]    Script Date: 5/23/2019 7:35:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectAssignGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 Projects.ProjectId,
		 Projects.Name AS ProjectName,
		 Projects.Code AS ProjectCode,
		 Projects.Locked,
		 Projects.PaymentType,
		 Projects.PlannedStartDate,
		 Projects.StartDate,
		 Projects.EndDate,
		 Projects.ActualDate,
		 Projects.ManagerId,
		 Projects.ShortDescription AS ShortDesc,
		 Customers.CustomerName,
		 Employees.BillingRate,
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
		CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
		THEN 'NOT-STARTED'
		WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
		THEN 'OPENED'
		ELSE 'CLOSED'
	END AS ProStatus 	 
	FROM [dbo].[Projects]
		LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
		LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
		LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
		LEFT JOIN Employees ON Projects.ManagerId = Employees.EmployeeId where Projects.InActive = 0
	
	COMMIT
GO

