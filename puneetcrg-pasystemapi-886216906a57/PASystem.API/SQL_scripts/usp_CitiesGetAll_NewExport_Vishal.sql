ALTER PROC [dbo].[usp_CitiesGetAll_NewExport] --'asc','cityName', 'Where countryName like ''%%'' and stateName like ''%%'' and cityName like ''%%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Cities C
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Cities'
			LEFT JOIN AdHocAttributeValues AV ON C.CityId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    

	IF @Condition is null

	    IF @ColumnName IS NULL
			BEGIN
				   SELECT @SQLStatement = 'SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes],States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted 
				   FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId 
									inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType
			END
		ELSE
			BEGIN
			       SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes],States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId 
							                        inner join Countries on Countries.CountryId=States.CountryId 
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Cities''
													LEFT JOIN AdHocAttributeValues AV ON Cities.CityId = AV.TablePKId AND AV.AttributeId = A.AttributeId
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType

			END

		
	ELSE
	Begin

	         IF @ColumnName IS NULL
				 BEGIN
				       SELECT @SQLStatement = 'SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes], States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted 
												FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner 
												join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
				 END
			 ELSE
				 BEGIN
				      SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [CityName], [AreaCode], [CityCode], [County], [Cities].[InActive],[Cities].[Notes], States.StateName, Countries.CountryName,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId
													inner join Countries on Countries.CountryId=States.CountryId 
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Cities''
													LEFT JOIN AdHocAttributeValues AV ON Cities.CityId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
				 END
		
    
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId  ' +@Condition
	End
	
	PRINT @SQLStatement
	EXEC(@SQLStatement)
	EXEC(@CountStatement)

	COMMIT
