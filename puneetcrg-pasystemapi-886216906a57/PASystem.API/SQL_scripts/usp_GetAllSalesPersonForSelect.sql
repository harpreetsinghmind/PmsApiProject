USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllSalesPersonByCustomerIdForSelect]    Script Date: 3/22/2019 5:52:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create PROC [dbo].[usp_GetAllSalesPersonByCustomerIdForSelect] 
	@CustomerId bigint
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
	INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId 
	WHERE 
		[SalesPerson].InActive=0
		AND 
		[CustomerSalesPerson].CustomerId = @CustomerId
	
	COMMIT
