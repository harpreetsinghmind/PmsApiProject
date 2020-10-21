USE [PASystem]
GO

/****** Object:  Trigger [dbo].[ProjectSubPhase_INSERT]    Script Date: 4/3/2019 3:45:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TRIGGER [dbo].[ProjectSubPhase_INSERT]
       ON [dbo].[ProjectSubPhase]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='CREATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL

 
       SELECT 
		@entityId = ProjectPhase.ProjectId, 
		@updatedBy = INSERTED.UpdatedBy,
		@detail = 'Project Phase Name=' + INSERTED.Name + ', ' + 'Project Phase Start Date=' +  CAST(ISNULL(INSERTED.StartDate,'') AS NVARCHAR(250)) + ', ' + 'Project Phase End Date=' + CAST(ISNULL(INSERTED.EndDate,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Target Cost=' + CAST(ISNULL(INSERTED.TargetCost,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Vendor Target=' + CAST(ISNULL(INSERTED.VendorTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Labor Target=' +  CAST(ISNULL(INSERTED.LaborTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Billing Type=' + CAST(ISNULL(INSERTED.BillingType,'') AS NVARCHAR(250))
       FROM INSERTED
		INNER JOIN ProjectPhase ON ProjectPhase.Id = INSERTED.PhaseId 
		
		
       EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy
END
GO

ALTER TABLE [dbo].[ProjectPhase] ENABLE TRIGGER [ProjectPhase_INSERT]
GO


