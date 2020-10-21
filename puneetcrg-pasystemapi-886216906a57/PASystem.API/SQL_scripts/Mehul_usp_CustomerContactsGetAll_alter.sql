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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsGetAll]    Script Date: 8/5/2019 4:41:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_CustomerContactsGetAll] 
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
	SET @CommonQuery = 'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName, CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes] FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName, CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes] FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM  (SELECT (CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM  (SELECT (CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName, CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes] FROM [dbo].[CustomerContacts] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select * from (SELECT [CContactId], CustomerContacts.[CustomerId],[CTitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [DOB], [Gender], [WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate], CustomerContacts.[Notes] FROM [dbo].[CustomerContacts]) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM (SELECT (FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName FROM [dbo].[CustomerContacts]) x ' +@Condition
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

