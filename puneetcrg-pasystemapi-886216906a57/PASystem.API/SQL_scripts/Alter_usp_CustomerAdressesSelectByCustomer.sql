USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomerAdressesSelectByCustomer]    Script Date: 3/29/2019 5:31:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_CustomerAdressesSelectByCustomer] 
    @CustomerId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [CAddressId], CustomerAdresses.[CustomerId], CustomerAdresses.[AddressId], [IsDefault], [Purpose] ,AddressLine1 as Address, CountryName,StateName,CityName,Zipcode,Addresses.EmailId,Addresses.MobileNo,Addresses.TelephoneNo,Addresses.FaxNo,Countries.CountryId,States.StateId,Cities.CityId,Zipcodes.ZipcodeId,Addresses.AddressCode, Addresses.AddressCode +'('+ AddressLine1 +')' AS AddressLine
	FROM   [dbo].[CustomerAdresses] inner join Customers on Customers.CustomerId=CustomerAdresses.CustomerId inner join Addresses on Addresses.AddressId=CustomerAdresses.AddressId inner join Countries on Countries.CountryId=Addresses.CountryId inner join States on States.StateId=Addresses.StateId inner join Cities on Cities.CityId=Addresses.CityId inner join Zipcodes on Zipcodes.ZipcodeId=Addresses.ZipCodeId
	WHERE  (CustomerAdresses.[CustomerId] = @CustomerId) 

	COMMIT
