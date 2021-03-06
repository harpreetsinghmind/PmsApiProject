USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomersInsert]    Script Date: 6/13/2019 2:14:52 PM ******/
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

	IF NOT EXISTS(select * from Customers where lower(CustomerCode) = LOWER(@CustomerCode) OR lower(CustomerName) = LOWER(@CustomerName))
	BEGIN
		IF NOT EXISTS(select * from Customers where (lower(Website) = LOWER(@Website) AND Website IS NOT NULL AND lower(Website) !='') AND ParentId IS NULL)
		BEGIN
			IF NOT EXISTS(select * from Customers where (lower(Website) = LOWER(@Website) AND Website IS NOT NULL AND lower(Website) !='') AND (ParentId <> @ParentId AND ParentId IS NOT NULL))
			BEGIN
				INSERT INTO [dbo].[Customers] ([CustomerName], [CustomerCode], [ShipingAddressId], [BillingAddressId], [BusinessTypeId], [FaxNo], [Website], [Notes], [Logo], [InActive], [IsDeleted], [ParentId], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate],[EmailId],[TelephoneNo],[MobileNo])
				SELECT @CustomerName, @CustomerCode, @ShipingAddressId, @BillingAddressId, @BusinessTypeId, @FaxNo, @Website, @Notes, @Logo, @InActive, @IsDeleted, @ParentId, @CreatedBy, @CreatedDate, @UpdatedBy, @UpdatedDate,@EmailId,
				@TelephoneNo,  @MobileNo 
	
				-- Begin Return Select <- do not remove
				SELECT  SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				SELECT -2
			END
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
               

