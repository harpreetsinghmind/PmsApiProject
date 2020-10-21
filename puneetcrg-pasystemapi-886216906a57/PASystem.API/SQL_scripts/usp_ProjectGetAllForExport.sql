USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllForExport]    Script Date: 3/20/2019 2:46:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectGetAllForExport] 
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
	ROW_NUMBER() OVER (ORDER BY ProjectId) AS 'Sr. No', 
	[Projects].[Name], 
	[Type], 
	[Code], 
	[ShortDescription], 
	[Description], 
	[Customers].CustomerName, 
	[ProjectTypes].Name AS ProjectType, 
	[ProjectSources].Name AS ProjectSource, 
	[Offices].Name AS Office, 
	ISNULL([Employees].FirstName,'')+ ' '+ISNULL([Employees].MiddleName,'')+ ' '+ISNULL([Employees].LastName,'') AS ProjectManager, 
	ISNULL([SalesPerson].FirstName,'')+ ' '+ISNULL([SalesPerson].MiddleName,'')+ ' '+ISNULL([SalesPerson].LastName,'') AS SalesPerson, 
	[SquareFootage], 
	 CASE [Projects].[GroundUp]
		 WHEN 0 THEN 'UP'
		 WHEN 1 THEN 'NotUP' 
	 END as GroundUp, 
	 [BuildingContractCost],
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
	

	COMMIT
GO


