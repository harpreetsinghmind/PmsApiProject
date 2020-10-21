USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectSubTaskGetAllForSelect]    Script Date: 20-12-2019 11:35:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectSubTaskGetAllForSelect] 
	@TaskId BIGINT, @SDate DATETIME, @EDate DATETIME
AS 
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	SELECT
		ST.Id,
		ST.Name AS Text,
		ISNULL (ST.StartDate, Null) AS StartDate,
		ISNULL (ST.ActualDate, ISNULL(T.ActualDate, ISNULL(SPH.ActualDate, ISNULL(PH.ActualDate, P.ActualDate)))) AS ActualDate,
		ST.BillingType
	FROM
		[dbo].[ProjectSubTask] ST
		INNER JOIN ProjectTask T ON T.Id = ST.TaskId
		INNER JOIN ProjectSubPhase SPH ON SPH.Id = T.SubPhaseId
		INNER JOIN ProjectPhase PH on PH.Id = SPH.PhaseId
		INNER JOIN Projects P on P.ProjectId = PH.ProjectId
	WHERE 
		TaskId = @TaskId
END
GO


