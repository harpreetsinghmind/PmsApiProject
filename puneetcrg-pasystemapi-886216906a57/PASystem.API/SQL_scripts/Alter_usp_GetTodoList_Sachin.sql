USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTodoList]    Script Date: 8/6/2019 8:35:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetTodoList] 
   @UserId bigint 
AS 
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	SELECT T.TaskId, T.Task, T.DueDate, T.Status,
		CASE 
			WHEN T.DueDate > CAST(CAST(GETDATE() AS DATE) AS DATETIME) THEN 1 
			WHEN T.DueDate = CAST(CAST(GETDATE() AS DATE) AS DATETIME) THEN 0 
			ELSE -1 
		END AS DueStatus
	FROM TaskList T
		JOIN Employees E ON T.UserId = E.UserId
	WHERE E.UserId = @UserId
	ORDER BY T.DueDate
END
