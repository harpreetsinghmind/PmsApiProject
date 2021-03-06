USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectPhases]    Script Date: 4/19/2019 3:15:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[usp_GetProjectPhases]    Script Date: 16-11-2018 18:54:27 ******/

ALTER PROC [dbo].[usp_GetProjectPhases] 
    @ProjectId BIGINT
AS 
	SET NOCOUNT ON 
 
	BEGIN TRAN
	
	SELECT 
		Id AS PhaseId,
		Name AS PhaseName,
		ProjectId,
		StartDate AS SDate,
		EndDate AS EDate,
		ActualDate AS ADate,
		Revenue,
		Budget,
		TargetCost AS CostTarget,
		VendorTarget,
		LaborTarget,
		BillingType
	FROM 
		ProjectPhase 
	WHERE 
		ProjectId = @ProjectId
	
	SELECT 
		ProjectSubPhase.Id AS SubPhaseId,
		ProjectSubPhase.Name AS PhaseName,
		ProjectSubPhase.PhaseId,
		ProjectSubPhase.StartDate AS SDate,
		ProjectSubPhase.EndDate AS EDate,
		ProjectSubPhase.ActualDate AS ADate,
		ProjectSubPhase.TargetCost AS CostTarget,
		ProjectSubPhase.VendorTarget,
		ProjectSubPhase.LaborTarget,
		ProjectSubPhase.BillingType
	 FROM 
		ProjectSubPhase 
		INNER JOIN ProjectPhase 
			ON ProjectSubPhase.PhaseId = ProjectPhase.Id 
	WHERE 
		ProjectPhase.ProjectId= @ProjectId

	SELECT 
		PhaseContract.Id AS ContractId,
		PhaseContract.Name,
		PhaseContract.Path,
		PhaseContract.PhaseId
	 FROM 
		PhaseContract 
		INNER JOIN ProjectPhase 
			ON PhaseContract.PhaseId = ProjectPhase.Id 
	WHERE 
		ProjectPhase.ProjectId= @ProjectId

	COMMIT
