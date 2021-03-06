/****** Object:  StoredProcedure [dbo].[usp_ProjectSubPhaseDelete]    Script Date: 22-12-2019 10:48:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectSubPhaseDelete] 
    @SubPhaseId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	IF EXISTS (SELECT PST.* FROM ProjectSubTask PST JOIN ProjectTask PT ON PST.TaskId = PT.Id AND PT.SubPhaseId = @SubPhaseId)
	BEGIN
		DELETE PST FROM ProjectSubTask PST 
			JOIN ProjectTask PT ON PST.TaskId = PT.Id AND PT.SubPhaseId = @SubPhaseId 
	END

	IF EXISTS (SELECT * FROM ProjectTask WHERE SubPhaseId = @SubPhaseId)
	BEGIN
		DELETE FROM ProjectTask WHERE SubPhaseId = @SubPhaseId
	END

	DELETE 
	FROM [dbo].[ProjectSubPhase]
	WHERE Id = @SubPhaseId

	COMMIT
