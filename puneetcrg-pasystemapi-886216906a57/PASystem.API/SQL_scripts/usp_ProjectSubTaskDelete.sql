/****** Object:  StoredProcedure [dbo].[usp_ProjectSubTaskDelete]    Script Date: 17-12-2019 10:48:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectSubTaskDelete]
    @SubTaskId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE FROM [dbo].[ProjectSubTask]
	WHERE Id = @SubTaskId

	COMMIT
