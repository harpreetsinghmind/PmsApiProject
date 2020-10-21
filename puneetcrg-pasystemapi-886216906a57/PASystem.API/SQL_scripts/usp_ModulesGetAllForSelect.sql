USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ModulesGetAllForSelect]    Script Date: 3/20/2019 2:52:40 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ModulesGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [ModuleId],[Name], [InActive]
	FROM   [dbo].[Modules] where InActive=0


	COMMIT
GO


