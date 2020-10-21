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

/****** Object:  StoredProcedure [dbo].[usp_KeywordUpdate]    Script Date: 4/10/2019 5:49:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_KeywordUpdate] 
	@Id bigint,
    @LanguageId bigint,
    @Keyword nvarchar(MAX),
    @Value nvarchar(MAX),
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	BEGIN
	UPDATE [dbo].[LanguageMaster]
	SET    [LanguageId] = @LanguageId, [Keyword] = @Keyword, [Value] = @Value, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [LanguageId] = @LanguageId and [Id] = @Id
	
	-- Begin Return Select <- do not remove
	SELECT [Id]
	FROM   [dbo].[LanguageMaster]
	WHERE  [Id] = @Id	
	-- End Return Select <- do not remove
	END
	
	COMMIT
GO

