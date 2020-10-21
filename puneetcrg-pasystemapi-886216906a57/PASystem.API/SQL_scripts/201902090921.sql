ALTER PROC [dbo].[usp_AdHocAttributesUpdate] 
    @AttributeId bigint,
    @TableName nvarchar(200),
    @DataType nvarchar(100) = NULL,
    @InActive bit,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
    @ControlType nvarchar(300) = NULL,
    @MinLength int = NULL,
    @MaxLength int = NULL,
    @IsRequired bit = NULL,
    @AttributeOrder int = NULL,
	@AttributeLabel nvarchar(MAX)=NULL,
	@Options NVARCHAR(MAX)=NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	UPDATE [dbo].[AdHocAttributes]
	SET    [TableName] = @TableName, [DataType] = @DataType, [InActive] = @InActive, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate, [ControlType] = @ControlType, [MinLength] = @MinLength, [MaxLength] = @MaxLength, [IsRequired] = @IsRequired, [AttributeOrder] = @AttributeOrder,[AttributeLabel]=@AttributeLabel,[Attribute1] = @Options
	WHERE  [AttributeId] = @AttributeId
	
	-- Begin Return Select <- do not remove
	SELECT [AttributeId], [TableName], [DataType], [InActive], [UpdatedBy], [UpdatedDate], [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder],[AttributeLabel],[Attribute1] AS Options
	FROM   [dbo].[AdHocAttributes]
	WHERE  [AttributeId] = @AttributeId	
	-- End Return Select <- do not remove
	COMMIT