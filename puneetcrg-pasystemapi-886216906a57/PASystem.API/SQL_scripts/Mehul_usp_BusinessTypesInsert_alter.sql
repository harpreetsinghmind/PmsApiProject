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

/****** Object:  StoredProcedure [dbo].[usp_BusinessTypesInsert]    Script Date: 4/29/2019 3:59:29 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_BusinessTypesInsert] 
    @BTName nvarchar(300),
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
	@InActive bit
AS 
	BEGIN TRAN
	IF NOT EXISTS(select * from BusinessTypes where lower(BTName) = LOWER(@BTName))
	BEGIN
	INSERT INTO [dbo].[BusinessTypes] ([BTName],[CreatedBy], [CreatedDate], [InActive])
	SELECT @BTName, @CreatedBy, @CreatedDate, @InActive
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
	-- End Return Select <- do not remove
    END
	ELSE
	BEGIN
	SELECT -1
	END      
	COMMIT     
	
GO

