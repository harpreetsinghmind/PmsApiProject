ALTER PROC [dbo].[usp_StatesGetAll_NewExport] --'asc', 'stateName', 'Where countryName like ''%%'' and stateName like ''%%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].States S
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'States'
			LEFT JOIN AdHocAttributeValues AV ON S.StateId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
		
		IF @Condition is null
		    IF @ColumnName IS NULL
				BEGIN
					SELECT @SQLStatement = 'SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],''FALSE'' AS IsDeleted
						FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType
				END
			ELSE
				BEGIN

						SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],  AttributeLabel, FieldValue,''FALSE'' AS IsDeleted
							FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId 
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''States''
													LEFT JOIN AdHocAttributeValues AV ON States.StateId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
						SELECT @SQLStatement = 'SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],''FALSE'' AS IsDeleted
						FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
				  END
			  ELSE
				  BEGIN
			           SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Countries.CountryName,[StateName], [StateCode], States.[InActive],States.[Notes],  AttributeLabel, FieldValue,''FALSE'' AS IsDeleted
							FROM   [dbo].[States] inner join Countries on Countries.CountryId=States.CountryId 
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''States''
													LEFT JOIN AdHocAttributeValues AV ON States.StateId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
				  END


				
				--PRINT @SQLStatement

				Select @CountStatement ='Select Count(*) as FilterCount from States inner join Countries on Countries.CountryId=States.CountryId ' +@Condition
		END
		
		
		EXEC(@SQLStatement)
		EXEC(@CountStatement)


	COMMIT
