USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectTypesGetAllForSelect]    Script Date: 3/20/2019 2:52:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectTypesGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 ProjectTypeId
		,Name
		,InActive
	FROM   [dbo].[ProjectTypes] where InActive=0
	
	COMMIT
GO


