/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseDelete]    Script Date: 22-12-2019 10:46:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectPhaseDelete] 
    @PhaseId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	IF EXISTS (SELECT PST.* FROM ProjectSubTask PST JOIN ProjectTask PT ON PT.Id = PST.TaskId JOIN ProjectSubPhase PSP ON PSP.Id = PT.SubPhaseId AND PSP.PhaseId = @PhaseId)
	BEGIN
		DELETE PST FROM ProjectSubTask PST 
			JOIN ProjectTask PT ON PT.Id = PST.TaskId 
			JOIN ProjectSubPhase PSP ON PSP.Id = PT.SubPhaseId
				AND PSP.PhaseId = @PhaseId
	END
	
	IF EXISTS (SELECT PT.* FROM ProjectTask PT JOIN ProjectSubPhase PSP ON PSP.Id = PT.SubPhaseId AND PSP.PhaseId = @PhaseId)
	BEGIN
		DELETE PT FROM ProjectTask PT 
			JOIN ProjectSubPhase PSP ON PSP.Id = PT.SubPhaseId 
				AND PSP.PhaseId = @PhaseId
	END

	IF EXISTS(SELECT * FROM [dbo].[ProjectSubPhase]	WHERE PhaseId = @PhaseId)
	BEGIN
		DELETE 
		FROM [dbo].[ProjectSubPhase]
		WHERE PhaseId = @PhaseId
	END

	IF EXISTS(SELECT * FROM [dbo].[PhaseContract]	WHERE PhaseId = @PhaseId)
	BEGIN
		DELETE 
		FROM [dbo].[PhaseContract]
		WHERE PhaseId = @PhaseId
	END

	DELETE
	FROM [dbo].[ProjectPhase]
	WHERE  Id = @PhaseId

	COMMIT
