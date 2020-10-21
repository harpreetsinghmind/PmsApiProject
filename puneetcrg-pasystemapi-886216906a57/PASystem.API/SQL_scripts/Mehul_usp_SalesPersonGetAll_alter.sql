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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonGetAll]    Script Date: 8/6/2019 3:07:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_SalesPersonGetAll] 
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

	DECLARE @CommonQuery varchar(MAX)
	SET @CommonQuery = 'SELECT SalesPerson.[SalesPersonId], [STitle], SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName],(SalesPerson.FirstName+'' ''+CASE when LTRIM(RTRIM(SalesPerson.MiddleName)) = '' '' then LTRIM(RTRIM(SalesPerson.MiddleName)) ELSE LTRIM(RTRIM(SalesPerson.MiddleName)) +'' ''end +SalesPerson.LastName) AS FullName, SalesPerson.[DOB], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[CreatedBy], SalesPerson.[CreatedDate], SalesPerson.[UpdatedBy], SalesPerson.[UpdatedDate],SalesPerson.[Notes] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 'SELECT SalesPerson.[SalesPersonId], [STitle], SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName],(SalesPerson.FirstName+'' ''+CASE when LTRIM(RTRIM(SalesPerson.MiddleName)) = '' '' then LTRIM(RTRIM(SalesPerson.MiddleName)) ELSE LTRIM(RTRIM(SalesPerson.MiddleName)) +'' ''end +SalesPerson.LastName) AS FullName, SalesPerson.[DOB], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[CreatedBy], SalesPerson.[CreatedDate], SalesPerson.[UpdatedBy], SalesPerson.[UpdatedDate],SalesPerson.[Notes] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM(SELECT (SalesPerson.FirstName+'' ''+CASE when LTRIM(RTRIM(SalesPerson.MiddleName)) = '' '' then LTRIM(RTRIM(SalesPerson.MiddleName)) ELSE LTRIM(RTRIM(SalesPerson.MiddleName)) +'' ''end +SalesPerson.LastName) AS FullName FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM(SELECT (SalesPerson.FirstName+'' ''+CASE when LTRIM(RTRIM(SalesPerson.MiddleName)) = '' '' then LTRIM(RTRIM(SalesPerson.MiddleName)) ELSE LTRIM(RTRIM(SalesPerson.MiddleName)) +'' ''end +SalesPerson.LastName) AS FullName FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'SELECT [SalesPersonId], [STitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [DOB], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[CreatedBy], SalesPerson.[CreatedDate], SalesPerson.[UpdatedBy], SalesPerson.[UpdatedDate],SalesPerson.[Notes] FROM [dbo].[SalesPerson] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select * from (SELECT [SalesPersonId], [STitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [DOB], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[CreatedBy], SalesPerson.[CreatedDate], SalesPerson.[UpdatedBy], SalesPerson.[UpdatedDate],SalesPerson.[Notes] FROM [dbo].[SalesPerson]) x  '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM((SELECT (FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName FROM [dbo].[SalesPerson])) x ' +@Condition
		End
	END
ELSE
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery + ') UNION ('+ @CommonQuery2 +')) x order by x.'+@FieldName+' '+@SortType+ ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +') UNION ('+ @CommonQuery2 +')) x '+@Condition+' order by x.'+@FieldName+' '+@SortType+' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'   
		-- Execute the SQL statement
		Select @CountStatement ='select DISTINCT Count(*) as FilterCount from((' + @CountQuery +') UNION ('+ @CountQuery2 +')) y'
		End
	END
EXEC(@SQLStatement)
EXEC(@CountStatement)


	COMMIT
GO

