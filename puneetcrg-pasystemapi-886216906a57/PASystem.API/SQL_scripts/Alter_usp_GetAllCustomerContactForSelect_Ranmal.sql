USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllCustomerContactForSelect]    Script Date: 4/4/2019 12:26:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_GetAllCustomerContactForSelect] 
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
	WHERE 
		[CustomerContacts].InActive=0

	COMMIT
