USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_TimesheetDelete]    Script Date: 4/15/2019 5:46:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_TimesheetDelete] 
    @TimesheetId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		DELETE
		FROM [dbo].[Timesheet]
		WHERE Id = @TimesheetId

	COMMIT
