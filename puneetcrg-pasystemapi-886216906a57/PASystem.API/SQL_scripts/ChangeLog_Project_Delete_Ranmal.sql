CREATE TRIGGER [dbo].[Projects_DELETE]
       ON [dbo].[Projects]
AFTER DELETE
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='DELETED',
			@detail NVARCHAR(MAX)='Project Deleted',
			@updatedBy NVARCHAR(250)

 
       SELECT 
			@entityId = DELETED.ProjectId, @updatedBy = DELETED.UpdatedBy 
		FROM DELETED
		
		
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy
	   
END