USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectSummary]    Script Date: 7/25/2019 1:33:06 PM ******/
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
			CustomerId,
			CASE InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			CreatedDate    
		FROM  
			Projects
	END
	ELSE
	BEGIN
		SELECT 
			p.ProjectId,
			p.Name AS ProjectName,
			p.CustomerId,
			CASE p.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (p.StartDate IS NULL or p.StartDate >= GETDATE()) and (p.PlannedStartDate >= GETDATE()) and (p.ActualDate >= GETDATE() or p.ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (p.StartDate <= GETDATE() or p.PlannedStartDate <= GETDATE()) and (p.ActualDate >= GETDATE() or p.ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			p.CreatedDate    
		FROM  
			Projects p
			INNER JOIN ProjectAssign pa on pa.ProjectId = p.ProjectId
			INNER JOIN Employees e on pa.EmployeeId = e.EmployeeId
		WHERE
			e.UserId = @UserId
	END

	COMMIT
