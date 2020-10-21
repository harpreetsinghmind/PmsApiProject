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

/****** Object:  StoredProcedure [dbo].[usp_GetUserPermission]    Script Date: 6/19/2019 2:39:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetUserPermission] 
    @UserId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	 select 
 Permissions.Permission from (select GroupPermissions.* from UserRoles 
 inner join Roles on Roles.RoleId = UserRoles.RoleId
  inner join RolePermissions on RolePermissions.RoleId = Roles.RoleId
  inner join GroupPermissions on GroupPermissions.GroupPermissionId = RolePermissions.GroupPermissionId
where UserId = @UserId) AS T
inner join Permissions on T.PermissionId = Permissions.PermissionId

	COMMIT
GO

