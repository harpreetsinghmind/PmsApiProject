CREATE PROCEDURE [dbo].[usp_AdHocAttributes_SelectByTableName]

    @TableName VARCHAR(250)
  
AS
BEGIN

           SELECT AttributeId,
		          AttributeLabel,
		          DataType,
				  ControlType,
				  Attribute1,
				  IsRequired,
				  MinLength,
				  MaxLength
		  FROM AdHocAttributes A   
		  WHERE A.InActive = 0  AND TableName = @TableName

END

select * from AdHocAttributes