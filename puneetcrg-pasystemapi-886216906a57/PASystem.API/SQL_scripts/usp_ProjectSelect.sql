USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectSelect]    Script Date: 3/20/2019 2:49:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ProjectSelect] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT *
	FROM   [dbo].[Projects] 
	WHERE  [ProjectId] = @ProjectId AND  InActive =0

	COMMIT
GO


