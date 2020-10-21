/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectAssigni]    Script Date: 5/28/2019 10:47:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  StoredProcedure [dbo].[usp_GetProjectAssigni]    Script Date: 16-11-2018 18:54:27 ******/

CREATE PROC [dbo].[usp_GetProjectAssigni] 
    @ProjectId BIGINT,
	@EmployeeId BIGINT = NULL
AS 
	SET NOCOUNT ON 
 
	BEGIN TRAN
	IF @EmployeeId IS NUll
		BEGIN
		SELECT * FROM [dbo].[ProjectAssign] where ProjectId = @ProjectId
		END
	ELSE
		BEGIN
		SELECT * FROM [dbo].[ProjectAssign] where ProjectId = @ProjectId and EmployeeId = @EmployeeId
		END
	COMMIT
