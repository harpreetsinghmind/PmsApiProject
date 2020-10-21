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

/****** Object:  StoredProcedure [dbo].[usp_AddNewLanguage]    Script Date: 2/28/2019 1:08:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_AddNewLanguage]
    @Name nvarchar(10),
    @DisplayName nvarchar(100),
    @Icon nvarchar(150),
	@IsDefault bit,
	@InActive bit,
	@CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[Languages] ([Name], [DisplayName], [Icon],[Isdefault],[InActive],[CreatedBy], [CreatedDate])
	SELECT @Name, @DisplayName,@Icon,@IsDefault,@InActive, @CreatedBy, @CreatedDate
	
	-- Begin Return Select <- do not remove
	SELECT  SCOPE_IDENTITY()
	-- End Return Select <- do not remove
     
	COMMIT
GO

