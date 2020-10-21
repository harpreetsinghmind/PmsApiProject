
ALTER PROC [dbo].[usp_GetProjectPhases] 
    @ProjectId BIGINT
AS 
	SET NOCOUNT ON 
 
	BEGIN TRAN
	
	SELECT 
		Id AS PhaseId,
		Name AS PhaseName,
		ProjectId,
		EstimatedStartDate AS ESDate,
		StartDate AS SDate,
		EndDate AS EDate,
		ActualDate AS ADate,
		Revenue,
		Budget,
		TargetCost AS CostTarget,
		VendorTarget,
		(TargetCost - VendorTarget) AS LaborTarget,
		BillingType,
		Locked
	FROM 
		ProjectPhase 
	WHERE 
		ProjectId = @ProjectId
	
	SELECT 
		ProjectSubPhase.Id AS SubPhaseId,
		ProjectSubPhase.Name AS PhaseName,
		ProjectSubPhase.PhaseId,
		ProjectSubPhase.EstimatedStartDate AS ESDate,
		ProjectSubPhase.StartDate AS SDate,
		ProjectSubPhase.EndDate AS EDate,
		ProjectSubPhase.ActualDate AS ADate,
		ProjectSubPhase.TargetCost AS CostTarget,
		ProjectSubPhase.VendorTarget,
		(ProjectSubPhase.TargetCost - ProjectSubPhase.VendorTarget) AS LaborTarget,
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


