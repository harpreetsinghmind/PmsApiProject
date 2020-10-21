USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetPhasesStatus]    Script Date: 8/6/2019 8:34:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetPhasesStatus] 
	@ProjectId bigint
AS
BEGIN

	SET NOCOUNT ON;

	SELECT 
		Id AS PhaseId, Name AS PhaseName, ProjectId, EstimatedStartDate AS ESDate, StartDate AS SDate,
		EndDate AS EDate, ActualDate AS ADate, CAST(CAST(GETDATE() AS DATE) AS DATETIME) AS Today,
		CASE
			WHEN (ActualDate IS NULL) AND (StartDate IS NOT NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) > EndDate)
				THEN 'In Progress,Danger'
			WHEN (StartDate IS NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) > EstimatedStartDate)
				THEN 'Not Started,Danger'
			WHEN (StartDate IS NOT NULL) AND (StartDate > EstimatedStartDate)
				THEN 'Late Start,Danger'
			WHEN (ActualDate IS NOT NULL AND ActualDate > EndDate)
				THEN 'Completed Late,Danger'
			WHEN (StartDate IS NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) = EstimatedStartDate)
				THEN 'Starts Today,Warning'
			WHEN (ActualDate IS NULL) AND (StartDate IS NOT NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) = EndDate)
				THEN 'Ends Today,Warning'
			WHEN (ActualDate IS NULL) AND (StartDate IS NOT NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) < EndDate)
				THEN 'In Progress,Success'
			WHEN (StartDate IS NULL) AND (CAST(CAST(GETDATE() AS DATE) AS DATETIME) < EstimatedStartDate)
				THEN 'Not Started,Gray'
			ELSE 'Completed,Success'
		END AS PhaseStatus
	FROM 
		ProjectPhase 
	WHERE 
		ProjectId = @ProjectId
	ORDER BY Id;
END
GO
