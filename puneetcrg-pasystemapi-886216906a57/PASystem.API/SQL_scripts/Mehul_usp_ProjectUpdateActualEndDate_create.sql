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

/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdateActualEndDate]    Script Date: 5/13/2019 4:20:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectUpdateActualEndDate] 
	@ProjectId bigint,
	@ActualDate DATETIME,
    @UpdatedBy nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF EXISTS(SELECT * FROM  Projects WHERE ProjectId = @ProjectId)
    BEGIN
		UPDATE  [dbo].[Projects] 
		SET 
			[ActualDate] = @ActualDate, 
			[UpdatedBy] = @UpdatedBy, 
			[UpdatedDate] = GETDATE()
		WHERE 
			ProjectId = @ProjectId
	
		-- Begin Return Select <- do not remove
		SELECT 
			ProjectId
		FROM   
			[dbo].[Projects]
		WHERE 
			 ProjectId = @ProjectId	
    END
	ELSE
	BEGIN
		SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
GO

