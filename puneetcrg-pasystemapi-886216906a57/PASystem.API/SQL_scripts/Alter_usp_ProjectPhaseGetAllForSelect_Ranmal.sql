USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseGetAllForSelect]    Script Date: 5/8/2019 8:47:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectPhaseGetAllForSelect] 
	@ProjectId BIGINT,
	@SDate DATETIME,
	@EDate DATETIME
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		Id,
		Name AS Text,
		StartDate,
		ActualDate,
		NULL AS BillingType,
		ISNULL(Locked,0) AS Locked
	FROM
		[dbo].[ProjectPhase] 
	WHERE 
		ProjectId = @ProjectId 
		
	
	COMMIT
