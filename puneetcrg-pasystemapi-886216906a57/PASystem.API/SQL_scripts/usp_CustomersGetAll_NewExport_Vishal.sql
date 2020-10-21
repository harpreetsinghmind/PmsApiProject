--exec [usp_CustomersGetAll_NewExport] 'asc','customerName',10098,1,null
ALTER PROC [dbo].[usp_CustomersGetAll_NewExport] 
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

	DECLARE @ColumnName AS nvarchar(MAX)
	SELECT @ColumnName =  ISNULL(@ColumnName +',','') + QUOTENAME(AttributeLabel)
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Customers C
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Customers'
			LEFT JOIN AdHocAttributeValues AV ON C.CustomerId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
DECLARE @basicSql1 NVARCHAR(MAX)
DECLARE @basicSql2 NVARCHAR(MAX)
DECLARE @basicSql3 NVARCHAR(MAX)
DECLARE @basicSql4 NVARCHAR(MAX)
DECLARE @basicSql5 NVARCHAR(MAX)
DECLARE @basicSql6 NVARCHAR(MAX)

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
SET @basicSql5 =',AttributeLabel, FieldValue'
SET @basicSql6 = 'LEFT JOIN AdHocAttributes Ad ON  Ad.InActive = 0  AND TableName = ''Customers''
				  LEFT JOIN AdHocAttributeValues AV ON Customers.CustomerId = AV.TablePKId AND AV.AttributeId = Ad.AttributeId'

IF @UserType = 1
	BEGIN
		 IF @Condition is null
		     IF @ColumnName IS NULL
				 BEGIN
					  SELECT @SQLStatement =@basicSql1 +  @basicSql2 + @basicSql3 + ' order by ' + @FieldName+ ' '+ @SortType
				 END
			 ELSE
				 BEGIN
				      SELECT @SQLStatement = 'SELECT * from
						(
							' 
							  + @basicSql1 + @basicSql5 +  @basicSql2 + @basicSql6 + @basicSql3 +
							'
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
					   
				 END
			
		 ELSE
		 BEGIN

		    IF( @ColumnName IS NULL)
				BEGIN
				     SELECT @SQLStatement = @basicSql1 +  @basicSql2+ @basicSql3 + ' and '+ @Condition+' order by ' + @FieldName+ ' '+ @SortType   
				END
			ELSE
				BEGIN
				    SELECT @SQLStatement = 'SELECT * from
						(
							' 
							  + @basicSql1 + @basicSql5 +  @basicSql2 + @basicSql6 + @basicSql3 + ' and '+ @Condition+
							'
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
				END
			
			-- Execute the SQL statement
			Select @CountStatement ='SELECT COUNT(*) AS FilterCount ' + @basicSql2 + @basicSql3 +'  and ' + @Condition 
		End
	END
ELSE
	BEGIN
		 IF @Condition is null
		    IF @ColumnName IS NULL
				BEGIN
					SELECT @SQLStatement = @basicSql1 +  @basicSql2+ @basicSql4 +  @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) +' order by ' + @FieldName+ ' '+ @SortType
				END
			ELSE
				BEGIN
				    SELECT @SQLStatement = 'SELECT * from
						(
							' 
							  + @basicSql1 + @basicSql5 +  @basicSql2 + @basicSql6 + @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) +
							'
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
				END

			
		 ELSE
		 BEGIN

		    IF(@ColumnName IS NULL)
			BEGIN
			    SELECT @SQLStatement = @basicSql1 +  @basicSql2 + @basicSql4 +  @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+'  and '+ @Condition +' order by ' + @FieldName+ ' '+ @SortType
			END
			ELSE
			BEGIN
			   SELECT @SQLStatement = 'SELECT * from
						(
							' 
							  + @basicSql1 + @basicSql5 +  @basicSql2 + @basicSql6 + @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) + ' and '+ @Condition+
							'
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
			END
			
			-- Execute the SQL statement
			Select @CountStatement ='SELECT COUNT(*) AS FilterCount  '+  @basicSql2 + @basicSql4 + @basicSql3 +' and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+'  and '+ @Condition 
		End
	END

	PRINT @SQLStatement

	EXEC(@SQLStatement)
	EXEC(@CountStatement)

COMMIT