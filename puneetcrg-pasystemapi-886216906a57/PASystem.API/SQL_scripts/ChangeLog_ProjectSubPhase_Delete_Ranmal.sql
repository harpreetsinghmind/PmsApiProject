USE [PASystem]
GO

/****** Object:  Trigger [dbo].[ProjectSubPhase_DELETE]    Script Date: 4/3/2019 3:34:08 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ProjectSubPhase_DELETE]
       ON [dbo].[ProjectSubPhase]
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
			@entityId = ProjectPhase.ProjectId, @updatedBy = DELETED.UpdatedBy , @phaseName = DELETED.Name
		FROM DELETED
			INNER JOIN ProjectPhase ON ProjectPhase.Id = DELETED.PhaseId
		
		SET @detail ='Project Sub Phase '+ @phaseName +' Deleted'
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy
	   
END
GO

ALTER TABLE [dbo].[ProjectPhase] ENABLE TRIGGER [ProjectPhase_DELETE]
GO


