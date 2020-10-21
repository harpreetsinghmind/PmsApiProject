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

/****** Object:  StoredProcedure [dbo].[usp_TimesheetEditRequest]    Script Date: 7/30/2019 11:48:17 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROC [dbo].[usp_TimesheetEditRequest] 
   	@EmployeeId bigint,
    @TimesheetId bigint,
	@EditReqNote nvarchar(150)

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
			UPDATE [dbo].[TimesheetApprove]
			SET 
				[EditReqNote] = @EditReqNote,
				[UpdatedDate] = GETDATE()
				WHERE [TimesheetId] = @TimesheetId AND [EmployeeId] = @EmployeeId
	COMMIT
GO

