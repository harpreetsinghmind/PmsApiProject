ALTER PROC [dbo].[usp_GetTimesheetApproval]   
  @EmployeeId BIGINT,  
     @SDate DATETIME,  
     @EDate DATETIME,  
  @UserId INT  
    AS   
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
  
 BEGIN TRAN  
  
 DECLARE @LoggedInEmployeeId BIGINT  
 SET @LoggedInEmployeeId = (SELECT TOP 1 EmployeeId FROM Employees WHERE UserId = @UserId)  
  
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
   SPH.Id AS ProjectSubPhase,  
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
     TA.EditDate,  
     ISNULL(T.Submitted,0) AS Submitted,  
     ISNULL((SELECT 1  FROM ProjectAssign PA WHERE PA.EmployeeId = @EmployeeId AND PA.ReportingTo = @LoggedInEmployeeId AND PA.ProjectId = P.ProjectId),0) AS IsReportingPerson  
 FROM   
  [dbo].[Timesheet] T  
  INNER JOIN Projects P ON p.ProjectId = T.ProjectId  
  LEFT JOIN ProjectPhase PH ON PH.Id = T.PhaseId  
  LEFT JOIN ProjectSubPhase SPH ON SPH.Id = T.SubPhaseId  
  LEFT JOIN TimesheetApprove TA ON TA.TimesheetId = T.Id  
    
 WHERE   
  T.EmployeeId = @EmployeeId  
  AND  
  T.DDay1 = @SDate  
  AND  
  T.DDay7 = @EDate   
  AND  
  ISNULL(T.Submitted,1) = 1  
  AND  
  (  
   (P.ManagerId = @LoggedInEmployeeId)  
   OR  
   (P.ProjectId IN (SELECT ProjectId  FROM ProjectAssign WHERE EmployeeId = @EmployeeId AND ReportingTo = @LoggedInEmployeeId))  
  )  
  
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
  