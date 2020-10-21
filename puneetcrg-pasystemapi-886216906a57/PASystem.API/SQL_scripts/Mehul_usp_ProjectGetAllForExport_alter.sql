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

/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllForExport]    Script Date: 9/18/2019 11:35:58 AM ******/
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
			[Projects].[Name], 
			[ShortDescription], 
			[Description], 
			[Customers].CustomerName, 
			[ProjectTypes].Name AS ProjectType, 
			[ProjectSources].Name AS ProjectSource, 
			[Addresses].AddressCode AS Office,
			CONVERT(varchar,[Projects].[PlannedStartDate],101) AS PlannedStartDate,
			CONVERT(varchar,[Projects].[StartDate],101) AS StartDate,
			CONVERT(varchar,[Projects].[EndDate],101) AS EndDate,
			CONVERT(varchar,[Projects].[ActualDate],101) AS ActualDate,
			CASE [Projects].[PaymentType]
				WHEN 1 THEN ''CASH''
				WHEN 2 THEN ''Bank cheque''
				WHEN 3 THEN ''Online''
			END as PaymentMode,
			[Employees].FirstName AS ProjectManagerFirstName,
			[Employees].MiddleName AS ProjectManagerMiddleName,
			[Employees].LastName AS ProjectManagerLastName,
			[SalesPerson].FirstName AS SalesPersonFirstName,
			[SalesPerson].MiddleName AS SalesPersonMiddleName,
			[SalesPerson].LastName AS SalesPersonLastName,
			[CustomerContacts].FirstName AS ContactPersonFirstName,
			[CustomerContacts].MiddleName AS ContactPersonMiddleName,
			[CustomerContacts].LastName AS ContactPersonLastName,	
			[Projects].[WorkingDays],
			[Projects].InActive,
			''FALSE'' AS IsDeleted
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
GO

