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

/****** Object:  StoredProcedure [dbo].[usp_OrgStructureInsert]    Script Date: 4/30/2019 3:58:38 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_OrgStructureInsert] 
    @Name nvarchar(500),
    @Description nvarchar(MAX) = NULL,
    @InActive bit,
	@OrgSOrder int=NULL,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
	@Notes nvarchar(MAX) = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  OrgStructure WHERE lower(Name) =LOWER(@Name))
	BEGIN
		IF NOT EXISTS(SELECT * FROM OrgStructure where OrgSOrder = @OrgSOrder)
		BEGIN
		INSERT INTO [dbo].[OrgStructure] ([Name], [Description], [InActive],[OrgSOrder] ,[CreatedBy], [CreatedDate], [Notes])
		SELECT @Name, @Description, @InActive,@OrgSOrder, @CreatedBy, @CreatedDate, @Notes
	
		-- Begin Return Select <- do not remove
		SELECT SCOPE_IDENTITY()
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
	-- End Return Select <- do not remove
               
	COMMIT
GO

