/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonUpdateStatus]    Script Date: 3/1/2019 12:57:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_SalesPersonUpdateStatus] 
    @SalesPersonId bigint,
    @InActive bit
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	UPDATE [dbo].[SalesPerson]
	SET     [InActive] = @InActive
	WHERE  [SalesPersonId] = @SalesPersonId
	
	-- Begin Return Select <- do not remove
	SELECT [SalesPersonId], [STitle], [FirstName], [MiddleName], [LastName], [DOB], [Gender], [WorkEmail], [OtherEmail], [MobileNo], [TelephoneNo], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]
	FROM   [dbo].[SalesPerson]
	WHERE  [SalesPersonId] = @SalesPersonId	
	-- End Return Select <- do not remove

	COMMIT
GO

