USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAllOfficeByCustomerIdForSelect]    Script Date: 3/22/2019 5:57:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[usp_GetAllOfficeByCustomerIdForSelect] 
	@CustomerId bigint
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT OfficeId, Name
	FROM 
		[dbo].[Offices]
	INNER JOIN 
		CustomerAdresses ON Offices.AddressId = CustomerAdresses.AddressId
	WHERE 
		Offices.InActive=0 
	AND 
		CustomerAdresses.CustomerId = @CustomerId
	
	COMMIT
