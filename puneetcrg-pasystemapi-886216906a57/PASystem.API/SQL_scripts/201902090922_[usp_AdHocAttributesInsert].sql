ALTER PROC [dbo].[usp_AdHocAttributesInsert] 
    @TableName nvarchar(200),
    @DataType nvarchar(100) = NULL,
    @InActive bit,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
    @ControlType nvarchar(300) = NULL,
    @MinLength int = NULL,
    @MaxLength int = NULL,
    @IsRequired bit = NULL,
    @AttributeOrder int = NULL,
	@AttributeLabel nvarchar(MAX)=NULL,
	@Options nvarchar(MAX)=NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[AdHocAttributes] ([TableName], [DataType], [InActive], [CreatedBy], [CreatedDate],  [ControlType], [MinLength], [MaxLength], [IsRequired], [AttributeOrder],[AttributeLabel],[Attribute1])
	SELECT @TableName,  @DataType, @InActive, @CreatedBy, @CreatedDate, @ControlType, @MinLength, @MaxLength, @IsRequired, @AttributeOrder,@AttributeLabel,@Options
	
	-- Begin Return Select <- do not remove
	SELECT  SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	COMMIT
