CREATE PROC [dbo].[usp_EmployeeGetAttendance] --exec [usp_EmployeeGetAttendance] 10032,'2019/08/12','2019/08/18'
	@UserId bigint,
	@WeekStartDate datetime,
	@WeekEndDate datetime
AS 
SET NOCOUNT ON 
SET XACT_ABORT ON  

BEGIN TRAN
	  
	    SELECT  CONVERT(VARCHAR(20),InTime,101) AS AttendanceDate, SUM(TotalTime) AS TotalTime
		FROM [dbo].[Attendance] 
		WHERE UserId = @UserId AND InTime BETWEEN @WeekStartDate AND @WeekEndDate
		GROUP BY CONVERT(VARCHAR(20),InTime,101)


		SELECT  CONVERT(VARCHAR(20),InTime,101) AS AttendanceDate, CONVERT(VARCHAR(20),InTime,108) AS InTime, CONVERT(VARCHAR(20),OutTime,108) AS OutTime, InNotes, OutNotes
		FROM [dbo].[Attendance] 
		WHERE UserId = @UserId AND InTime BETWEEN @WeekStartDate AND @WeekEndDate
		

COMMIT
