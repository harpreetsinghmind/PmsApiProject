USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_TimesheetDetailDelete]    Script Date: 6/26/2019 1:20:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_TimesheetDetailDelete] 
    @TimesheetDetailId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

		DECLARE @timesheetId BIGINT,
				@WeekDay INT
		SELECT 
			@timesheetId = TimesheetId,
			@WeekDay = WeekDay 
		FROM 
			TimesheetDetail 
		WHERE 
			Id = @TimesheetDetailId

		DELETE 
		FROM 
			[dbo].[TimesheetDetail]
		WHERE  
			Id = @TimesheetDetailId

	
		
			UPDATE Timesheet 
							SET Day1 = CASE 
										WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 1)
										ELSE Day1
									END,
								Day2 = CASE 
										WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 2)
										ELSE Day2
									END,
								Day3 = CASE 
										WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 3)
										ELSE Day3
									END,
								Day4 = CASE 
										WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 4)
										ELSE Day4
									END,
								Day5 = CASE 
										WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 5)
										ELSE Day5
									END,
								Day6 = CASE 
										WHEN @WeekDay = 6 THEN (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 6)
										ELSE Day6
									END,
								Day7 = CASE 
										WHEN @WeekDay = 7 THEN (SELECT SUM(TimesheetDetail.Hours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 7)
										ELSE Day7
									END
							WHERE Id = @TimesheetId
		
			UPDATE Timesheet 
							SET ODay1 = CASE 
										WHEN @WeekDay = 1 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 1)
										ELSE ODay1
									END,
								ODay2 = CASE 
										WHEN @WeekDay = 2 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 2)
										ELSE ODay2
									END,
								ODay3 = CASE 
										WHEN @WeekDay = 3 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 3)
										ELSE ODay3
									END,
								ODay4 = CASE 
										WHEN @WeekDay = 4 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 4)
										ELSE ODay4
									END,
								ODay5 = CASE 
										WHEN @WeekDay = 5 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 5)
										ELSE ODay5
									END,
								ODay6 = CASE 
										WHEN @WeekDay = 6 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 6)
										ELSE ODay6
									END,
								ODay7 = CASE 
										WHEN @WeekDay = 7 THEN  (SELECT SUM(TimesheetDetail.OHours) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 7)
										ELSE ODay7
									END
							WHERE Id = @TimesheetId
		

	COMMIT
