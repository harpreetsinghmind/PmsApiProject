/****** Object:  StoredProcedure [dbo].[usp_ProjectTaskDelete]    Script Date: 22-12-2019 10:51:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_ProjectTaskDelete] 
    @TaskId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	IF EXISTS (SELECT * FROM ProjectSubTask WHERE TaskId = @TaskId)
	BEGIN
		DELETE FROM ProjectSubTask WHERE TaskId = @TaskId
	END

	DELETE FROM [dbo].[ProjectTask]
	WHERE Id = @TaskId

	COMMIT
