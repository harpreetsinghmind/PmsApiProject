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
/****** Object:  StoredProcedure [dbo].[usp_LanguageUpdate]    Script Date: 2/28/2019 1:11:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_LanguageUpdate] 
    @LanguageId bigint,
    @Name nvarchar(10),
    @DisplayName nvarchar(100),
	@IsDefault bit,
    @InActive bit,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	BEGIN
	UPDATE [dbo].[Languages]
	SET    [Name] = @Name, [DisplayName] = @DisplayName, [Isdefault] = @IsDefault, [InActive] = @InActive,  [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [LanguageId] = @LanguageId
	
	-- Begin Return Select <- do not remove
	SELECT [LanguageId]
	FROM   [dbo].[Languages]
	WHERE  [LanguageId] = @LanguageId	
	-- End Return Select <- do not remove
	END
	BEGIN
	SELECT -1
	END
	COMMIT
GO
