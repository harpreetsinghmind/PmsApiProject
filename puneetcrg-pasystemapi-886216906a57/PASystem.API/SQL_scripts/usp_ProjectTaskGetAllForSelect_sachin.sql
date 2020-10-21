USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectTaskGetAllForSelect]    Script Date: 20-12-2019 11:35:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectTaskGetAllForSelect] 
	@SubPhaseId BIGINT, @SDate DATETIME, @EDate DATETIME
AS 
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	SELECT
		T.Id,
		T.Name AS Text,
		ISNULL (T.StartDate, Null) AS StartDate,
		ISNULL (T.ActualDate, ISNULL(SPH.ActualDate, ISNULL(PH.ActualDate, P.ActualDate))) AS ActualDate,
		T.BillingType
	FROM 
		[dbo].[ProjectTask] T
		INNER JOIN ProjectSubPhase SPH ON SPH.Id = T.SubPhaseId
		INNER JOIN ProjectPhase PH on PH.Id = SPH.PhaseId
		INNER JOIN Projects P on P.ProjectId = PH.ProjectId
	WHERE 
		SubPhaseId = @SubPhaseId
END
GO


