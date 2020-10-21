USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectArchive]    Script Date: 3/20/2019 2:50:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectArchive] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	UPDATE
	[dbo].[Projects]
	SET Status =3
	WHERE  [ProjectId] = @ProjectId

	COMMIT
GO


