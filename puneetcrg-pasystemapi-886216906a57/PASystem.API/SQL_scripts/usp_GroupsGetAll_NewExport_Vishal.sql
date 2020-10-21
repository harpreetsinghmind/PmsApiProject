CREATE PROC [dbo].[usp_GroupsGetAll_NewExport] 
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
	DECLARE @ColumnName AS nvarchar(MAX)
	SELECT @ColumnName =  ISNULL(@ColumnName +',','') + QUOTENAME(AttributeLabel)
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Groups G
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Groups'
			LEFT JOIN AdHocAttributeValues AV ON G.GroupId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels


		-- Enter the dynamic SQL statement into the
		-- variable @SQLStatement
		IF @Condition is null
		        IF @ColumnName IS NULL
					BEGIN
						  SELECT @SQLStatement = 'SELECT [GroupId], [GroupName], [GroupDesc], [InActive] 
						FROM   [dbo].[Groups]  order by ' + @FieldName+ ' '+ @SortType 
					END
				ELSE
					BEGIN
					      SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [GroupId], [GroupName], [GroupDesc], G.[InActive],  AttributeLabel, FieldValue 
											FROM   [dbo].[Groups] G
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Groups''
													LEFT JOIN AdHocAttributeValues AV ON G.GroupId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
						SELECT @SQLStatement = 'SELECT [GroupId], [GroupName], [GroupDesc], [InActive] 
						FROM   [dbo].[Groups]  '+@Condition+' order by ' + @FieldName+ ' '+ @SortType    
				END
			ELSE
				  BEGIN 
				        SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [GroupId], [GroupName], [GroupDesc], G.[InActive],  AttributeLabel, FieldValue FROM   [dbo].[Groups] G
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Groups''
													LEFT JOIN AdHocAttributeValues AV ON G.GroupId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
				  END
			-- Execute the SQL statement
			Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Groups] ' +@Condition
		End

		PRINT @SQLStatement
		EXEC(@SQLStatement)
		EXEC(@CountStatement)

	

	COMMIT