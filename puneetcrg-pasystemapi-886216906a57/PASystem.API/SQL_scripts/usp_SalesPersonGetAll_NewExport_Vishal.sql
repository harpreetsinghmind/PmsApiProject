ALTER PROC [dbo].[usp_SalesPersonGetAll_NewExport] --exec [usp_SalesPersonGetAll_NewExport] 'asc','firstName',10031,2,'where firstName like ''%%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].[SalesPerson] S
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Sales Persons'
			LEFT JOIN AdHocAttributeValues AV ON S.SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels


	DECLARE @CommonQuery varchar(MAX)

	IF(@ColumnName IS NULL)
	BEGIN

	SET @CommonQuery = 'SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join
						ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId 
						where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	
	END
	ELSE
	BEGIN

	   IF @Condition is null
	   BEGIN
			  SET @CommonQuery = '
								 SELECT * from
									(
										 SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], 
											SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue  
											FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
																	 inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId 
																	 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
																	 LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
																	 LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
										 where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) + '
								   ) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt '

		END
		ELSE
		BEGIN
             SET @CommonQuery = '
								 SELECT * from
									(
										 SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], 
											SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue  
											FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
																	 inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId 
																	 inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
																	 LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
																	 LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
										 '+@Condition+' AND  Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) + '
								   ) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt '

		END
	END

	DECLARE @CommonQuery2 varchar(MAX)

	IF(@ColumnName IS NULL)
	BEGIN
	SET @CommonQuery2 = 'SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], 
						 SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted
						 FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
												  inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId 
												  inner join Employees on Employees.EmployeeId = Projects.ManagerId 

						 where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))
	END
	ELSE
	BEGIN

	   IF(@Condition IS NULL)
	   BEGIN
			   SET @CommonQuery2 = '
								SELECT * from
									(
										 SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], 
										 SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue    
										 FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
																  inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId 
																  inner join Employees on Employees.EmployeeId = Projects.ManagerId
																  LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
																  LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								 where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+ '
								   ) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt '
		END
		ELSE
		BEGIN

                SET @CommonQuery2 = '
								SELECT * from
									(
										 SELECT [STitle] AS Title, SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName], SalesPerson.[Gender], SalesPerson.[WorkEmail], [OtherEmail], 
										 SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue    
										 FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
																  inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId 
																  inner join Employees on Employees.EmployeeId = Projects.ManagerId
																  LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
																  LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								 '+@Condition+' AND Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+ '
								   ) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt '
		END
	END


	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM(SELECT SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
	
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM(SELECT SalesPerson.[FirstName], SalesPerson.[MiddleName], SalesPerson.[LastName] FROM [dbo].[SalesPerson] INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId inner join Projects on Projects.CustomerId = CustomerSalesPerson.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX))+') x '+@Condition+' '
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		    IF @ColumnName IS NULL
			BEGIN
			     SELECT @SQLStatement = 'SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted 
										 FROM [dbo].[SalesPerson] order by ' + @FieldName+ ' '+ @SortType
			END
			ELSE
			BEGIN
			    SELECT @SQLStatement =  'SELECT * from
								(
									SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[InActive], 
											SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
										 FROM [dbo].[SalesPerson] 
							                      			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
															LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								) x
								pivot
								(
								  MAX(FieldValue) FOR
								  AttributeLabel IN ('+ @ColumnName +')
								) pvt order by ' + @FieldName+ ' '+ @SortType
                  SELECT @SQLStatement = 'order by ' + @FieldName+ ' '+ @SortType

			END
			
		ELSE
		BEGIN
		    
			 IF @ColumnName IS NULL
			 BEGIN

					SELECT @SQLStatement = 'select * from (SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], 
											SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted 
											FROM [dbo].[SalesPerson]) x  '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
			
			 END
			 ELSE
			 BEGIN
			       	SELECT @SQLStatement =  'SELECT * from
								(
									select * from (
													SELECT [STitle] AS Title, [FirstName], [MiddleName], [LastName], [Gender], [WorkEmail], [OtherEmail], SalesPerson.[MobileNo], 
													SalesPerson.[TelephoneNo],SalesPerson.[InActive], SalesPerson.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue  
													FROM [dbo].[SalesPerson]
																			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Sales Persons''
																			LEFT JOIN AdHocAttributeValues AV ON [SalesPerson].SalesPersonId = AV.TablePKId AND AV.AttributeId = A.AttributeId
													'+@Condition+' 
												  ) x
									
								) x1
								pivot
								(
								  MAX(FieldValue) FOR
								  AttributeLabel IN ('+ @ColumnName +')
								) pvt order by ' + @FieldName+ ' '+ @SortType
    
			 END
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

					IF @ColumnName IS NULL
						BEGIN
							SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +') UNION ('+ @CommonQuery2 +')) x '+@Condition+' order by x.'+@FieldName+' '+@SortType
						END
					ELSE
						BEGIN
							SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +') UNION ('+ @CommonQuery2 +')) x order by x.'+@FieldName+' '+@SortType
						END


		
						-- Execute the SQL statement
						Select @CountStatement ='select DISTINCT Count(*) as FilterCount from((' + @CountQuery +') UNION ('+ @CountQuery2 +')) y'
		End
	END


	PRINT @SQLStatement
EXEC(@SQLStatement)
--EXEC(@CountStatement)


	COMMIT


 
