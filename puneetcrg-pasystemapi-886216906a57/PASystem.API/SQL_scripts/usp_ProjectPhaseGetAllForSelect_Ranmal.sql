USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectPhaseGetAllForSelect]    Script Date: 4/15/2019 3:44:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectPhaseGetAllForSelect] 
	@ProjectId BIGINT
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		Id,
		Name
	FROM   [dbo].[ProjectPhase] where ProjectId = @ProjectId
	
	COMMIT
