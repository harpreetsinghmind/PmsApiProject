USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsSelect]    Script Date: 3/29/2019 6:07:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_GetAllCustomerContactForSelect] 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT 
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

	COMMIT
