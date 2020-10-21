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

/****** Object:  StoredProcedure [dbo].[usp_phaseLockUpdate]    Script Date: 4/25/2019 2:22:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_phaseLockUpdate] 
	@Locked bit,
    @PhaseId bigint
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	BEGIN
	UPDATE [dbo].[ProjectPhase]
	SET    [Locked] = @Locked
	WHERE  [Id] = @PhaseId
	
	-- Begin Return Select <- do not remove
	SELECT [Id]
	FROM   [dbo].[ProjectPhase]
	WHERE  [Id] = @PhaseId	
	-- End Return Select <- do not remove
	END
	
	COMMIT
GO

