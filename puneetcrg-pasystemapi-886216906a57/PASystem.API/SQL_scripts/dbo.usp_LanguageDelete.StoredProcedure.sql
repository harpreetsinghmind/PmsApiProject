/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [PASystemTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_LanguageDelete]    Script Date: 2/28/2019 4:17:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_LanguageDelete] 
    @LanguageId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT exists(Select * from LanguageMaster where LanguageId = @LanguageId)
	Begin
	DELETE
	FROM   [dbo].[Languages]
	WHERE  [LanguageId] = @LanguageId
	End
	Else
	Begin
	DELETE
	FROM   [dbo].[LanguageMaster]
	WHERE  [LanguageId] = @LanguageId
	DELETE
	FROM   [dbo].[Languages]
	WHERE  [LanguageId] = @LanguageId
	End

	COMMIT
GO
