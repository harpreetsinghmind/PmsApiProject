USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTimesheet]    Script Date: 4/15/2019 8:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_GetTimesheet] 
	 @EmployeeId BIGINT,
     @SDate DATETIME,
     @EDate DATETIME
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 *		 
	FROM 
		[dbo].[Timesheet]
	WHERE 
		EmployeeId = @EmployeeId
		AND
		DDay1 = @SDate
		AND
		DDay7 = @EDate

	SELECT 
		 TD.*		 
	FROM 
		[dbo].[TimesheetDetail] TD
		INNER JOIN [dbo].[Timesheet] T ON T.Id = TD.TimesheetId
	WHERE 
		T.EmployeeId = @EmployeeId
		AND
		T.DDay1 = @SDate
		AND
		T.DDay7 = @EDate
	
	COMMIT