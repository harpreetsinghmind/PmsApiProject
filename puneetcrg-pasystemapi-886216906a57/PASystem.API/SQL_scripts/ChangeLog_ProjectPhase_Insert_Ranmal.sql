USE [PASystem]
GO

/****** Object:  Trigger [dbo].[Projects_INSERT]    Script Date: 4/3/2019 3:26:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ProjectPhase_INSERT]
       ON [dbo].[ProjectPhase]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='CREATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL

 
       SELECT 
		@entityId = INSERTED.ProjectId, 
		@updatedBy = INSERTED.UpdatedBy,
		@detail = 'Project Phase Name=' + Name + ', ' + 'Project Phase Start Date=' +  CAST(ISNULL(StartDate,'') AS NVARCHAR(250)) + ', ' + 'Project Phase End Date=' + CAST(ISNULL(EndDate,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Revenue=' + CAST(ISNULL(Revenue,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Budget=' + CAST(ISNULL(Budget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Target Cost=' + CAST(ISNULL(TargetCost,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Vendor Target=' + CAST(ISNULL(VendorTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Labor Target=' +  CAST(ISNULL(LaborTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Billing Type=' + CAST(ISNULL(BillingType,'') AS NVARCHAR(250))
       FROM INSERTED 
		
		
       EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy
END
GO

ALTER TABLE [dbo].[Projects] ENABLE TRIGGER [Projects_INSERT]
GO


