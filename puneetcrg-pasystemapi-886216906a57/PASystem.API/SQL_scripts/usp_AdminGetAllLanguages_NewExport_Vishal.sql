ALTER PROC [dbo].[usp_AdminGetAllLanguages_NewExport] --'asc', 'DisplayName', 'where'
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].Languages L
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Language Master'
			LEFT JOIN AdHocAttributeValues AV ON L.LanguageId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
	-- Enter the dynamic SQL statement into the
	-- variable @SQLStatement
	IF @Condition is null
			
			IF @ColumnName IS NULL
				BEGIN
						SELECT @SQLStatement = 'SELECT Name,DisplayName,Isdefault,InActive,''FALSE'' AS IsDeleted FROM  [dbo].[Languages] order by ' + @FieldName+ ' '+ @SortType
				END
			ELSE
				BEGIN
				          SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Name,DisplayName,Isdefault,[Languages].InActive,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
							FROM  [dbo].[Languages] 
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Language Master''
													LEFT JOIN AdHocAttributeValues AV ON Languages.LanguageId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
			       SELECT @SQLStatement = 'SELECT Name,DisplayName,Isdefault,InActive,''FALSE'' AS IsDeleted FROM  [dbo].[Languages] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
			  END
			  ELSE
			  BEGIN
			       SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Name,DisplayName,Isdefault,[Languages].InActive,''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[Languages]
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Language Master''
													LEFT JOIN AdHocAttributeValues AV ON Languages.LanguageId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
			  END
			
			-- Execute the SQL statement
			SELECT @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Languages] ' +@Condition
		End
		PRINT @SQLStatement
	EXEC(@SQLStatement)
	EXEC(@CountStatement)

COMMIT