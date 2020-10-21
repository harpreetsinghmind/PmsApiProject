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

/****** Object:  StoredProcedure [dbo].[usp_CustomersGetAll_NewExport]    Script Date: 9/9/2019 2:15:15 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_CustomersGetAll_NewExport] 
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
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
DECLARE @basicSql1 NVARCHAR(MAX)
DECLARE @basicSql2 NVARCHAR(MAX)
DECLARE @basicSql3 NVARCHAR(MAX)
DECLARE @basicSql4 NVARCHAR(MAX)
SET @basicSql1 ='
	SELECT DISTINCT 
		pc.[CustomerName] AS  ParentCustomerName,
		Customers.[CustomerCode], 
		Customers.[CustomerName], 
		Customers.[Website], 
		BusinessTypes.[BTName] AS BusinessTypeName,
		CASE Customers.[InActive]
			WHEN 0 THEN ''Active''
			WHEN 1 THEN ''InActive''
		END as Status,
		CustomerContacts.CTitle AS ContactPersonTitle,
		CustomerContacts.FirstName AS ContactPersonFirstName,
		CustomerContacts.MiddleName AS ContactPersonMiddleName,
		CustomerContacts.LastName AS ContactPersonLastName,
		CustomerContacts.WorkEmail AS ContactPersonEmail,
		CustomerContacts.MobileNo AS ContactPersonMobileNo,
		a.[EmailId],
		ca.[Purpose],
		CASE ca.[IsDefault] 
			WHEN 0 THEN ''No''
			WHEN 1 THEN ''Yes''
		END as IsPrimary,
		a.[MobileNo],
		a.[TelephoneNo],
		Customers.[FaxNo], 
		a.[AddressCode],
		a.[AddressLine1],
		a.[AddressLine2],
		co.[CountryName],
		s.[StateName],
		c.[CityName],
		z.[Zipcode],
		''FALSE'' AS IsDeleted,
		Customers.[Notes]
		'
SET @basicSql2 ='
		FROM 
			[Customers] 
			INNER JOIN 
				BusinessTypes ON BusinessTypes.BusinessTypeId=Customers.BusinessTypeId 
			INNER JOIN
				CustomerAdresses ca ON ca.CustomerId = Customers.CustomerId
			INNER JOIN
				Addresses a ON a.AddressId = ca.AddressId
			INNER JOIN 
				Cities c ON c.CityId = a.CityId
			INNER JOIN
				States s ON s.StateId = a.StateId
			INNER JOIN 
				Countries co ON co.CountryId = a.CountryId
			INNER JOIN
				Zipcodes z ON z.ZipcodeId = a.ZipCodeId
			LEFT OUTER JOIN
				CustomerContactPerson ON CustomerContactPerson.CustomerId = Customers.CustomerId
			LEFT OUTER JOIN
				CustomerContacts ON CustomerContacts.CContactId = CustomerContactPerson.CContactId
			LEFT JOIN Customers pc ON pc.CustomerId = Customers.ParentId 		
		'
SET @basicSql3 ='
		WHERE 
			1=1
	'
SET @basicSql4 ='
		INNER JOIN Projects ON Projects.CustomerId = Customers.CustomerId and Projects.ContactPersonId = CustomerContacts.CContactId
		INNER JOIN ProjectAssign ON ProjectAssign.ProjectId = Projects.ProjectId 
		INNER JOIN Employees ON Employees.EmployeeId = ProjectAssign.EmployeeId 
		'

IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement =@basicSql1 +  @basicSql2 + @basicSql3 + ' order by ' + @FieldName+ ' '+ @SortType
		 ELSE
		 BEGIN
		 SELECT @SQLStatement = @basicSql1 +  @basicSql2+ @basicSql3 + ' and '+ @Condition+' order by ' + @FieldName+ ' '+ @SortType   
		-- Execute the SQL statement
		Select @CountStatement ='SELECT COUNT(*) AS FilterCount ' + @basicSql2 + @basicSql3 +'  and ' + @Condition 
		End
	END
ELSE
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = @basicSql1 +  @basicSql2+ @basicSql4 +  @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) +' order by ' + @FieldName+ ' '+ @SortType
		 ELSE
		 BEGIN
		 SELECT @SQLStatement = @basicSql1 +  @basicSql2 + @basicSql4 +  @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+'  and '+ @Condition +' order by ' + @FieldName+ ' '+ @SortType
		-- Execute the SQL statement
		Select @CountStatement ='SELECT COUNT(*) AS FilterCount  '+  @basicSql2 + @basicSql4 + @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+'  and '+ @Condition 
		End
	END

EXEC(@SQLStatement)
EXEC(@CountStatement)
COMMIT
GO

