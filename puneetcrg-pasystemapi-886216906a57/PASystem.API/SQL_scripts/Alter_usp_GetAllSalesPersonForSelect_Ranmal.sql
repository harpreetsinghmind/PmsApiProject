USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllSalesPersonForSelect]    Script Date: 4/4/2019 12:32:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_GetAllSalesPersonForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
		 [SalesPerson].SalesPersonId,
		 LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
		 CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([SalesPerson].LastName, ''))) as SalesPersonName
	FROM   
		[dbo].[SalesPerson] 
	WHERE 
		[SalesPerson].InActive=0
	
	COMMIT
