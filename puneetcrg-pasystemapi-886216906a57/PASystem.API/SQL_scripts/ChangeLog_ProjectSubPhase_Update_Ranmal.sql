USE [PASystem]
GO

/****** Object:  Trigger [dbo].[ProjectSubPhase_UPDATE]    Script Date: 4/3/2019 3:36:37 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ProjectSubPhase_UPDATE]
       ON [dbo].[ProjectSubPhase]
AFTER UPDATE
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='UPDATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL
			
 
       SELECT 
		@entityId = ProjectPhase.ProjectId, @updatedBy = INSERTED.UpdatedBy 
		FROM INSERTED
			INNER JOIN ProjectPhase ON ProjectPhase.Id = INSERTED.PhaseId
		
		IF UPDATE(Name)
		BEGIN
			 SELECT @detail = 'Updated Project Phase Name=' + Name	FROM INSERTED
		END	
		DECLARE @sdate NVARCHAR(255)	
		IF UPDATE(StartDate)
		BEGIN
			 SELECT @sdate = 'Updated Project Phase Start Date=' +  CAST(ISNULL(StartDate,'') AS NVARCHAR(250))	FROM INSERTED
		END	
		
		DECLARE @edate NVARCHAR(255)	
		IF UPDATE(EndDate)
		BEGIN
			SELECT @edate = 'Updated Project Phase End Date=' + CAST(ISNULL(EndDate,'') AS NVARCHAR(250))	FROM INSERTED
		END	
		DECLARE @targetcost NVARCHAR(255)		
		IF UPDATE(TargetCost)
		BEGIN
			SELECT @targetcost = 'Updated Project Phase Target Cost=' + CAST(ISNULL(TargetCost,'') AS NVARCHAR(250))	FROM INSERTED 
		END	
		DECLARE @vendortarget NVARCHAR(255)		
		IF UPDATE(VendorTarget)
		BEGIN
			SELECT @vendortarget = 'Updated Project Phase Vendor Target=' + CAST(ISNULL(VendorTarget,'') AS NVARCHAR(250))	FROM INSERTED 
		END	
		DECLARE @labortarget NVARCHAR(255)		
		IF UPDATE(LaborTarget)
		BEGIN
			SELECT @labortarget = 'Updated Project Phase Labor Target=' +  CAST(ISNULL(LaborTarget,'') AS NVARCHAR(250)) FROM INSERTED 
		END	
		DECLARE @billingtype NVARCHAR(255)		
		IF UPDATE(BillingType)
		BEGIN
			SELECT @billingtype = 'Updated Project Phase Billing Type=' + CAST(ISNULL(BillingType,'') AS NVARCHAR(250))	FROM INSERTED 
		END	

	   DECLARE @msg AS NVARCHAR(MAX) =  @detail + ', '+ @sdate + ', ' + @edate +', '+  @targetcost + ', ' + @vendortarget+ ', '+ @labortarget + ', ' + @billingtype; 
	   print @msg
	   IF @msg IS NOT NULL
	   BEGIN
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @msg, @updatedBy
	   END
END
GO

ALTER TABLE [dbo].[ProjectPhase] ENABLE TRIGGER [ProjectPhase_UPDATE]
GO


