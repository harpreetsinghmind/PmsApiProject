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

/****** Object:  StoredProcedure [dbo].[usp_CustomersInsert]    Script Date: 4/1/2019 3:11:05 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomersInsert] 
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
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
	@EmailId nvarchar(100) = NULL,
    @TelephoneNo nvarchar(50) = NULL,
    @MobileNo nvarchar(50) = NULL
AS 
	BEGIN TRAN
	IF NOT EXISTS(select * from Customers where lower(CustomerCode) = LOWER(@CustomerCode) or lower(Website) = LOWER(@Website))
	BEGIN
	INSERT INTO [dbo].[Customers] ([CustomerName], [CustomerCode], [ShipingAddressId], [BillingAddressId], [BusinessTypeId], [FaxNo], [Website], [Notes], [Logo], [InActive], [IsDeleted], [ParentId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[EmailId],[TelephoneNo],[MobileNo])
	SELECT @CustomerName, @CustomerCode, @ShipingAddressId, @BillingAddressId, @BusinessTypeId, @FaxNo, @Website, @Notes, @Logo, @InActive, @IsDeleted, @ParentId, @CreatedBy, @CreatedDate, @UpdatedBy, @UpdatedDate,@EmailId,
    @TelephoneNo,  @MobileNo 
	
	-- Begin Return Select <- do not remove
	SELECT  SCOPE_IDENTITY()
	-- End Return Select <- do not remove
	END
	ELSE
	BEGIN
	SELECT -1
	END

	COMMIT
               

GO

