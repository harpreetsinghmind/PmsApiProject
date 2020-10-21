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

/****** Object:  StoredProcedure [dbo].[usp_GetAllRolesByUserId]    Script Date: 5/6/2019 5:15:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetAllRolesByUserId] 
	@UserId bigint
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
SELECT UserRoles.RoleId,Roles.Name
	FROM   [dbo].[UserRoles] inner join Roles on Roles.RoleId=UserRoles.RoleId where UserRoles.UserId=@UserId
	

	COMMIT
GO

