USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_TimesheetDetailUpdate]    Script Date: 4/15/2019 5:24:51 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_TimesheetDetailUpdate] 
	@TimesheetId BIGINT,
   	@Id BIGINT,
    @Detail NVARCHAR(MAX),
    @Status INT = NULL,
    @Day DATETIME,
    @ProjectTypeId BIGINT,
    @WeekDay INT,
    @CreatedBy NVARCHAR(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF EXISTS(SELECT * FROM  Timesheet WHERE Id = @TimesheetId)
    BEGIN
		IF EXISTS(SELECT * FROM  TimesheetDetail WHERE Id = @Id)
		BEGIN
			UPDATE [dbo].[TimesheetDetail]
			SET [TimesheetId] = @TimesheetId
			   ,[Day] = @Day
			   ,[WeekDay] = @WeekDay
			   ,[Detail] = @Detail
			   ,[UpdatedBy] = @CreatedBy
			   ,[UpdatedDate] = GETDATE()
			 WHERE Id = @Id
	
			-- Begin Return Select <- do not remove
			SELECT @Id	
		END
		ELSE
		BEGIN
			INSERT INTO [dbo].[TimesheetDetail]
			   ([TimesheetId]
			   ,[Day]
			   ,[WeekDay]
			   ,[Detail]
			   ,[CreatedBy]
			   ,[CreatedDate])
			VALUES
				(@TimesheetId
			   ,@Day
			   ,@WeekDay
			   ,@Detail
			   ,@CreatedBy
			   ,GETDATE())
		END
    END
	ELSE
	BEGIN
		SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
