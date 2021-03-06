USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllForExport]    Script Date: 3/22/2019 4:34:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectGetAllForExport] 
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
	ROW_NUMBER() OVER (ORDER BY ProjectId) AS 'Sr. No', 
	[Projects].[Name], 
	[Code], 
	[ShortDescription], 
	[Description], 
	[Customers].CustomerName, 
	[ProjectTypes].Name AS ProjectType, 
	[ProjectSources].Name AS ProjectSource, 
	[Offices].Name AS Office, 
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
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,	
	 CASE [Projects].[InActive]
		 WHEN 0 THEN 'Active'
		 WHEN 1 THEN 'InActive' 
	 END as Status   
	 FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Offices on Offices.OfficeId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId 
	

	COMMIT
