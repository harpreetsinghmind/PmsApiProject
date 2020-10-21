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

/****** Object:  StoredProcedure [dbo].[usp_TimesheetApproved]    Script Date: 7/23/2019 6:27:07 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[usp_TimesheetApproved] 
   	@EmployeeId bigint,
    @TimesheetId bigint,
	@Notes nvarchar(150),
	@Approved bit

    
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
			UPDATE [dbo].[TimesheetApprove]
			SET 
				[EmployeeId] = @EmployeeId,
				[TimesheetId] = @TimesheetId,
				[Notes] = @Notes,
				[Approved] = @Approved,
				[UpdatedDate] = GETDATE()
				WHERE [TimesheetId] = @TimesheetId
		END
	COMMIT
GO

