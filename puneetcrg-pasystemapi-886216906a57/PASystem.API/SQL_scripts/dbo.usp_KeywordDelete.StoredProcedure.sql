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
/****** Object:  StoredProcedure [dbo].[usp_KeywordDelete]    Script Date: 3/4/2019 12:58:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_KeywordDelete] 
    @Id bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	Begin
	DELETE
	FROM   [dbo].[LanguageMaster]
	WHERE  [Id] = @Id
	End

	COMMIT
GO
