ALTER PROC [dbo].[usp_ZipcodesGetAll_NewExport] 
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Zipcodes Z
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Zipcodes'
			LEFT JOIN AdHocAttributeValues AV ON Z.ZipcodeId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels


	IF @Condition is null

	      IF @ColumnName IS NULL
		  BEGIN
		       SELECT @SQLStatement = 'SELECT [Zipcode],CityName,StateName,CountryName,[Zipcodes].[InActive], [Zipcodes].[Notes],''FALSE'' AS IsDeleted 
										FROM [dbo].[Zipcodes] inner join Cities on Cities.CityId=Zipcodes.CityId 
										inner join States on States.StateId=Cities.StateId 
									    inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType
		  END
		  ELSE
		  BEGIN
		      SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [Zipcode],CityName,StateName,CountryName,[Zipcodes].[InActive], [Zipcodes].[Notes],''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue 
										FROM [dbo].[Zipcodes] inner join Cities on Cities.CityId=Zipcodes.CityId 
										inner join States on States.StateId=Cities.StateId 
									    inner join Countries on Countries.CountryId=States.CountryId
										LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Zipcodes''
										LEFT JOIN AdHocAttributeValues AV ON Zipcodes.ZipcodeId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
		        SELECT @SQLStatement = 'SELECT [Zipcode],CityName,StateName,CountryName,[Zipcodes].[InActive], [Zipcodes].[Notes],''FALSE'' AS IsDeleted 
				FROM [dbo].[Zipcodes] inner join Cities on Cities.CityId=Zipcodes.CityId 
									  inner join States on States.StateId=Cities.StateId 
									  inner join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
		   END
		   ELSE
		   BEGIN

		         SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [Zipcode],CityName,StateName,CountryName,[Zipcodes].[InActive], [Zipcodes].[Notes],''FALSE'' AS IsDeleted, AttributeLabel, FieldValue 
							FROM [dbo].[Zipcodes] inner join Cities on Cities.CityId=Zipcodes.CityId 
									  inner join States on States.StateId=Cities.StateId 
									  inner join Countries on Countries.CountryId=States.CountryId
									  LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Zipcodes''
									  LEFT JOIN AdHocAttributeValues AV ON Zipcodes.ZipcodeId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType

		   END

				
				
				-- Execute the SQL statement
				Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Zipcodes] inner join Cities on Cities.CityId=Zipcodes.CityId inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId ' +@Condition
		End

	EXEC(@SQLStatement)
	EXEC(@CountStatement)

	COMMIT
