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

/****** Object:  StoredProcedure [dbo].[usp_CopyTimesheet]    Script Date: 6/17/2019 6:33:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[usp_CopyTimesheet] 
    @SDate DATETIME,
    @EDate DATETIME,
    @EmployeeId BIGINT,
    @CreatedBy NVARCHAR(MAX) = NULL

AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	BEGIN TRY  
		BEGIN TRAN
		DECLARE Timesheet_CURSOR CURSOR FAST_FORWARD
		FOR  
			SELECT
				 [Id]
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
				,[ODay1]
				,[ODay2]
				,[ODay3]
				,[ODay4]
				,[ODay5]
				,[ODay6]
				,[ODay7]
				,[DDay1]
				,[DDay2]
				,[DDay3]
				,[DDay4]
				,[DDay5]
				,[DDay6]
				,[DDay7]
				,[Billing]
				,(select top 1 UpdatedDate from ProjectAssign where ProjectId = Timesheet.ProjectId and EmployeeId = @EmployeeId and Assigned = 0 order by UpdatedDate desc) as UpdateDate
				,(select Locked from Projects where ProjectId = Timesheet.ProjectId) as Locked
			FROM 
				[dbo].[Timesheet] WITH (UPDLOCK)
			WHERE
				EmployeeId = @EmployeeId
				AND
				DDay1 = @SDate
				AND 
				DDay7 = @EDate
			DECLARE @timesheetId BIGINT,
					@ProjectId BIGINT,
					@ProjectPhaseId BIGINT,
					@ProjectSubPhaseId BIGINT,
					@Day1 DECIMAL(10,2),
					@Day2 DECIMAL(10,2),
					@Day3 DECIMAL(10,2),
					@Day4 DECIMAL(10,2),
					@Day5 DECIMAL(10,2),
					@Day6 DECIMAL(10,2),
					@Day7 DECIMAL(10,2),
					@ODay1 DECIMAL(10,2),
					@ODay2 DECIMAL(10,2),
					@ODay3 DECIMAL(10,2),
					@ODay4 DECIMAL(10,2),
					@ODay5 DECIMAL(10,2),
					@ODay6 DECIMAL(10,2),
					@ODay7 DECIMAL(10,2),
					@DDay1 DATETIME,
					@DDay2 DATETIME,
					@DDay3 DATETIME,
					@DDay4 DATETIME,
					@DDay5 DATETIME,
					@DDay6 DATETIME,
					@DDay7 DATETIME,
					@Billing INT,
					@UpdateDate DATETIME,
					@Locked BIT    
		OPEN Timesheet_CURSOR  
		FETCH NEXT FROM Timesheet_CURSOR INTO @timesheetId, @ProjectId, @ProjectPhaseId, @ProjectSubPhaseId, @Day1,  @Day2,  @Day3,  @Day4,  @Day5,  @Day6,  @Day7, @ODay1,  @ODay2,  @ODay3,  @ODay4,  @ODay5,  @ODay6,  @ODay7,  @DDay1,  @DDay2,  @DDay3,  @DDay4,  @DDay5,  @DDay6,  @DDay7, @Billing , @UpdateDate , @Locked
		WHILE @@FETCH_STATUS = 0  
		BEGIN 
			DECLARE @updateTimesheetId BIGINT
			SET @updateTimesheetId = NULL
			IF @ProjectId IS NULL AND @ProjectPhaseId IS NULL AND  @ProjectSubPhaseId IS NULL
			BEGIN
				SELECT @updateTimesheetId = Id FROM  Timesheet WHERE DDay1 = DATEADD(dd,7,@DDay1) AND DDay7 = DATEADD(dd,7,@DDay7) AND EmployeeId = @EmployeeId  AND ProjectId IS NULL AND PhaseId IS NULL AND SubPhaseId IS NULL
			END
			ELSE IF @ProjectPhaseId IS NULL AND  @ProjectSubPhaseId IS NULL
			BEGIN
				SELECT @updateTimesheetId = Id FROM  Timesheet WHERE DDay1 = DATEADD(dd,7,@DDay1) AND DDay7 = DATEADD(dd,7,@DDay7) AND EmployeeId = @EmployeeId AND ProjectId = @ProjectId  AND PhaseId IS NULL AND SubPhaseId IS NULL
			END
			ELSE IF @ProjectSubPhaseId IS NULL
			BEGIN
				SELECT @updateTimesheetId = Id FROM  Timesheet WHERE DDay1 = DATEADD(dd,7,@DDay1) AND DDay7 = DATEADD(dd,7,@DDay7) AND EmployeeId = @EmployeeId AND ProjectId = @ProjectId AND PhaseId = @ProjectPhaseId AND SubPhaseId IS NULL
			END
			ELSE
			BEGIN
				SELECT @updateTimesheetId = Id FROM  Timesheet WHERE DDay1 = DATEADD(dd,7,@DDay1) AND DDay7 = DATEADD(dd,7,@DDay7) AND EmployeeId = @EmployeeId AND ProjectId = @ProjectId AND PhaseId = @ProjectPhaseId AND SubPhaseId = @ProjectSubPhaseId
			END
			DECLARE @CurDate DATETIME = GETDATE()
			IF @updateTimesheetId IS NULL
			BEGIN 
			DECLARE
			@IDay1 DECIMAL(10,2) = 0,
					@IDay2 DECIMAL(10,2) = 0,
					@IDay3 DECIMAL(10,2) = 0,
					@IDay4 DECIMAL(10,2) = 0,
					@IDay5 DECIMAL(10,2) = 0,
					@IDay6 DECIMAL(10,2) = 0,
					@IDay7 DECIMAL(10,2) = 0,
					@IODay1 DECIMAL(10,2) = 0,
					@IODay2 DECIMAL(10,2) = 0,
					@IODay3 DECIMAL(10,2) = 0,
					@IODay4 DECIMAL(10,2) = 0,
					@IODay5 DECIMAL(10,2) = 0,
					@IODay6 DECIMAL(10,2) = 0,
					@IODay7 DECIMAL(10,2) = 0
					IF DATEADD(dd,7,@DDay1) > @CurDate or DATEADD(dd,7,@DDay1) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day1 = @IDay1
						SET @ODay1 = @IODay1
					END
					IF DATEADD(dd,7,@DDay2) > @CurDate or DATEADD(dd,7,@DDay2) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day2 = @IDay2
						SET @ODay2 = @IODay2
					END
					IF DATEADD(dd,7,@DDay3) > @CurDate or DATEADD(dd,7,@DDay3) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day3 = @IDay3
						SET @ODay3 = @IODay3
					END
					IF DATEADD(dd,7,@DDay4) > @CurDate or DATEADD(dd,7,@DDay4) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day4 = @IDay4
						SET @ODay4 = @IODay4
					END
					IF DATEADD(dd,7,@DDay5) > @CurDate or DATEADD(dd,7,@DDay5) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day5 = @IDay5
						SET @ODay5 = @IODay5
					END
					IF DATEADD(dd,7,@DDay6) > @CurDate or DATEADD(dd,7,@DDay6) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day6 = @IDay6
						SET @ODay6 = @IODay6
					END
					IF DATEADD(dd,7,@DDay7) > @CurDate or DATEADD(dd,7,@DDay7) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day7 = @IDay7
						SET @ODay7 = @IODay7
					END
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
				   ,[ODay1]
				   ,[ODay2]
				   ,[ODay3]
				   ,[ODay4]
				   ,[ODay5]
				   ,[ODay6]
				   ,[ODay7]
				   ,[DDay1]
				   ,[DDay2]
				   ,[DDay3]
				   ,[DDay4]
				   ,[DDay5]
				   ,[DDay6]
				   ,[DDay7]
				   ,[Billing]
				   ,[CreatedBy]
				   ,[CreatedDate])
				VALUES (
					 @EmployeeId
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
					,@ODay1
					,@ODay2
					,@ODay3
					,@ODay4
					,@ODay5
					,@ODay6
					,@ODay7
					,DATEADD(dd,7,@DDay1)
					,DATEADD(dd,7,@DDay2)
					,DATEADD(dd,7,@DDay3)
					,DATEADD(dd,7,@DDay4)
					,DATEADD(dd,7,@DDay5)
					,DATEADD(dd,7,@DDay6)
					,DATEADD(dd,7,@DDay7)
					,@Billing
					,@CreatedBy
					,GETDATE())
				DECLARE @newTimesheetId BIGINT = SCOPE_IDENTITY()
				INSERT INTO [dbo].[TimesheetDetail]
					(Day
					,Detail
					,WeekDay
					,Status
					,CreatedBy
					,CreatedDate
					,TimesheetId)
				SELECT 
					(CASE 
						WHEN WeekDay =1 THEN DATEADD(dd,7,@DDay1)
						WHEN WeekDay =2 THEN DATEADD(dd,7,@DDay2)
						WHEN WeekDay =3 THEN DATEADD(dd,7,@DDay3)
						WHEN WeekDay =4 THEN DATEADD(dd,7,@DDay4)
						WHEN WeekDay =5 THEN DATEADD(dd,7,@DDay5)
						WHEN WeekDay =6 THEN DATEADD(dd,7,@DDay6)
						ELSE DATEADD(dd,7,@DDay1)
					END) AS Day
				   ,Detail
				   ,WeekDay
				   ,Status
				   ,@CreatedBy
				   ,GETDATE()
				   ,@newTimesheetId
				FROM
					[dbo].[TimesheetDetail] WITH (UPDLOCK)
				WHERE 
					TimesheetId = @timesheetId
			END
			ELSE
			BEGIN
			DECLARE
			@UDay1 DECIMAL(10,2) = 0,
					@UDay2 DECIMAL(10,2) = 0,
					@UDay3 DECIMAL(10,2) = 0,
					@UDay4 DECIMAL(10,2) = 0,
					@UDay5 DECIMAL(10,2) = 0,
					@UDay6 DECIMAL(10,2) = 0,
					@UDay7 DECIMAL(10,2) = 0,
					@UODay1 DECIMAL(10,2) = 0,
					@UODay2 DECIMAL(10,2) = 0,
					@UODay3 DECIMAL(10,2) = 0,
					@UODay4 DECIMAL(10,2) = 0,
					@UODay5 DECIMAL(10,2) = 0,
					@UODay6 DECIMAL(10,2) = 0,
					@UODay7 DECIMAL(10,2) = 0
					IF DATEADD(dd,7,@DDay1) > @CurDate or DATEADD(dd,7,@DDay1) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day1 = @UDay1
						SET @ODay1 = @UODay1
					END
					IF DATEADD(dd,7,@DDay2) > @CurDate or DATEADD(dd,7,@DDay2) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day2 = @UDay2
						SET @ODay2 = @UODay2
					END
					IF DATEADD(dd,7,@DDay3) > @CurDate or DATEADD(dd,7,@DDay3) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day3 = @UDay3
						SET @ODay3 = @UODay3
					END
					IF DATEADD(dd,7,@DDay4) > @CurDate or DATEADD(dd,7,@DDay4) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day4 = @UDay4
						SET @ODay4 = @UODay4
					END
					IF DATEADD(dd,7,@DDay5) > @CurDate or DATEADD(dd,7,@DDay5) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day5 = @UDay5
						SET @ODay5 = @UODay5
					END
					IF DATEADD(dd,7,@DDay6) > @CurDate or DATEADD(dd,7,@DDay6) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day6 = @UDay6
						SET @ODay6 = @UODay6
					END
					IF DATEADD(dd,7,@DDay7) > @CurDate or DATEADD(dd,7,@DDay7) > @UpdateDate or @Locked = 1
					BEGIN
						SET @Day7 = @UDay7
						SET @ODay7 = @UODay7
					END
				UPDATE [dbo].[Timesheet]
				SET  [Day1] = @Day1
					,[Day2] = @Day2
					,[Day3] = @Day3
					,[Day4] = @Day4
					,[Day5] = @Day5
					,[Day6] = @Day6
					,[Day7] = @Day7
					,[ODay1] = @ODay1
					,[ODay2] = @ODay2
					,[ODay3] = @ODay3
					,[ODay4] = @ODay4
					,[ODay5] = @ODay5
					,[ODay6] = @ODay6
					,[ODay7] = @ODay7
					,[Billing] = @Billing
				WHERE Id = @updateTimesheetId
				DELETE FROM TimesheetDetail WHERE TimesheetId = @updateTimesheetId
				INSERT INTO [dbo].[TimesheetDetail]
						(Day
						,Detail
						,WeekDay
						,Status
						,CreatedBy
						,CreatedDate
						,TimesheetId)
					SELECT 
						(CASE 
							WHEN WeekDay =1 THEN DATEADD(dd,7,@DDay1)
							WHEN WeekDay =2 THEN DATEADD(dd,7,@DDay2)
							WHEN WeekDay =3 THEN DATEADD(dd,7,@DDay3)
							WHEN WeekDay =4 THEN DATEADD(dd,7,@DDay4)
							WHEN WeekDay =5 THEN DATEADD(dd,7,@DDay5)
							WHEN WeekDay =6 THEN DATEADD(dd,7,@DDay6)
							ELSE DATEADD(dd,7,@DDay1)
						END) AS Day
					   ,Detail
					   ,WeekDay
					   ,Status
					   ,@CreatedBy
					   ,GETDATE()
					   ,@updateTimesheetId
					FROM
						[dbo].[TimesheetDetail] WITH (UPDLOCK)
					WHERE 
						TimesheetId = @timesheetId
			END
			FETCH  FROM Timesheet_CURSOR INTO  @timesheetId, @ProjectId, @ProjectPhaseId, @ProjectSubPhaseId, @Day1,  @Day2,  @Day3,  @Day4,  @Day5,  @Day6,  @Day7, @ODay1,  @ODay2,  @ODay3,  @ODay4,  @ODay5,  @ODay6,  @ODay7,  @DDay1,  @DDay2,  @DDay3,  @DDay4,  @DDay5,  @DDay6,  @DDay7, @Billing , @UpdateDate , @Locked
		END  
		CLOSE Timesheet_CURSOR  
		DEALLOCATE Timesheet_CURSOR  
		SELECT 1
		COMMIT
	END TRY  
	BEGIN CATCH
		SELECT 0
	END CATCH  
GO

