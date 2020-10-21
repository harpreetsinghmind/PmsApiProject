USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectSubPhaseDelete]    Script Date: 4/3/2019 4:09:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectSubPhaseDelete] 
    @SubPhaseId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE 
	FROM [dbo].[ProjectSubPhase]
	WHERE Id = @SubPhaseId

	COMMIT
GO


