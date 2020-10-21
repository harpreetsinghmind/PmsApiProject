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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureMapInsert]    Script Date: 3/28/2019 4:09:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_OrgStructureMapInsert] 
    @ModuleName nvarchar(255),
	@ModuleId bigint,
	@OrgStructureId bigint,
	@OrgstructureLevelId bigint,
	@UserId bigint,
	@Attr2 nvarchar(255) = NULL,
	@Attr3 nvarchar(255) = NULL,
	@Attr4 nvarchar(255) = NULL,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
AS 
	
	
	INSERT INTO [dbo].[OrgStructureMapping] ([ModuleName],[ModuleId], [OrgStructureId],[OrgSructureLevelId],[UserId],[Attribute2],[Attribute3],[Attribute4],[CreatedBy],[CreatedDate], [UpdatedBy], [UpdatedDate])
	SELECT @ModuleName,@ModuleId,@OrgStructureId,@OrgstructureLevelId,@UserId,@Attr2,@Attr3,@Attr4, @CreatedBy, @CreatedDate, @UpdatedBy, @UpdatedDate
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
	-- End Return Select <- do not remove
               
	
GO

