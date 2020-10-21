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

/****** Object:  StoredProcedure [dbo].[usp_CheckProjectAssigniTimesheet]    Script Date: 5/28/2019 12:35:22 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/****** Object:  StoredProcedure [dbo].[usp_CheckProjectAssigniTimesheet]    Script Date: 16-11-2018 18:54:27 ******/

CREATE PROC [dbo].[usp_CheckProjectAssigniTimesheet] 
    @ProjectId BIGINT,
	@EmployeeId BIGINT
AS 
	SET NOCOUNT ON 
 
	BEGIN TRAN
		
		SELECT * FROM [dbo].[Timesheet] where ProjectId = @ProjectId and EmployeeId = @EmployeeId
		
	COMMIT
GO

