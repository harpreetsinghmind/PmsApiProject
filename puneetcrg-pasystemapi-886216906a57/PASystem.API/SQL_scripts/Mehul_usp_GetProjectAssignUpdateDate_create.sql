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

/****** Object:  StoredProcedure [dbo].[usp_GetProjectAssignUpdateDate]    Script Date: 6/14/2019 1:59:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[usp_GetProjectAssignUpdateDate] 
	@ProjectId BIGINT,
	@EmployeeId BIGINT
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	select top 1 UpdatedDate from ProjectAssign where ProjectId = @ProjectId and EmployeeId = @EmployeeId and Assigned = 0 order by UpdatedDate desc
	
	COMMIT
GO

