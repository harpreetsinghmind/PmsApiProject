ALTER PROC [dbo].[usp_OrgStructureGetAll_NewExport] --'asc','orgSOrder','Where name like ''%%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].OrgStructure O
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Levels'
			LEFT JOIN AdHocAttributeValues AV ON O.OrgStructureId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels
    
	-- Enter the dynamic SQL statement into the
	-- variable @SQLStatement
	IF @Condition is null
	     IF @ColumnName IS NULL
		 BEGIN
              SELECT @SQLStatement = 'SELECT [Name], [Description], [InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted FROM   [dbo].[OrgStructure] order by ' + @FieldName+ ' '+ @SortType
		 END
		 ELSE
		 BEGIN
		      SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [Name], [Description], O.[InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].OrgStructure O
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Levels''
													LEFT JOIN AdHocAttributeValues AV ON O.OrgStructureId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
              SELECT @SQLStatement = 'SELECT [Name], [Description], [InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted FROM   [dbo].[OrgStructure] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
		 END
		 ELSE
		 BEGIN
		       SELECT @SQLStatement =  'SELECT * from
						(
							SELECT [Name], [Description], O.[InActive], OrgSOrder, Notes, ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
								FROM [dbo].[OrgStructure] O
											LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Levels''
											LEFT JOIN AdHocAttributeValues AV ON O.OrgStructureId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
		 END

		
		-- Execute the SQL statement
		Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[OrgStructure] ' +@Condition
	End
	EXEC(@SQLStatement)
	EXEC(@CountStatement)

	COMMIT	
