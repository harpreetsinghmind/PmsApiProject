USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CopyTimesheet]    Script Date: 4/15/2019 7:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_CopyTimesheet] 
    @SDate DATETIME,
    @EDate DATETIME,
    @EmployeeId BIGINT,
    @CreatedBy NVARCHAR(MAX) = NULL

AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	INSERT INTO [dbo].[Timesheet]
           ([EmployeeId]
           ,[ProjectId]
           ,[PhaseId]
           ,[SubPhaseId]
           ,[Day1]
           ,[Day2]
           ,[Day3]
           ,[Day4]
           ,[Day5]
           ,[Day6]
           ,[Day7]
           ,[DDay1]
           ,[DDay2]
           ,[DDay3]
           ,[DDay4]
           ,[DDay5]
           ,[DDay6]
           ,[DDay7]
           ,[CreatedBy]
           ,[CreatedDate])
	SELECT 
		 [EmployeeId]
		,[ProjectId]
		,[PhaseId]
		,[SubPhaseId]
		,[Day1]
		,[Day2]
		,[Day3]
		,[Day4]
		,[Day5]
		,[Day6]
		,[Day7]
		,[DDay1]
		,[DDay2]
		,[DDay3]
		,[DDay4]
		,[DDay5]
		,[DDay6]
		,[DDay7]
		,@CreatedBy
		,GETDATE()
	FROM 
		[dbo].[Timesheet]
	WHERE
		EmployeeId = @EmployeeId
		AND
		DDay1 = @SDate
		AND 
		DDay7 = @EDate
		
	COMMIT
