/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/
USE [PASystemTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerContactPersonAddressUpdate]    Script Date: 3/14/2019 4:30:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CustomerContactPersonAddressUpdate] 
    @CContactId bigint,
	@CustomerId bigint,
	@AddressId bigint,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[CustomerContactPerson]
	SET    [AddressId] = @AddressId
	WHERE  [CContactId] = @CContactId and [CustomerId] = @CustomerId
	
	-- Begin Return Select <- do not remove
	SELECT * FROM   [dbo].[SalesPerson]
	-- End Return Select <- do not remove

	COMMIT
GO
