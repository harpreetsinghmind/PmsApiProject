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
/****** Object:  StoredProcedure [dbo].[usp_LanguageTranslation]    Script Date: 2/27/2019 3:16:18 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_LanguageTranslation] 
    @LanguageId bigint,
    @KeyWord nvarchar(MAX),
    @Value nvarchar(MAX),
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  LanguageMaster WHERE lower(Keyword) =LOWER(@KeyWord) and LanguageId = @LanguageId )
    BEGIN
	INSERT INTO [dbo].[LanguageMaster] ([LanguageId], [Keyword], [Value] ,[CreatedBy], [CreatedDate])
	SELECT @LanguageId, @KeyWord, @Value, @CreatedBy, @CreatedDate
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
    end
	ELSE
	BEGIN
	SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
GO
