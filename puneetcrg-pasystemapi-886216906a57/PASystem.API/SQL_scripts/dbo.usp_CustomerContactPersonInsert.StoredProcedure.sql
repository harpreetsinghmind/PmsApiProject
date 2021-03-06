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
/****** Object:  StoredProcedure [dbo].[usp_CustomerContactPersonInsert]    Script Date: 3/14/2019 4:30:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[usp_CustomerContactPersonInsert]
    @CContactId bigint,
    @CustomerId bigint,
	@AddressId bigint,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	INSERT INTO [dbo].[CustomerContactPerson] ([CContactId], [CustomerId], [AddressId] ,[CreatedBy], [CreatedDate])
	SELECT @CContactId, @CustomerId,@AddressId, @CreatedBy, @CreatedDate
	
	-- Begin Return Select <- do not remove
	SELECT  SCOPE_IDENTITY()
	-- End Return Select <- do not remove
     
	COMMIT
GO
