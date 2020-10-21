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

/****** Object:  StoredProcedure [dbo].[usp_PermissionsGetAllWithGroup]    Script Date: 4/16/2019 3:37:02 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_PermissionsGetAllWithGroup] 
	@PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT Permissions.[PermissionId], Groups.[GroupName],Groups.[InActive] as GroupInActive, [Permission],Permissions.[Description], Permissions.[InActive], Permissions.[CreatedBy], Permissions.[CreatedDate], Permissions.[UpdatedBy], Permissions.[UpdatedDate],GroupPermissionId,GroupPermissions.GroupId 
	FROM   [dbo].[GroupPermissions] inner join Permissions on Permissions.PermissionId=GroupPermissions.PermissionId inner join Groups on Groups.GroupId=GroupPermissions.GroupId  order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'SELECT Permissions.[PermissionId], Groups.[GroupName],Groups.[InActive] as GroupInActive, [Permission],Permissions.[Description], Permissions.[InActive], Permissions.[CreatedBy], Permissions.[CreatedDate], Permissions.[UpdatedBy], Permissions.[UpdatedDate],GroupPermissionId ,GroupPermissions.GroupId
	FROM   [dbo].[GroupPermissions] inner join Permissions on Permissions.PermissionId=GroupPermissions.PermissionId inner join Groups on Groups.GroupId=GroupPermissions.GroupId  '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM  [dbo].[GroupPermissions] inner join Permissions on Permissions.PermissionId=GroupPermissions.PermissionId inner join Groups on Groups.GroupId=GroupPermissions.GroupId ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

	

	COMMIT
GO

