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

/****** Object:  StoredProcedure [dbo].[usp_GetProjectAssigniRole]    Script Date: 8/2/2019 4:40:13 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/****** Object:  StoredProcedure [dbo].[usp_GetProjectAssigniRole]    Script Date: 16-11-2018 18:54:27 ******/

CREATE PROC [dbo].[usp_GetProjectAssigniRole] 
    @UserId BIGINT
AS 
	SET NOCOUNT ON 
 
	BEGIN TRAN
			select Roles.Name from UserRoles
			inner join Roles on UserRoles.RoleId = Roles.RoleId
			 where UserId = @UserId
	COMMIT
GO

