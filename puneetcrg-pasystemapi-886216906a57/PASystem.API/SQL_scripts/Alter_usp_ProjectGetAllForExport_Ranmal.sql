USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllForExport]    Script Date: 7/18/2019 1:15:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectGetAllForExport] 
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

DECLARE @sqlBasic1 NVARCHAR(MAX)
DECLARE @sqlBasic2 NVARCHAR(MAX)
DECLARE @SQLStatement varchar(MAX)

SET @sqlBasic1 ='
		SELECT 
			ROW_NUMBER() OVER (ORDER BY Projects.ProjectId) AS ''Sr. No'', 
			[Projects].[Name], 
			[Code], 
			[ShortDescription], 
			[Description], 
			[Customers].CustomerName, 
			[ProjectTypes].Name AS ProjectType, 
			[ProjectSources].Name AS ProjectSource, 
			[Addresses].AddressCode AS Office,
			[Projects].[PlannedStartDate],
			[Projects].[StartDate],
			[Projects].[EndDate],
			[Projects].[ActualDate],  
			CASE [Projects].[PaymentType]
				WHEN 1 THEN ''CASH''
				WHEN 2 THEN ''Bank cheque''
				WHEN 3 THEN ''Online''
			END as PaymentMode,
			(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''''))) + '' ''+
			CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) = ''''
				THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '''')))
				ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''''))) + '' ''
			END +
			LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS ProjectManager,
			(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+
			CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''
				THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))
				ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''
			END +
			LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,
			(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+
			CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''
				THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))
				ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''
			END +
			LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,	
			CASE WHEN Projects.InActive = 0
			THEN
				CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN ''NOT-STARTED''
					WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN ''OPENED''
					ELSE ''CLOSED''
				END 
			ELSE ''ARCHIVED''
			END	AS Status
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
	SELECT @SQLStatement = 'SELECT x.* FROM(('+ @sqlBasic1 + @sqlBasic2 + 
							' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							UNION
							(' + @sqlBasic1 + @sqlBasic2 + 
							' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
							INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
							WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
							) x  WHERE '+ ISNULL(@Condition,'1=1') 
END
ELSE
BEGIN
	SELECT @SQLStatement = 'SELECT x.* FROM(('+ @sqlBasic1 + @sqlBasic2 + 
							' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  ) x 
							INNER JOIN Projects on Projects.Code = x.[Code]) WHERE '+ ISNULL(@Condition,'1=1') 
END

EXEC(@SQLStatement)

	
	COMMIT
