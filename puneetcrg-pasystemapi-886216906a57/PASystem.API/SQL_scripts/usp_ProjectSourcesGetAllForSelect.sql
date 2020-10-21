USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectSourcesGetAllForSelect]    Script Date: 3/20/2019 2:51:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectSourcesGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 ProjectSourceId
		,Name
		,InActive
	FROM   [dbo].[ProjectSources] where InActive=0
	
	COMMIT
GO


