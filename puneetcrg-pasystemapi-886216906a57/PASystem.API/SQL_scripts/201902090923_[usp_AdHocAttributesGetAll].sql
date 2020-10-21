ALTER PROC [dbo].[usp_AdHocAttributesGetAll] 
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
SELECT @SQLStatement = 'SELECT [AttributeId], [TableName], [DataType], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder] ,[AttributeLabel], [Attribute1] As Options
	FROM   [dbo].[AdHocAttributes] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT [AttributeId], [TableName], [DataType], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder] ,[AttributeLabel], [Attribute1] As Options
	FROM   [dbo].[AdHocAttributes] '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM   [dbo].[AdHocAttributes] ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)
	COMMIT
	
