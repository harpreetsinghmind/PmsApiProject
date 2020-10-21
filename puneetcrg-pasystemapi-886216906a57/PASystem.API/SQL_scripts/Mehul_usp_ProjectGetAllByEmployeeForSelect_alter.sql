/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectGetAllByEmployeeForSelect]    Script Date: 6/5/2019 1:30:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[usp_ProjectGetAllByEmployeeForSelect] 
	@EmployeeId BIGINT
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	select * from(select DISTINCT ProjectAssign.ProjectId, 
	Projects.Name AS ProjectName,
	ProjectAssign.InActive,
	Assigned,
	CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
		THEN 'NOT-STARTED'
		WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
		THEN 'OPENED'
		ELSE 'CLOSED'
	END AS ProStatus,
	CASE WHEN Projects.Locked = 0 OR Projects.Locked IS NULL
		THEN 
			CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN Projects.Locked
				WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN Projects.Locked
				ELSE 1
			END
		ELSE Projects.Locked
	END AS Locked,
    Projects.PaymentType,
	Projects.PlannedStartDate,
	ISNULL(Projects.StartDate, Projects.PlannedStartDate) AS StartDate,
	Projects.EndDate,
	Projects.ActualDate
	from ProjectAssign 
	left join Projects on ProjectAssign.ProjectId = Projects.ProjectId where EmployeeId = @EmployeeId and Projects.InActive = 0) x where x.ProStatus <> 'NOT-STARTED'


	select DISTINCT ProjectAssign.ProjectId, 
	Projects.Name AS ProjectName,
	ProjectAssign.InActive,
	Assigned,
	CASE WHEN Projects.InActive = 0
			THEN
				CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN 'N-S'
					WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
					THEN 'O'
					ELSE 'C'
				END 
			ELSE 'A'
	END AS ProStatus
	from ProjectAssign 
	left join Projects on ProjectAssign.ProjectId = Projects.ProjectId where EmployeeId = @EmployeeId


	 select pa.ProjectId, pa.WorkingHours, pa.BillableCost, p.WorkingDays from ProjectAssign pa
	 inner join Projects p on p.ProjectId = pa.ProjectId where EmployeeId = @EmployeeId order by pa.WorkingHours desc
	
	COMMIT
GO

