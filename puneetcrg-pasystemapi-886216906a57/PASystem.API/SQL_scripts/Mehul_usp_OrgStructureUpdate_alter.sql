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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureUpdate]    Script Date: 4/30/2019 3:58:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_OrgStructureUpdate] 
    @OrgStructureId bigint,
    @Name nvarchar(500),
    @Description nvarchar(MAX) = NULL,
    @InActive bit,
	@OrgSOrder int =null,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@Notes nvarchar(MAX) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  OrgStructure WHERE lower(Name) =LOWER(@Name) and OrgStructureId <> @OrgStructureId)
    BEGIN
		IF NOT EXISTS(SELECT * FROM OrgStructure WHERE OrgSOrder = @OrgSOrder and OrgStructureId <> @OrgStructureId)
		BEGIN
		UPDATE [dbo].[OrgStructure]
		SET    [Name] = @Name, [Description] = @Description, [InActive] = @InActive,OrgSOrder=@OrgSOrder,  [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate, [Notes] = @Notes
		WHERE  [OrgStructureId] = @OrgStructureId
	
		-- Begin Return Select <- do not remove
		SELECT [OrgStructureId]
		FROM   [dbo].[OrgStructure]
		WHERE  [OrgStructureId] = @OrgStructureId	
		-- End Return Select <- do not remove
		END
		ELSE
		BEGIN
		SELECT -2
		END
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

