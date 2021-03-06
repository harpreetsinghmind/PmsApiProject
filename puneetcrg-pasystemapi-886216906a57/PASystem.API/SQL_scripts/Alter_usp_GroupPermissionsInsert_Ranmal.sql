USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GroupPermissionsInsert]    Script Date: 7/4/2019 4:01:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GroupPermissionsInsert] 
    @GroupId bigint,
    @PermissionId bigint,
    @InActive bit,
    @CreatedBy nvarchar(256) = NULL,
    @CreatedDate datetime = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  GroupPermissions WHERE GroupId =@GroupId and PermissionId=@PermissionId)
    BEGIN
		INSERT INTO [dbo].[GroupPermissions] ([GroupId], [PermissionId], [InActive], [CreatedBy], [CreatedDate])
		SELECT @GroupId, @PermissionId, @InActive, @CreatedBy, @CreatedDate
	
		DECLARE @newGroupPermission BIGINT,
				@roleId BIGINT
		-- Begin Return Select <- do not remove
		SELECT @newGroupPermission = SCOPE_IDENTITY()
		-- End Return Select <- do not remove
		
		INSERT INTO [dbo].[RolePermissions]
           ([RoleId]
           ,[GroupPermissionId]
           ,[InActive])
		SELECT 
			DISTINCT r.RoleId, @newGroupPermission, 0
		FROM 
			Roles r
			INNER JOIN RolePermissions rp ON rp.RoleId = r.RoleId
			INNER JOIN GroupPermissions gp ON gp.GroupPermissionId = rp.GroupPermissionId
			WHERE gp.GroupId = @GroupId

		SELECT @newGroupPermission

    END
	ELSE
	BEGIN
	SELECT -1
	END         
	COMMIT
