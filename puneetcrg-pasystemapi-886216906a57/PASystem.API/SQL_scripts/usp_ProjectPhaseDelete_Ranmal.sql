USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseDelete]    Script Date: 4/4/2019 8:40:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectPhaseDelete] 
    @PhaseId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

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
