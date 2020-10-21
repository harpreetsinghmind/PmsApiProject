USE [PASystem]
GO

/****** Object:  Trigger [dbo].[ProjectPhase_UPDATE]    Script Date: 4/6/2019 2:48:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ProjectPhase_UPDATE]
       ON [dbo].[ProjectPhase]
AFTER UPDATE
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='UPDATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL
			
 
       SELECT 
		@entityId = INSERTED.ProjectId, @updatedBy = INSERTED.UpdatedBy 
		FROM INSERTED
		
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
		DECLARE @revenue NVARCHAR(255)		
		IF UPDATE(Revenue)
		BEGIN
			SELECT @revenue = 'Updated Project Phase Revenue=' + CAST(ISNULL(Revenue,'') AS NVARCHAR(250))	FROM INSERTED 
		END	
		DECLARE @budget NVARCHAR(255)		
		IF UPDATE(Budget)
		BEGIN
			SELECT @budget = 'Updated Project Phase Budget=' + CAST(ISNULL(Budget,'') AS NVARCHAR(250))	FROM INSERTED 
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

	   DECLARE @msg AS NVARCHAR(MAX) =  @detail + ', '+ @sdate + ', ' + @edate +', '+ @budget + ', '+  @revenue +', ' + @targetcost + ', ' + @vendortarget+ ', '+ @labortarget + ', ' + @billingtype; 
	   print @msg
	   IF @msg IS NOT NULL
	   BEGIN
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @msg, @updatedBy
	   END
END
GO

ALTER TABLE [dbo].[ProjectPhase] ENABLE TRIGGER [ProjectPhase_UPDATE]
GO


