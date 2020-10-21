ALTER PROC [dbo].[usp_CustomerContactsGetAll_NewExport] --exec [usp_CustomerContactsGetAll_NewExport]  'asc','firstName',10031,2,'where [CustomerContacts].FirstName like ''%himanshu%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].CustomerContacts C
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Contact Persons'
			LEFT JOIN AdHocAttributeValues AV ON C.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels

	DECLARE @CommonQuery varchar(MAX)

	

	IF @ColumnName IS NULL
		BEGIN
				SET @CommonQuery = 'SELECT [CTitle] AS Title, [CustomerContacts].FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted 
									FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
																  inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
																  inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId' 
												
				SET @CommonQuery = @CommonQuery + 'where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))

		END
	ELSE
		BEGIN

		        IF(@Condition is null)
				begin
					SET @CommonQuery =  'SELECT * from
							(
								SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], 
										CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,
										CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
								FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
															  inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
															  inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId 
																	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
																	LEFT JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								Where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + '
							) x1
							pivot
							(
							  MAX(FieldValue) FOR
							  AttributeLabel IN ('+ @ColumnName +')
							) pvt ' 

				 end
				 else
				 begin
				       SET @CommonQuery =  'SELECT * from
							(
								SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], 
										CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,
										CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
								FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
															  inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
															  inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId 
																	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
																	LEFT JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								'+@Condition+' AND Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + '
							) x1
							pivot
							(
							  MAX(FieldValue) FOR
							  AttributeLabel IN ('+ @ColumnName +')
							) pvt ' 


				 end

			--SET @CommonQuery = @CommonQuery 

		END

    
	DECLARE @CommonQuery2 varchar(MAX)

	IF @ColumnName IS NULL
		BEGIN
			SET @CommonQuery2 = 'SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted 
								 FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
															 inner join Employees on Employees.EmployeeId = Projects.ManagerId' 

			SET @CommonQuery2 = @CommonQuery2 + ' where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
		END
	ELSE
		BEGIN

		    if(@Condition is null)
			begin
			SET @CommonQuery2 = 'SELECT * from
									(
									  SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], 
											 [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],
											 CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
											 FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
																		   inner join Employees on Employees.EmployeeId = Projects.ManagerId
																		   LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
																		   LEFT JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
											WHERE Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + '
									) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt ' 
			end
			else
			begin
			    SET @CommonQuery2 = 'SELECT * from
									(
									  SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], 
											 [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],
											 CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
											 FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
																		   inner join Employees on Employees.EmployeeId = Projects.ManagerId
																		   LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
																		   LEFT JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
											'+@Condition+' AND Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + '
									) x1
									pivot
									(
									  MAX(FieldValue) FOR
									  AttributeLabel IN ('+ @ColumnName +')
									) pvt ' 
			end
	END

	
     
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM  (SELECT CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName 
						FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
	
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM  (SELECT CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName 
						FROM [dbo].CustomerContacts inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
						inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
    

	-- Enter the dynamic SQL statement into the
	-- variable @SQLStatement
	
	IF @UserType = 1
		BEGIN
			IF @Condition is null
			       
				    IF @ColumnName IS NULL
					BEGIN
					     SELECT @SQLStatement = 'SELECT [CTitle] AS Title, CustomerContacts.FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], 
														[OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],
														CustomerContacts.[Notes],''FALSE'' AS IsDeleted 
												 FROM [dbo].CustomerContacts order by ' + @FieldName+ ' '+ @SortType
					END
					ELSE
					BEGIN
					     SELECT @SQLStatement =  'SELECT * from
								(
									SELECT [CTitle] AS Title, [CustomerContacts].FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], CustomerContacts.[WorkEmail], 
														[OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo], CustomerContacts.Department,CustomerContacts.Designation, CustomerContacts.[InActive],
														CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
										FROM [dbo].[CustomerContacts]
							                      			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
															LEFT JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
								) x
								pivot
								(
								  MAX(FieldValue) FOR
								  AttributeLabel IN ('+ @ColumnName +')
								) pvt order by ' + @FieldName+ ' '+ @SortType
					END
				     

					
			ELSE
			BEGIN

			        IF @ColumnName IS NULL
					BEGIN
					     SELECT @SQLStatement = 'select * from (SELECT [CTitle] AS Title, [CustomerContacts].FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], 
												 CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.Department,CustomerContacts.Designation, 
												 CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted 
												 FROM [dbo].[CustomerContacts]) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
					END
					ELSE
					BEGIN
					    SELECT @SQLStatement =  'SELECT * from
								(
									select * from (
													SELECT [CTitle] AS Title, [CustomerContacts].FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName, CustomerContacts.[Gender], 
													CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.Department,CustomerContacts.Designation, 
													CustomerContacts.[InActive],CustomerContacts.[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
													FROM [dbo].[CustomerContacts]
																					LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Contact Persons''
																				    JOIN AdHocAttributeValues AV ON CustomerContacts.CContactId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
					SELECT @CountStatement ='Select Count(*) as FilterCount FROM (SELECT [CustomerContacts].FirstName, CustomerContacts.MiddleName, CustomerContacts.LastName FROM [dbo].[CustomerContacts]) x ' +@Condition
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
	--PRINT @CountStatement
	EXEC(@SQLStatement)
	--EXEC(@CountStatement)


COMMIT