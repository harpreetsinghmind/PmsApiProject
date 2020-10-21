USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectTemplatesGetAllForSelect]    Script Date: 3/20/2019 2:51:43 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectTemplatesGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 ProjectTemplateId
		,Name
		,InActive
	FROM   [dbo].[ProjectTemplates] where InActive=0
	
	COMMIT
GO


