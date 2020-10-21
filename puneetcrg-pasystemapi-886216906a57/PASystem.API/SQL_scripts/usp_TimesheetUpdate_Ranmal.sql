USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_TimesheetUpdate]    Script Date: 4/15/2019 6:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_TimesheetUpdate] 
	@TimesheetId BIGINT,
    @ProjectId BIGINT,
	@ProjectPhaseId BIGINT,
    @ProjectSubPhaseId BIGINT,
    @EmployeeId BIGINT,
    @Day1 DECIMAL(10,2),
    @Day2 DECIMAL(10,2),
    @Day3 DECIMAL(10,2),
    @Day4 DECIMAL(10,2),
    @Day5 DECIMAL(10,2),
    @Day6 DECIMAL(10,2),
    @Day7 DECIMAL(10,2),
    @DDay1 DATETIME,
    @DDay2 DATETIME,
    @DDay3 DATETIME,
    @DDay4 DATETIME,
    @DDay5 DATETIME,
    @DDay6 DATETIME,
    @DDay7 DATETIME,
    @CreatedBy NVARCHAR(250) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	IF EXISTS(SELECT * FROM Timesheet WHERE Id = @TimesheetId)
	BEGIN
		UPDATE [dbo].[Timesheet]
		   SET [EmployeeId] = @EmployeeId
			  ,[ProjectId] = @ProjectId
			  ,[PhaseId] = @ProjectPhaseId
			  ,[SubPhaseId] = @ProjectSubPhaseId
			  ,[Day1] = @Day1
			  ,[Day2] = @Day2
			  ,[Day3] = @Day3
			  ,[Day4] = @Day4
			  ,[Day5] = @Day5
			  ,[Day6] = @Day6
			  ,[Day7] = @Day7
			  ,[DDay1] = @DDay1
			  ,[DDay2] = @DDay2
			  ,[DDay3] = @DDay3
			  ,[DDay4] = @DDay4
			  ,[DDay5] = @DDay5
			  ,[DDay6] = @DDay6
			  ,[DDay7] = @DDay7
			  ,[UpdatedBy] = @CreatedBy
			  ,[UpdatedDate] = GETDATE()
		 WHERE Id = @TimesheetId
	
		-- Begin Return Select <- do not remove
		SELECT @TimesheetId	
	END
	ELSE
	BEGIN
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
		VALUES
           (@EmployeeId
           ,@ProjectId
           ,@ProjectPhaseId
           ,@ProjectSubPhaseId
           ,@Day1
           ,@Day2
           ,@Day3
           ,@Day4
           ,@Day5
           ,@Day6
           ,@Day7
           ,@DDay1
           ,@DDay2
           ,@DDay3
           ,@DDay4
           ,@DDay5
           ,@DDay6
           ,@DDay7
           ,@CreatedBy
           ,GETDATE())

		SELECT SCOPE_IDENTITY()	
	END
                   
	COMMIT
