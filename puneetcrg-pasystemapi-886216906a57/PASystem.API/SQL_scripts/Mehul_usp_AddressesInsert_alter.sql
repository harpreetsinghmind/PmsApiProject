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

/****** Object:  StoredProcedure [dbo].[usp_AddressesInsert]    Script Date: 9/9/2019 2:14:21 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_AddressesInsert] 
    @AddressLine1 nvarchar(300) = NULL,
    @AddressLine2 nvarchar(300) = NULL,
    @CountryId bigint = NULL,
    @StateId bigint = NULL,
    @CityId bigint = NULL,
    @ZipCodeId bigint = NULL,
    @InActive bit,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
	@EmailId nvarchar(100) = NULL,
    @TelephoneNo nvarchar(50) = NULL,
    @MobileNo nvarchar(50) = NULL,
	@FaxNo nvarchar(50)=NULL,
	@AddressCode nvarchar(100)=null
AS 
	IF NOT EXISTS(select * from Addresses where LOWER(AddressCode) = LOWER(@AddressCode))
		BEGIN
			INSERT INTO [dbo].[Addresses] ([AddressLine1], [AddressLine2], [CountryId], [StateId], [CityId], [ZipCodeId], [InActive], [CreatedBy], [CreatedDate], [EmailId],[TelephoneNo],[MobileNo],[FaxNo],[AddressCode])
			SELECT @AddressLine1, @AddressLine2, @CountryId, @StateId, @CityId, @ZipCodeId, @InActive, @CreatedBy, @CreatedDate, @EmailID,@TelephoneNo,@MobileNo,@FaxNo,@AddressCode
	
			-- Begin Return Select <- do not remove
			SELECT SCOPE_IDENTITY()
			-- End Return Select <- do not remove
		END
	ELSE
		BEGIN
			SELECT -5
		END   
	COMMIT
GO

