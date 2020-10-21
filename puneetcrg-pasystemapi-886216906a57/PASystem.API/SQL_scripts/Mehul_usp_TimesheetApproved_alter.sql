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

/****** Object:  StoredProcedure [dbo].[usp_TimesheetApproved]    Script Date: 7/26/2019 6:17:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROC [dbo].[usp_TimesheetApproved] 
	@ApprovedId bigint = NULL,
   	@EmployeeId bigint,
    @TimesheetId bigint,
	@Notes nvarchar(150),
	@Approved bit,
	@EditDate datetime = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	 IF NOT EXISTS(select * from TimesheetApprove where TimesheetId = @TimesheetId)
		 BEGIN
			INSERT INTO [dbo].[TimesheetApprove]
			([EmployeeId],
			[TimesheetId],
			[Notes],
			[Approved],
			[CreatedDate]
			)
			VALUES
			(@EmployeeId,
			@TimesheetId,
			@Notes,
			@Approved,
			GETDATE()
			)
			SELECT SCOPE_IDENTITY()
		 END
	ELSE
	BEGIN
		IF @ApprovedId IS NULL
			BEGIN
				UPDATE [dbo].[TimesheetApprove]
				SET 
					[EmployeeId] = @EmployeeId,
					[TimesheetId] = @TimesheetId,
					[Notes] = @Notes,
					[Approved] = @Approved,
					[UpdatedDate] = GETDATE()
					WHERE [TimesheetId] = @TimesheetId
			END
		ELSE IF @EditDate IS NOT NULL
			BEGIN
				UPDATE [dbo].[TimesheetApprove]
						SET 
							[EditReqNote] = NULL,
							[EditAllow] = 1,
							[Approved] = @Approved,
							[Notes] = @Notes,
							[EditDate] = @EditDate,
							[UpdatedDate] = GETDATE()
							WHERE [TimesheetId] = @TimesheetId
			END
		ELSE
			BEGIN
				UPDATE [dbo].[TimesheetApprove]
				SET 
					[EditReqNote] = NULL,
					[EditAllow] = 0,
					[Approved] = @Approved,
					[UpdatedDate] = GETDATE()
					WHERE [TimesheetId] = @TimesheetId
			END
	END
	COMMIT
GO

