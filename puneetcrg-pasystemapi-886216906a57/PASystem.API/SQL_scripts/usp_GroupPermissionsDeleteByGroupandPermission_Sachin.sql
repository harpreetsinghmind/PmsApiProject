/****** Object:  StoredProcedure [dbo].[usp_GroupPermissionsDeleteByGroupandPermission]    Script Date: 22-12-2019 14:15:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GroupPermissionsDeleteByGroupandPermission]
    @GroupId bigint,
	@PermissionId bigint
AS 
BEGIN
	SET NOCOUNT ON
	SET XACT_ABORT ON
	
	BEGIN TRAN

	IF EXISTS (SELECT RP.* FROM RolePermissions RP JOIN GroupPermissions GP ON RP.GroupPermissionId = GP.GroupPermissionId AND GP.GroupId = @GroupId AND GP.PermissionId = @PermissionId)
	BEGIN
		DELETE RP FROM RolePermissions RP 
			JOIN GroupPermissions GP ON RP.GroupPermissionId = GP.GroupPermissionId 
				AND GP.GroupId = @GroupId AND GP.PermissionId = @PermissionId
	END

	DELETE
	FROM   [dbo].[GroupPermissions]
	WHERE  [GroupId] = @GroupId and PermissionId=@PermissionId

	COMMIT
END
