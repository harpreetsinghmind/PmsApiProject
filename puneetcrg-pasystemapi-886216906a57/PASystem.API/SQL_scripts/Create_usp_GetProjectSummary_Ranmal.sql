USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectSummary]    Script Date: 6/17/2019 3:04:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetProjectSummary] 
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

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

	COMMIT
