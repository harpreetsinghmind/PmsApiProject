ALTER PROC [dbo].[usp_AdHocAttributeValuesGetAll] 
    @PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	DECLARE @SQLStatement varchar(MAX)
    DECLARE @CountStatement varchar(MAX)
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT [AttributeValueId], AdHocAttributeValues.[AttributeId], [TablePKId], [FieldValue], AdHocAttributeValues.[InActive], AdHocAttributeValues.[CreatedBy], AdHocAttributeValues.[CreatedDate], AdHocAttributeValues.[UpdatedBy], AdHocAttributeValues.[UpdatedDate] ,[TableName], [DataType], [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder] ,[AttributeLabel]
	FROM   [dbo].[AdHocAttributeValues]
	inner join [dbo].[AdHocAttributes] on AdHocAttributes.AttributeId=AdHocAttributeValues.AttributeId order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT [AttributeValueId], AdHocAttributeValues.[AttributeId], [TablePKId], [FieldValue], AdHocAttributeValues.[InActive], AdHocAttributeValues.[CreatedBy], AdHocAttributeValues.[CreatedDate], AdHocAttributeValues.[UpdatedBy], AdHocAttributeValues.[UpdatedDate] ,[TableName], [DataType], [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder] ,[AttributeLabel]
	FROM   [dbo].[AdHocAttributeValues]
	inner join [dbo].[AdHocAttributes] on AdHocAttributes.AttributeId=AdHocAttributeValues.AttributeId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM   [dbo].[AdHocAttributeValues] inner join [dbo].[AdHocAttributes] on AdHocAttributes.AttributeId=AdHocAttributeValues.AttributeId ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)
COMMIT
	
	
