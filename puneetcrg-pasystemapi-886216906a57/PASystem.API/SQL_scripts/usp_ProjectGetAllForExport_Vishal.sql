ALTER PROC [dbo].[usp_ProjectGetAllForExport] --exec usp_ProjectGetAllForExport 10071,1
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

DECLARE @sqlBasic1 NVARCHAR(MAX)
DECLARE @sqlBasic2 NVARCHAR(MAX)
DECLARE @sqlBasic3 NVARCHAR(MAX)
DECLARE @SQLStatement varchar(MAX)

DECLARE @ColumnName AS nvarchar(MAX)
SELECT @ColumnName =  ISNULL(@ColumnName +',','') + QUOTENAME(AttributeLabel)
FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Projects
		LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Projects'
		LEFT JOIN AdHocAttributeValues AV ON Projects.ProjectId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels

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

SET @sqlBasic3='
	    LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Projects''
		LEFT JOIN AdHocAttributeValues AV ON Projects.ProjectId = AV.TablePKId AND AV.AttributeId = A.AttributeId'	


IF @UserType <> 1
BEGIN

    IF(@ColumnName is null)
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
	      SELECT @SQLStatement = '
		                          SELECT *
								  FROM
										(
											SELECT x.* 
											FROM(
											
													('+ @sqlBasic1 + ',  AttributeLabel, FieldValue' + @sqlBasic2 + @sqlBasic3 +
													' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
													 WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
										
													UNION
									
													(' + @sqlBasic1 + ',  AttributeLabel, FieldValue' + @sqlBasic2 + @sqlBasic3 + 
													' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
													  INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
													  WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
												) x  WHERE '+ ISNULL(@Condition,'1=1') + '
									     ) x1
											pivot
											(
											  MAX(FieldValue) FOR
											  AttributeLabel IN ('+ @ColumnName +')
											) pvt'
	END
END
ELSE
BEGIN

    IF(@ColumnName is null)
	BEGIN
			SELECT @SQLStatement = 'SELECT x.* FROM(('+ @sqlBasic1 + @sqlBasic2 + 
									' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  ) x 
									INNER JOIN Projects on Projects.Code = x.[Code]) WHERE '+ ISNULL(@Condition,'1=1') 

    END
	ELSE
	BEGIN
			SELECT @SQLStatement = 'SELECT *
								    FROM
										(
			                             SELECT x.* FROM(
													('+ @sqlBasic1 + ',  AttributeLabel, FieldValue' + @sqlBasic2 + @sqlBasic3 +
							                       ' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  ) x 
													INNER JOIN Projects on Projects.Code = x.[Code]) 
													WHERE '+ ISNULL(@Condition,'1=1') + '
									     ) x1
											pivot
											(
											  MAX(FieldValue) FOR
											  AttributeLabel IN ('+ @ColumnName +')
											) pvt'
	END
END

PRINT @SQLStatement
EXEC(@SQLStatement)

	
	COMMIT