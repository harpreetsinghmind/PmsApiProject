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

/****** Object:  StoredProcedure [dbo].[usp_EmployeesGetAll]    Script Date: 3/28/2019 4:12:51 PM ******/
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
IF @Condition is null
SELECT @SQLStatement ='SELECT [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [PaymentMethod], [RateSGroup], [VendorID], [UserNumber], [UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],[Isdeleted] FROM   [dbo].[Employees] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [PaymentMethod], [RateSGroup], [VendorID], [UserNumber], [UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],[Isdeleted] FROM   [dbo].[Employees] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Employees] ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)	

	COMMIT
GO

