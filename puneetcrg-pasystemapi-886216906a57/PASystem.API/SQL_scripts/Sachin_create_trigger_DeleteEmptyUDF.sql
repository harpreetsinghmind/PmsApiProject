USE [PASystem]
GO

/****** Object:  Trigger [dbo].[DELETEEMPTYUDF]    Script Date: 26-11-2019 11:08:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[DELETEEMPTYUDF]
   ON  [dbo].[AdHocAttributeValues] 
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	DELETE FROM AdHocAttributeValues
	WHERE AttributeValueId IN (SELECT AttributeValueId FROM inserted WHERE LEN(TRIM(FieldValue)) = 0)

END
GO

ALTER TABLE [dbo].[AdHocAttributeValues] ENABLE TRIGGER [DELETEEMPTYUDF]
GO

