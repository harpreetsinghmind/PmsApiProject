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

/****** Object:  StoredProcedure [dbo].[usp_UpdateUserStatus]    Script Date: 7/1/2019 4:11:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_UpdateUserStatus] 
@UserId bigint
	AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
		UPDATE Users set InActive = 1 where UserId = @UserId
	
		UPDATE Employees set InActive = 1 where UserId = @UserId

	COMMIT


	 
GO

