USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_EmployeesGetAll]    Script Date: 5/13/2019 2:30:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_EmployeesGetAll] 
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
IF @Condition is null or @Condition = ' '
SELECT @SQLStatement ='SELECT [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName],(FirstName+'' ''+CASE when ISNULL(MiddleName,'' '') = '' '' then ISNULL(MiddleName,'''') ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [RateSGroup], [VendorID], [UserNumber], [UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],[Isdeleted] FROM   [dbo].[Employees] where Isdeleted = ''false'' or Isdeleted Is NULL order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'select * from(SELECT [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when ISNULL(MiddleName,'' '') = '' '' then ISNULL(MiddleName,'''') ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [RateSGroup], [VendorID], [UserNumber], [UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],[Isdeleted] FROM   [dbo].[Employees] where Isdeleted = ''false'' or Isdeleted Is NULL) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM((SELECT (FirstName+'' ''+CASE when ISNULL(MiddleName,'' '') = '' '' then ISNULL(MiddleName,'''') ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName,UserNumber from [dbo].[Employees] where Isdeleted = ''false'' or Isdeleted Is NULL)) x ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)	

	COMMIT
