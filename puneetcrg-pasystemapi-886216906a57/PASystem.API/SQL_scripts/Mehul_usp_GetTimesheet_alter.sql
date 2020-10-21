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

/****** Object:  StoredProcedure [dbo].[usp_GetTimesheet]    Script Date: 7/23/2019 6:26:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_GetTimesheet] 
	 @EmployeeId BIGINT,
     @SDate DATETIME,
     @EDate DATETIME
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 T.Id,
		 T.EmployeeId,
		 T.ProjectId,
		 T.PhaseId,
		 T.SubPhaseId,
		 T.Day1,
		 T.Day2,
		 T.Day3,
		 T.Day4,
		 T.Day5,
		 T.Day6,
		 T.Day7,
		 T.ODay1,
		 T.ODay2,
		 T.ODay3,
		 T.ODay4,
		 T.ODay5,
		 T.ODay6,
		 T.ODay7,
		 T.DDay1,
		 T.DDay2,
		 T.DDay3,
		 T.DDay4,
		 T.DDay5,
		 T.DDay6,
		 T.DDay7,
		 T.CreatedBy,
		 T.CreatedDate,
		 T.UpdatedBy,
		 T.UpdatedDate,
		 T.Status,
		 T.ManagerId,
		 T.ManagerComment,
		 T.EmployeeComment,
		 T.EmployeeEditTime,
		 (select top 1 UpdatedDate from ProjectAssign where ProjectId = T.ProjectId and EmployeeId = @EmployeeId and (Assigned = 0 or InActive = 1) order by UpdatedDate desc) AS UnAssignDate,
		 (select top 1 AssignDate from ProjectAssign where ProjectId = T.ProjectId and EmployeeId = @EmployeeId and (Assigned = 1 or InActive = 0) order by AssignDate desc) AS AssignDate,
		 ISNULL(T.Billing, SPH.BillingType) AS Billing,
		 ISNULL(P.Name,'') AS ProjectName,
		 CASE WHEN P.Locked = 0 OR P.Locked IS NULL
			THEN 
				CASE WHEN (P.StartDate IS NULL or P.StartDate >= GETDATE()) and (P.PlannedStartDate >= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
					THEN ISNULL(P.Locked, 0)
					WHEN (P.StartDate <= GETDATE() or P.PlannedStartDate <= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
					THEN ISNULL(P.Locked, 0)
					ELSE 'true'
				END
			ELSE ISNULL(P.Locked, 0)
		 END AS ProjectLocked,
		 --ISNULL(P.Locked, 0) AS ProjectLocked,
		 ISNULL(PH.Name,'') AS ProjectPhaseName,
		 ISNULL(PH.Locked, 0) AS PhaseLocked,
		 ISNULL(SPH.Name,'') AS ProjectSubPhaseName,
		 P.ProjectId AS Project,
		 PH.Id AS ProjectPhase,
		 SPH.Id	AS ProjectSubPhase,
		 p.ActualDate AS ProjectActualDate,
		 p.StartDate AS ProjectStartDate,
		 P.WorkingDays,
     	  (SELECT TOP 1 (WorkingHours * ISNULL(Multiplier,1)) FROM ProjectAssign WHERE EmployeeId = @EmployeeId AND ProjectId = T.ProjectId order by WorkingHours DESC) AS WHours,
		 (CASE  WHEN TA.Approved IS NULL
			  THEN 'Pending'
				WHEN TA.Approved = 0
				THEN 'Rejected'
				ELSE 'Approved'
			 END) AS ApprovedStatus,
		   TA.Notes As RejectNote,
		   TA.EditReqNote AS EditRequestReason,
		   TA.EditAllow AS EditApproved,
		   TA.ApproveId,
		   TA.EditDate
	FROM 
		[dbo].[Timesheet] T
		LEFT JOIN Projects P ON p.ProjectId = T.ProjectId
		LEFT JOIN ProjectPhase PH ON PH.Id = T.PhaseId
		LEFT JOIN ProjectSubPhase SPH ON SPH.Id = T.SubPhaseId
		LEFT JOIN TimesheetApprove TA ON TA.TimesheetId = T.Id
	WHERE 
		T.EmployeeId = @EmployeeId
		AND
		T.DDay1 = @SDate
		AND
		T.DDay7 = @EDate

	SELECT 
		 TD.Id,
		 ISNULL(TD.Detail,'') AS Detail,
		 ISNULL(TD.BillingNote,'') AS BillingNote,
		 ISNULL(TD.Hours,0) AS Hours,
		 ISNULL(TD.OHours,0) AS OHours,
		 TD.Day AS DDay,
		 TD.TimesheetId,
		 TD.WeekDay,
		 TD.CreatedBy		 
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
GO

