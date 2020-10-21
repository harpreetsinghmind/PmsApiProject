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

/****** Object:  StoredProcedure [dbo].[usp_GetProjectStartDate]    Script Date: 5/30/2019 2:35:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[usp_GetProjectStartDate] 
	@EmployeeId BIGINT
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN


SELECT top 1 ISNULL(projects.StartDate,  Projects.PlannedStartDate) AS StartDate FROM projects 
				JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
				where ProjectAssign.EmployeeId = @EmployeeId order by StartDate asc
	
	COMMIT
GO

