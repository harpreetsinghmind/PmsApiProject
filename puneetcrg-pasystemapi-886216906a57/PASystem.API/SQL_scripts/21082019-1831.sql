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
DECLARE @sqlBasic1 NVARCHAR(MAX)
DECLARE @sqlBasic2 NVARCHAR(MAX)


SET @sqlBasic1 ='
	SELECT 
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
	[Employees].EmployeeId, 
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
	END AS ProStatus,
	ISNULL((SELECT SUM(Budget) FROM [dbo].[ProjectPhase] WHERE [ProjectPhase].ProjectId = [Projects].ProjectId),0) As ProjectBudget
	'

SET @sqlBasic2='
	FROM [dbo].[Projects] 
			 LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId 
			 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId 
			 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId
			 LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId 
			 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId 
			 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId	
	'


IF @UserType <> 1
BEGIN
	
	SELECT @SQLStatement = 'SELECT DISTINCT ProjectAssign.RoleId, x.* FROM (
							(' + @sqlBasic1 + @sqlBasic2 + 
							' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							UNION
							(' + @sqlBasic1 + @sqlBasic2 + 
							' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
							INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							) x	LEFT JOIN ProjectAssign ON ProjectAssign.ProjectId = x.ProjectId AND ProjectAssign.EmployeeId = x.EmployeeId
							 WHERE '+ ISNULL(@Condition,'1=1') + ' ORDER BY x.' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ 
							'  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'

	SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount FROM(
				SELECT DISTINCT * FROM (
							(' + @sqlBasic1 + @sqlBasic2 + 
							' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							UNION
							(' + @sqlBasic1 + @sqlBasic2 + 
							' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
							INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							) x	 WHERE '+ ISNULL(@Condition,'1=1') + ') y'

END
ELSE
BEGIN

	SELECT @SQLStatement = 'SELECT DISTINCT -1 AS RoleId, x.* FROM 
							(' + @sqlBasic1 + @sqlBasic2 + 
							' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
							) x	 WHERE '+ ISNULL(@Condition,'1=1') + ' ORDER BY x.' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ 
							'  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'

	SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount FROM (
						SELECT DISTINCT -1 AS RoleId, x.* FROM 
							(' + @sqlBasic1 + @sqlBasic2 + 
							' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId 
							) x	 WHERE '+ ISNULL(@Condition,'1=1') + ') y'
END
EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
