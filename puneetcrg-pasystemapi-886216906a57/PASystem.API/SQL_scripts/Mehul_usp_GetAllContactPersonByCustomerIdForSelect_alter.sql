USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllContactPersonByCustomerIdForSelect]    Script Date: 7/17/2019 7:58:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROC [dbo].[usp_GetAllContactPersonByCustomerIdForSelect] 
	@CustomerId bigint
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT DISTINCT
		 [CustomerContacts].CContactId,
		 LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
		 CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))) as ContactPersonName
	FROM   
		[dbo].[CustomerContacts] 
	INNER JOIN [CustomerContactPerson] ON [CustomerContacts].CContactId = [CustomerContactPerson].CContactId 
	WHERE 
		[CustomerContacts].InActive=0
		AND 
		[CustomerContactPerson].CustomerId = @CustomerId
	
	COMMIT
