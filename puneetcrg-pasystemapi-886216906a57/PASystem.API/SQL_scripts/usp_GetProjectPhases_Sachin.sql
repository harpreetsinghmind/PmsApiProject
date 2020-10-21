/****** Object:  StoredProcedure [dbo].[usp_GetProjectPhases]    Script Date: 17-12-2019 10:44:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[usp_GetProjectPhases]    Script Date: 16-11-2018 18:54:27 ******/
CREATE PROC [dbo].[usp_GetProjectPhases] 
    @ProjectId BIGINT
AS 
	SET NOCOUNT ON 
 
	SELECT Id AS PhaseId, Name AS PhaseName, ProjectId, EstimatedStartDate AS ESDate, StartDate AS SDate, EndDate AS EDate, ActualDate AS ADate, Revenue, Budget, TargetCost AS CostTarget,
		VendorTarget, LaborTarget, BillingType, Locked
	FROM ProjectPhase 
	WHERE ProjectId = @ProjectId
	
	SELECT ProjectSubPhase.Id AS SubPhaseId, ProjectSubPhase.Name AS PhaseName, ProjectSubPhase.PhaseId, ProjectSubPhase.EstimatedStartDate AS ESDate, ProjectSubPhase.StartDate AS SDate,
			ProjectSubPhase.EndDate AS EDate, ProjectSubPhase.ActualDate AS ADate, ProjectSubPhase.TargetCost AS CostTarget, ProjectSubPhase.VendorTarget, ProjectSubPhase.LaborTarget,
			ProjectSubPhase.BillingType
	 FROM ProjectSubPhase INNER JOIN ProjectPhase ON ProjectSubPhase.PhaseId = ProjectPhase.Id 
	 WHERE ProjectPhase.ProjectId= @ProjectId

	SELECT PhaseContract.Id AS ContractId, PhaseContract.Name, PhaseContract.Path, PhaseContract.PhaseId
	 FROM PhaseContract INNER JOIN ProjectPhase ON PhaseContract.PhaseId = ProjectPhase.Id 
	 WHERE ProjectPhase.ProjectId= @ProjectId

	SELECT PT.Id AS TaskId, PT.Name AS PhaseName, PT.SubPhaseId, PT.EstimatedStartDate AS ESDate, PT.StartDate AS SDate, PT.EndDate AS EDate, PT.ActualDate AS ADate, PT.TargetCost AS CostTarget,
		PT.VendorTarget, PT.LaborTarget, PT.BillingType, PT.CreatedBy
	FROM ProjectTask PT 
		JOIN ProjectSubPhase SP ON PT.SubPhaseId = SP.Id
		JOIN ProjectPhase P ON SP.PhaseId = P.Id
	WHERE P.ProjectId = @ProjectId

	SELECT ST.Id AS SubTaskId, ST.Name AS PhaseName, ST.TaskId, ST.EstimatedStartDate AS ESDate, ST.StartDate AS SDate, ST.EndDate AS EDate, ST.ActualDate AS ADate, ST.TargetCost AS CostTarget,
		ST.VendorTarget, ST.LaborTarget, ST.BillingType, ST.CreatedBy
	FROM ProjectSubTask ST
		JOIN ProjectTask PT ON ST.TaskId = PT.Id
		JOIN ProjectSubPhase SP ON PT.SubPhaseId = SP.Id
		JOIN ProjectPhase P ON SP.PhaseId = P.Id
	WHERE P.ProjectId = @ProjectId

GO

