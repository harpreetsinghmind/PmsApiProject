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

/****** Object:  StoredProcedure [dbo].[usp_CustomersUpdate]    Script Date: 4/29/2019 4:01:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_CustomersUpdate] 
    @CustomerId bigint,
    @CustomerName nvarchar(1000),
    @CustomerCode nvarchar(50) = NULL,
    @ShipingAddressId bigint = NULL,
    @BillingAddressId bigint = NULL,
    @BusinessTypeId bigint = NULL,
    @FaxNo nvarchar(50) = NULL,
    @Website nvarchar(200) = NULL,
    @Notes nvarchar(MAX) = NULL,
    @Logo nvarchar(300) = NULL,
    @InActive bit,
    @IsDeleted bit,
    @ParentId bigint = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@EmailId nvarchar(100) = NULL,
    @TelephoneNo nvarchar(50) = NULL,
    @MobileNo nvarchar(50) = NULL
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from Customers where lower(CustomerCode) = LOWER(@CustomerCode) and CustomerId <> @CustomerId)
	BEGIN
		IF NOT EXISTS(select * from Customers where lower(Website) = LOWER(@Website) and CustomerId <> @CustomerId)
		BEGIN
		UPDATE [dbo].[Customers]
		SET    [CustomerName] = @CustomerName, [CustomerCode] = @CustomerCode, [ShipingAddressId] = @ShipingAddressId, [BillingAddressId] = @BillingAddressId, [BusinessTypeId] = @BusinessTypeId, [FaxNo] = @FaxNo, [Website] = @Website, [Notes] = @Notes, [Logo] = @Logo, [InActive] = @InActive, [IsDeleted] = @IsDeleted, [ParentId] = @ParentId,  [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate,[EmailId]=@EmailId,[TelephoneNo]=@TelephoneNo,[MobileNo]=@MobileNo
		WHERE  [CustomerId] = @CustomerId
	
		-- Begin Return Select <- do not remove
		SELECT [CustomerId], [CustomerName], [CustomerCode], [ShipingAddressId], [BillingAddressId], [BusinessTypeId], [FaxNo], [Website], [Notes], [Logo], [InActive], [IsDeleted], [ParentId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate]
		FROM   [dbo].[Customers]
		WHERE  [CustomerId] = @CustomerId	
		-- End Return Select <- do not remove
		END
		ELSE
		BEGIN
		SELECT -2
		END
	END
	ELSE
	BEGIN
	SELECT -1
	END
	COMMIT
GO

