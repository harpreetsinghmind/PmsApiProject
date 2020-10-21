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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonGetAll_NewExport]    Script Date: 9/11/2019 12:38:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_SalesPersonGetAll_NewExport] 
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
	SET @CommonQuery = 'SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 'SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM(SELECT SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM(SELECT SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted FROM [dbo].[SalesPerson] order by ' + @FieldName+ ' '+ @SortType
		ELSE
		BEGIN
		SELECT @SQLStatement = 'select * from (SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted FROM [dbo].[SalesPerson]) x  '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM((SELECT [FirstName], [MiddleName], [LastName] FROM [dbo].[SalesPerson])) x ' +@Condition
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

