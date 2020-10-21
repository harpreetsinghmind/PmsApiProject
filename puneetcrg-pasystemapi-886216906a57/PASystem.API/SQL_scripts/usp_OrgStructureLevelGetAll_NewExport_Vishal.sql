ALTER PROC [dbo].[usp_OrgStructureLevelGetAll_NewExport] --'asc','Name','Where Ol.Name like ''%%''  and Os.Name like ''%%'''
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
	FROM (SELECT DISTINCT AttributeLabel FROM [dbo].[OrgStructureLevel] as Ol
			LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = 'Level Elements'
			LEFT JOIN AdHocAttributeValues AV ON Ol.OrgStructureLevelId = AV.TablePKId AND AV.AttributeId = A.AttributeId) As AttributeLabels    

-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
	IF @Condition is null
	       IF @ColumnName IS NULL
		   BEGIN
		        SELECT @SQLStatement = 'SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted
									FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId order by ' + @FieldName+ ' '+ @SortType
		   END
		   ELSE
		   BEGIN
		        SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
							FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId
							                      	LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Level Elements''
													LEFT JOIN AdHocAttributeValues AV ON Ol.OrgStructureLevelId = AV.TablePKId AND AV.AttributeId = A.AttributeId
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
		       SELECT @SQLStatement = 'SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted 
									FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType
		   END
		   ELSE
		   BEGIN
		       SELECT @SQLStatement =  'SELECT * from
						(
							SELECT Ol.[Name], Os.[Name] as StructureName, Ol.[Description], Ol.[InActive], Ol.[Notes], ''FALSE'' AS IsDeleted,  AttributeLabel, FieldValue
											FROM   [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId
													LEFT JOIN AdHocAttributes A ON  A.InActive = 0  AND TableName = ''Level Elements''
													LEFT JOIN AdHocAttributeValues AV ON Ol.OrgStructureLevelId = AV.TablePKId AND AV.AttributeId = A.AttributeId
							'+@Condition+' 
						) x
						pivot
						(
						  MAX(FieldValue) FOR
						  AttributeLabel IN ('+ @ColumnName +')
						) pvt order by ' + @FieldName+ ' '+ @SortType
		   END

			
	
			-- Execute the SQL statement
			Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[OrgStructureLevel] as Ol inner join OrgStructure as Os on Os.OrgStructureId=Ol.OrgStructureId ' +@Condition
	End
	--PRINT @SQLStatement
	EXEC(@SQLStatement)
	EXEC(@CountStatement)

COMMIT