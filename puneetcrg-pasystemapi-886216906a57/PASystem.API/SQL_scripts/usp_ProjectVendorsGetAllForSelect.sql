USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectVendorsGetAllForSelect]    Script Date: 3/20/2019 2:51:25 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectVendorsGetAllForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 VendorId
		,Name
		,InActive
	FROM   [dbo].[ProjectVendor] where InActive=0
	
	COMMIT
GO


