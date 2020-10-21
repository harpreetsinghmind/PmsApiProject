USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeesGetAll]    Script Date: 7/12/2019 7:07:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_EmployeesGetAllExport] 
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

DECLARE @basicSql1 NVARCHAR(MAX)
DECLARE @basicSql2 NVARCHAR(MAX)
DECLARE @basicSql3 NVARCHAR(MAX)
DECLARE @basicSql4 NVARCHAR(MAX)
SET @basicSql1 ='
		SELECT  DISTINCT
			[Employees].[EmpCode] AS UserNumber,
			[Employees].[EmpTitle] AS EmpTitle,
			[Employees].[FirstName], 
			[Employees].[MiddleName],
			[Employees].[LastName],
			([Employees].FirstName+'' ''+CASE when ISNULL([Employees].MiddleName,'''') = '''' then ISNULL([Employees].MiddleName,'''') ELSE LTRIM(RTRIM([Employees].MiddleName)) +'' ''end +[Employees].LastName) AS FullName, 
			[Employees].[JoiningDate], 
			[Employees].[DOB], 
			[Employees].[Gender], 
			[Employees].[WorkEmail], 
			[Employees].[PersonalEmail],
			(SELECT STUFF
				(
					(
						SELECT '','' + s.Name 
						FROM OrgStructureMapping ms
						INNER JOIN OrgStructure s ON ms.OrgStructureId = s.OrgStructureId
						WHERE ms.UserId = [Employees].[UserId]
						ORDER BY s.Name FOR XML PATH('''')
					),
					 1, 1, ''''
				) ) AS OrgLevel,
				(SELECT STUFF
				(
					(
						SELECT '','' + s.Name 
						FROM OrgStructureMapping ms
						INNER JOIN OrgStructureLevel s ON ms.OrgSructureLevelId = s.OrgStructureLevelId
						WHERE ms.UserId = [Employees].[UserId]
						ORDER BY s.Name FOR XML PATH('''')
					),
					 1, 1, ''''
				) ) AS OrgLevelElement,
			(r.FirstName+'' ''+CASE when ISNULL(r.MiddleName,'''') = '''' then ISNULL(r.MiddleName,'''') ELSE LTRIM(RTRIM(r.MiddleName)) +'' ''end +r.LastName) AS ReportingTo, 
			[Employees].[FatherName],
			[Employees].[MobileNo], 
			[Employees].[LandlineNo], 
			[Employees].[EmpStatus],
			[Employees].[ReleavingDate], 
			CASE [Employees].[InActive]
				WHEN 0 THEN ''Active''
				WHEN 1 THEN ''InActive''
			END as InActive, 
			[Employees].[CreatedBy],
			[Employees].[CreatedDate],
			[Employees].[UpdatedBy],
			[Employees].[UpdatedDate],
			CASE [Employees].[EmpType]
				WHEN ''1'' THEN ''Employee''
				WHEN ''2'' THEN ''Contractor''
				ELSE [Employees].[EmpType]
			END as EmpType, 
			[Employees].[InActiveDate], 
			[Employees].[InActiveReason],
			[Employees].[BillingRate],
			[Employees].[CostRate],
			[Employees].[BillingTarget], 
			[Employees].[ExpenseEntry], 
			[Employees].[RateSGroup],
			[Employees].[VendorID], 
			[Employees].[PayrollState], 
			[Employees].[HomePhoneNo], 
			[Employees].[MaritalStaus],
			[Employees].[SpouseName],
			[Employees].[EthnicOrigin],
			[Employees].[Address],
			co.CountryName,
			s.StateName,
			c.CityName,
			z.Zipcode
			'
SET @basicSql2='
		FROM   
		[dbo].[Employees] 
		INNER JOIN 
			Cities c ON c.CityId = [Employees].CityId
		INNER JOIN
			States s ON s.StateId = [Employees].StateId
		INNER JOIN 
			Countries co ON co.CountryId = [Employees].CountryId
		INNER JOIN
			Zipcodes z ON z.ZipcodeId = [Employees].ZipCodeId
		LEFT JOIN
			Employees r ON r.EmployeeId = [Employees].ReportingTo
		'
SET @basicSql3='
		WHERE [Employees].Isdeleted = ''false'' OR [Employees].Isdeleted Is NULL
'

IF @Condition is null or @Condition = ' '
SELECT @SQLStatement =@basicSql1 + @basicSql2 + @basicSql3 + ' order by ' + @FieldName+ ' '+ @SortType
ELSE
BEGIN
SELECT @SQLStatement = 'select * from('+@basicSql1 + @basicSql2 + @basicSql3 +') x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType   
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM('+@basicSql1 + @basicSql2 + @basicSql3 +') x ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)	

	COMMIT
