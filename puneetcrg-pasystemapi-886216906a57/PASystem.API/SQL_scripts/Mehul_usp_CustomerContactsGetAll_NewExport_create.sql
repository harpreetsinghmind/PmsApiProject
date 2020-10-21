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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsGetAll_NewExport]    Script Date: 9/11/2019 11:35:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_CustomerContactsGetAll_NewExport] 
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
	SET @CommonQuery = 'SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 'SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM  (SELECT CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM  (SELECT CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted FROM [dbo].[CustomerContacts] order by ' + @FieldName+ ' '+ @SortType
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select * from (SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted FROM [dbo].[CustomerContacts]) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM (SELECT CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName FROM [dbo].[CustomerContacts]) x ' +@Condition
		End
	END
ELSE
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery + ') UNION ('+ @CommonQuery2 +')) x order by x.'+@FieldName+' '+@SortType
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +') UNION ('+ @CommonQuery2 +')) x '+@Condition+' order by x.'+@FieldName+' '+@SortType
		-- Execute the SQL statement
		Select @CountStatement ='select DISTINCT Count(*) as FilterCount from((' + @CountQuery +') UNION ('+ @CountQuery2 +')) y'
		End
	END
EXEC(@SQLStatement)
EXEC(@CountStatement)
COMMIT
GO

