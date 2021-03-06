USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectSubPhaseGetAllForSelect]    Script Date: 7/4/2019 2:28:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectSubPhaseGetAllForSelect] 
	@PhaseId BIGINT,
	@SDate DATETIME,
	@EDate DATETIME
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		phs.Id,
		phs.Name AS Text,
		ISNULL (phs.StartDate, Null) AS StartDate,
		ISNULL (phs.ActualDate, ISNULL(ph.ActualDate, p.ActualDate)) AS ActualDate,
		phs.BillingType
	FROM 
		[dbo].[ProjectSubPhase] phs 
		INNER JOIN ProjectPhase ph on ph.Id = phs.PhaseId
		INNER JOIN Projects p on p.ProjectId = ph.ProjectId
	WHERE 
		PhaseId = @PhaseId
	
	COMMIT
