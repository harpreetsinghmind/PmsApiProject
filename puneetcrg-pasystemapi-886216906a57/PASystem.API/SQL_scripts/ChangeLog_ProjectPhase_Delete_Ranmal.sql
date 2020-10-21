CREATE TRIGGER [dbo].[ProjectPhase_DELETE]
       ON [dbo].[ProjectPhase]
AFTER DELETE
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='DELETED',
			@detail NVARCHAR(MAX),
			@phaseName NVARCHAR(255),
			@updatedBy NVARCHAR(250)

 
       SELECT 
			@entityId = DELETED.ProjectId, @updatedBy = DELETED.UpdatedBy , @phaseName = DELETED.Name
		FROM DELETED
		
		SET @detail ='Project Phase '+ @phaseName +' Deleted'
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy
	   
END