/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetProjectPhases]    Script Date: 5/20/2019 3:03:05 PM ******/
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
		EstimatedStartDate AS ESDate,
		StartDate AS SDate,
		EndDate AS EDate,
		ActualDate AS ADate,
		Revenue,
		Budget,
		TargetCost AS CostTarget,
		VendorTarget,
		LaborTarget,
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
GO

