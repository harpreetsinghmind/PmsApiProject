USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTodoList]    Script Date: 7/25/2019 1:33:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetTodoList] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		*
	FROM  
		TaskList

	COMMIT
