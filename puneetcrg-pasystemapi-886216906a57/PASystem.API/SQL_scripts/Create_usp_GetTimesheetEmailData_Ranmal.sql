USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_CitiesSelect]    Script Date: 7/26/2019 4:19:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetTimesheetEmailData] 
    @timesheetId bigint,
	@employeeId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT DISTINCT
		t.Id,
		e.EmployeeId,
		m.EmployeeId AS ManagerId,
		t.DDay1 AS StartDate, 
		t.DDay7 AS EndDate, 
		e.PersonalEmail AS EmployeeEmail,
		m.PersonalEmail AS ManagerEmail,
		(LTRIM(RTRIM(ISNULL(e.FirstName, ''))) + ''+
		CASE WHEN LTRIM(RTRIM(ISNULL(e.MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL(e.MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL(e.MiddleName, ''))) + ''
		END +
		LTRIM(RTRIM(ISNULL(e.LastName, '')))) AS EmployeeName,
		(LTRIM(RTRIM(ISNULL(m.FirstName, ''))) + ''+
		CASE WHEN LTRIM(RTRIM(ISNULL(m.MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL(m.MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL(m.MiddleName, ''))) + ''
		END +
		LTRIM(RTRIM(ISNULL(m.LastName, '')))) AS ManagerName
	FROM 
		Timesheet t
		INNER JOIN Projects p ON p.ProjectId = t.ProjectId
		INNER JOIN ProjectAssign pa ON pa.ProjectId = p.ProjectId
		INNER JOIN Employees e ON e.EmployeeId = pa.EmployeeId
		INNER JOIN Employees m ON m.EmployeeId = pa.ReportingTo
	WHERE  
		t.Id = @timesheetId
		AND
		e.EmployeeId =@employeeId

	COMMIT
GO


