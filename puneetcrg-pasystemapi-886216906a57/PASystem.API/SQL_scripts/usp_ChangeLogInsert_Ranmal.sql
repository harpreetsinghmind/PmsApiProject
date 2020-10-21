USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ChangeLogInsert]    Script Date: 4/2/2019 8:57:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_ChangeLogInsert] 
    @entityId BIGINT,
	@moduleId BIGINT,
	@change NVARCHAR(250),
	@detail NVARCHAR(MAX),
	@updatedBy NVARCHAR(250) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	INSERT INTO [dbo].[ChangeLog]
           ([ModuleId]
           ,[EntityId]
           ,[Change]
           ,[Detail]
           ,[UpdatedDate]
           ,[UpdatedBy])
     VALUES
           (@moduleId
           ,@entityId
           ,@change
           ,@detail
           ,GETDATE()
           ,@updatedBy)

	COMMIT
