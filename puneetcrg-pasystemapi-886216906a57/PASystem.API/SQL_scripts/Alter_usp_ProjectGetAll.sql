USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAll]    Script Date: 3/23/2019 2:06:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectGetAll] 
    @PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource,
	[ProjectSources].ProjectSourceId, 
	[Offices].Name AS Office, 
	[Projects].OfficeId, 
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
	END as Status   
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Offices on Offices.OfficeId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId   
	 ORDER BY ' + @FieldName+ ' '+ @SortType + 
	 ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ 
	 '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	 ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
Begin
SELECT @SQLStatement = 'SELECT 
	[ProjectId],
	[Projects].[Name] AS ProjectName, 
	[Code] AS ProjectCode, 
	[ShortDescription] AS ShortDesc, 
	[Description] AS Notes, 
	[Customers].CustomerName, 
	[Projects].CustomerId, 
	[ProjectTypes].Name AS ProjectType, 
	[ProjectTypes].ProjectTypeId, 
	[ProjectSources].Name AS ProjectSource, 
	[ProjectSources].ProjectSourceId, 
	[Offices].Name AS Office, 
	[Projects].OfficeId, 
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
	END as Status   
	FROM [dbo].[Projects] 
		 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
		 LEFT OUTER JOIN Offices on Offices.OfficeId=Projects.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId   
	WHERE '+@Condition+
	' ORDER BY ' + @FieldName+ ' '+ @SortType + 
	' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+
	' ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
	' ROWS ONLY OPTION (RECOMPILE)'
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Projects]  WHERE ' + @Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
