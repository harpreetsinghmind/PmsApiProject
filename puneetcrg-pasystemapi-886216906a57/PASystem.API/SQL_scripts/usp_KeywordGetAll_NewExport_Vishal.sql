ALTER PROC [dbo].[usp_KeywordGetAll_NewExport] --'asc','keyword','Where keyword like ''%welcome%'' and value like N''%%'''
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement nvarchar(MAX)
	DECLARE @CountStatement nvarchar(MAX)

	DECLARE @ColumnName AS nvarchar(MAX)
	SELECT @ColumnName =  ISNULL(@ColumnName +',','') + QUOTENAME(AttributeLabel)
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].LanguageMaster L
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Keyword Master'
			LEFT JOIN AdHocAttributeValues AV ON L.Id = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
		-- Enter the dynamic SQL statement into the
		-- variable @SQLStatement
		IF @Condition is null

		         IF @ColumnName IS NULL
				 BEGIN
				      SELECT @SQLStatement = 'SELECT m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId order by ' + @FieldName+ ' '+ @SortType
				 END
				 ELSE
				 BEGIN
				       SELECT @SQLStatement =  'SELECT * from
						(
							SELECT m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId  
							                      				LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Keyword Master''
																LEFT JOIN AdHocAttributeValues AV ON m.Id = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
							SELECT @SQLStatement = 'SELECT m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted 
							FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
					END
				ELSE
					BEGIN
					        SELECT @SQLStatement =  'SELECT * from
						(
							SELECT  m.Keyword, m.Value,l.DisplayName,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[LanguageMaster] AS m inner join [dbo].[Languages] AS l ON m.LanguageId = l.LanguageId
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Keyword Master''
													LEFT JOIN AdHocAttributeValues AV ON m.Id = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
					END
				-- Execute the SQL statement
				Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[LanguageMaster] ' +@Condition
		End

print @SQLStatement

EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
