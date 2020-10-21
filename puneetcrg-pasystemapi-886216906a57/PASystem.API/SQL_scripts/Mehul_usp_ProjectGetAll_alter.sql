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

/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAll]    Script Date: 7/15/2019 3:21:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_ProjectGetAll] 
    @PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType <> 1
BEGIN
IF @Condition is null
SELECT @SQLStatement = 'select DISTINCT * from((SELECT 
	Projects.[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource,
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus      
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
		 UNION
		 (SELECT 
	Projects.[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource,
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus      
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
		 inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')) x
	 ORDER BY x.' + @FieldName+ ' '+ @SortType + 
	 ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ 
	 '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	 ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
Begin
SELECT @SQLStatement = 'select DISTINCT * from((SELECT 
	Projects.[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus     
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
		 UNION
		 (SELECT 
	Projects.[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus     
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
		 inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')) x    
	WHERE '+@Condition+
	' ORDER BY x.' + @FieldName+ ' '+ @SortType + 
	' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+
	' ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	' ROWS ONLY OPTION (RECOMPILE)'
    
-- Execute the SQL statement
Select @CountStatement ='select DISTINCT * from((Select Count(*) as FilterCount FROM((SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus   
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')) x  WHERE ' + @Condition+')
		 UNION
		 (Select Count(*) as FilterCount FROM((SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus   
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId
		 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
		 inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
		 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')) x  WHERE ' + @Condition+')) y'
		 END
END
ELSE
BEGIN
IF @Condition is null
SELECT @SQLStatement = 'SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource,
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus      
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId   
	 ORDER BY ' + @FieldName+ ' '+ @SortType + 
	 ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ 
	 '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	 ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
Begin
SELECT @SQLStatement = 'select * from(SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus     
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId) x    
	WHERE '+@Condition+
	' ORDER BY ' + @FieldName+ ' '+ @SortType + 
	' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+
	' ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	' ROWS ONLY OPTION (RECOMPILE)'
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM((SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[Projects].PaymentType,
	[Projects].WorkingDays,
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Addresses].AddressCode AS Office, 
	[Projects].OfficeId, 
	[Projects].Locked, 
	[Projects].[PlannedStartDate],
	[Projects].[StartDate],
	[Projects].[EndDate],
	[Projects].[ActualDate], 
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
	[Projects].ManagerId,
	(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
	[Projects].SalesPersonId,
	(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
	END +
	LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,
	[Projects].ContactPersonId,	
    [Projects].inActive,
	[Projects].CreatedDate AS Created,
	CASE [Projects].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
	END as Status,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''NOT-STARTED''
	WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
	THEN ''OPENED''
	ELSE ''CLOSED''
	END AS ProStatus   
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId)) x  WHERE ' + @Condition
End
END
EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
GO

