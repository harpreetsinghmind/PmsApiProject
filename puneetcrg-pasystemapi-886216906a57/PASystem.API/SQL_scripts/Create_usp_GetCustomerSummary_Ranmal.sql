USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetProjectSummary]    Script Date: 6/17/2019 3:04:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_GetCustomerSummary] 
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		CustomerId,
		CustomerName,
		CASE InActive
			WHEN 0 THEN 'Active'
			WHEN 1 THEN 'InActive'
		END as Status 
	FROM  
		Customers

	COMMIT
