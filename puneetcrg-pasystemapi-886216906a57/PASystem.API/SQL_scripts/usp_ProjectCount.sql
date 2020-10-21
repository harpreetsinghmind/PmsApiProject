USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectCount]    Script Date: 3/20/2019 2:47:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROC [dbo].[usp_ProjectCount] 
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT Count(*) as RecCount
	FROM   [dbo].[Projects] 

	COMMIT
GO


