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

/****** Object:  StoredProcedure [dbo].[usp_ProjectDelete]    Script Date: 6/5/2019 1:29:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_ProjectDelete] 
    @ProjectId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	Declare @Count int
	Set @Count = ( Select Count(*) From  ProjectAssign where ProjectId  = @ProjectId )

	BEGIN TRAN
	IF @Count = 1
		BEGIN
			DELETE
			FROM [dbo].[ProjectAssign]
			WHERE  ProjectId = @ProjectId

			DELETE
			FROM [dbo].[Projects]
			WHERE  [ProjectId] = @ProjectId
		END
	ELSE
		BEGIN
			DELETE
			FROM [dbo].[Projects]
			WHERE  [ProjectId] = @ProjectId
		END
	COMMIT
GO

