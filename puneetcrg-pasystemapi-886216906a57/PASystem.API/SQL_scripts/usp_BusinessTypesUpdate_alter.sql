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

/****** Object:  StoredProcedure [dbo].[usp_BusinessTypesUpdate]    Script Date: 4/1/2019 3:07:36 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_BusinessTypesUpdate] 
    @BusinessTypeId bigint,
    @BTName nvarchar(300),
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@InActive bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from BusinessTypes where lower(BTName) = LOWER(@BTName))
	BEGIN
	UPDATE [dbo].[BusinessTypes]
	SET    [BTName] = @BTName, InActive=@InActive, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate
	WHERE  [BusinessTypeId] = @BusinessTypeId
	
	-- Begin Return Select <- do not remove
	SELECT [BusinessTypeId], [BTName], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],InActive
	FROM   [dbo].[BusinessTypes]
	WHERE  [BusinessTypeId] = @BusinessTypeId	
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

