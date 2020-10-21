ALTER PROC [dbo].[usp_CustomersGetAllParentExport] 
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
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
DECLARE @basicSql1 NVARCHAR(MAX)
DECLARE @basicSql2 NVARCHAR(MAX)
DECLARE @basicSql3 NVARCHAR(MAX)
DECLARE @basicSql4 NVARCHAR(MAX)
SET @basicSql1 ='
	SELECT DISTINCT 
		Customers.[CustomerCode], 
		Customers.[CustomerName], 
		Customers.[FaxNo], 
		Customers.[Website], 
		Customers.[Notes],
		CASE [Customers].[InActive]
		 WHEN 0 THEN ''Active''
		 WHEN 1 THEN ''InActive''
		END as InActive, 
		Customers.[CreatedBy], 
		Customers.[UpdatedBy], 
		Customers.[CreatedDate], 
		Customers.[UpdatedDate],
		BusinessTypes.[BTName],
		CASE [Customers].[IsDeleted]
		 WHEN 0 THEN ''False''
		 WHEN 1 THEN ''True''
		END as IsDeleted,
		c.[CityName],
		s.[StateName],
		co.[CountryName],
		z.[Zipcode],
		a.[AddressLine1],
		a.[AddressLine2],
		a.[EmailId],
		a.[TelephoneNo],
		a.[MobileNo],
		ca.[Purpose],
		pc.[CustomerName] AS  ParentCustomerName,
		(SELECT STUFF
		(
			(
				SELECT '','' + s.CustomerName 
				FROM Customers s
				WHERE s.ParentId = [Customers].[CustomerId]
				ORDER BY s.CustomerName FOR XML PATH('''')
			),
			 1, 1, ''''
		) ) AS SubCustomers
		'
SET @basicSql2 ='
		FROM 
			[Customers] 
			INNER JOIN 
				BusinessTypes ON BusinessTypes.BusinessTypeId=Customers.BusinessTypeId 
			INNER JOIN
				CustomerAdresses ca ON ca.CustomerId = Customers.CustomerId
			INNER JOIN
				Addresses a ON a.AddressId = ca.AddressId AND ca.IsDefault =1
			INNER JOIN 
				Cities c ON c.CityId = a.CityId
			INNER JOIN
				States s ON s.StateId = a.StateId
			INNER JOIN 
				Countries co ON co.CountryId = a.CountryId
			INNER JOIN
				Zipcodes z ON z.ZipcodeId = a.ZipCodeId
			LEFT JOIN Customers pc ON pc.CustomerId = Customers.ParentId 		
		'
SET @basicSql3 ='
		WHERE 
			1=1
	'
SET @basicSql4 ='
		INNER JOIN Projects ON Projects.CustomerId = Customers.CustomerId 
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