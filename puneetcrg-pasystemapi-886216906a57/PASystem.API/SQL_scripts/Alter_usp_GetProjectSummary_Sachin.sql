USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectSummary]    Script Date: 8/6/2019 8:28:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetProjectSummary] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	IF @UserType = 1
	BEGIN
		SELECT 
			ProjectId,
			Name AS ProjectName,
			Projects.CustomerId,
			CASE Projects.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			Projects.CreatedDate, C.CustomerName, E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName AS ManagerName,
			Projects.PlannedStartDate AS ESDate, Projects.StartDate AS SDate, Projects.EndDate AS EDate, Projects.ActualDate AS ADate
		FROM  
			Projects
			JOIN Customers C ON PROJECTS.CustomerId = C.CustomerId
			JOIN Employees E ON PROJECTS.ManagerId = E.EmployeeId
	END
	ELSE
	BEGIN
		SELECT 
			P.ProjectId,
			P.Name AS ProjectName,
			P.CustomerId,
			CASE P.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (P.StartDate IS NULL or P.StartDate >= GETDATE()) and (P.PlannedStartDate >= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (P.StartDate <= GETDATE() or P.PlannedStartDate <= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			P.CreatedDate, C.CustomerName, E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName AS ManagerName,
			P.PlannedStartDate AS ESDate, P.StartDate AS SDate, P.EndDate AS EDate, P.ActualDate AS ADate
		FROM  
			Projects P
			JOIN ProjectAssign PA ON PA.ProjectId = P.ProjectId
			JOIN Employees E ON PA.EmployeeId = E.EmployeeId
			JOIN Customers C ON P.CustomerId = C.CustomerId 
		WHERE
			E.UserId = @UserId
	END

	COMMIT
