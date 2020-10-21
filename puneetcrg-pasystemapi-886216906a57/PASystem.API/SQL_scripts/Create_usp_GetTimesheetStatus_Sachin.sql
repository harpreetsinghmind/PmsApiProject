USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetTimesheetStatus]    Script Date: 8/6/2019 8:37:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_GetTimesheetStatus]
	@UserId bigint, @StartDate VARCHAR(10), @EndDate VARCHAR(10)
AS
BEGIN
	SET NOCOUNT ON;

    SELECT T.Id, T.DDay1, T.DDay7, P.Name AS ProjectName, PP.Name AS PhaseName, PS.Name AS SubPhaseName,
		T.DAY1 + T.DAY2 + T.DAY3 + T.DAY4 + T.DAY5 + T.DAY6 + T.DAY7 AS TotalHrs,
		CASE WHEN TA.APPROVED IS NULL THEN 'Pending' WHEN TA.APPROVED = 1 THEN 'Approved' ELSE 'Declined' END AS Status, 
		ISNULL(TA.Notes,'') as Notes
	FROM Timesheet T
		JOIN Employees E ON T.EmployeeId = E.EmployeeId
		JOIN Projects P ON T.ProjectId = P.ProjectId
		JOIN ProjectPhase PP ON T.PhaseId = PP.Id
		JOIN ProjectSubPhase PS ON T.SubPhaseId = PS.Id
		LEFT JOIN TimesheetAPPROVE TA ON T.ID = TA.TimesheetId
	WHERE E.UserId = @UserId
	AND T.DDay1 BETWEEN @StartDate AND @EndDate
	AND T.DDay7 BETWEEN @StartDate AND @EndDate
	order by T.DDay1 desc;
END
GO


