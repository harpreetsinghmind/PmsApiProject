CREATE PROC [dbo].[usp_AdHocAttributeValuesImport] 
    @AttributeId bigint,
    @TablePKId bigint = NULL,
    @FieldValue nvarchar(MAX) = NULL,
    @InActive bit,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	IF NOT EXISTS(SELECT AttributeValueId FROM [AdHocAttributeValues] WHERE AttributeId = @AttributeId AND TablePKId = @TablePKId)
		BEGIN

				INSERT INTO [dbo].[AdHocAttributeValues] ([AttributeId], [TablePKId], [FieldValue], [InActive], [CreatedBy], [CreatedDate])
				SELECT @AttributeId, @TablePKId, @FieldValue, @InActive, @CreatedBy, @CreatedDate
	
				SELECT SCOPE_IDENTITY()

		END
	ELSE
		BEGIN
			   UPDATE [AdHocAttributeValues] SET  [FieldValue] = @FieldValue, UpdatedBy =  @CreatedBy, UpdatedDate = @CreatedDate WHERE AttributeId = @AttributeId AND TablePKId = @TablePKId   
		END
	
COMMIT
