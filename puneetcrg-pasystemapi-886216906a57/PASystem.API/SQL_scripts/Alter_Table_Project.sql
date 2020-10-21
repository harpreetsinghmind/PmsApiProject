Alter Table Projects Drop column [Type],[GroundUp],[BuildingContractCost],[SquareFootage]
Alter Table projects Add [ContactPersonId] bigint

ALTER TABLE [dbo].[Projects]  WITH CHECK ADD  CONSTRAINT [FK_Projects_CustomerContacts] FOREIGN KEY([ContactPersonId])
REFERENCES [dbo].[CustomerContacts] ([CContactId])

Drop Table ProjectVendor

Alter Table Offices Drop column [Address]
Alter Table Offices Add [AddressId] bigint

ALTER TABLE [dbo].[Offices]  WITH CHECK ADD  CONSTRAINT [FK_Offices_Address] FOREIGN KEY([AddressId])
REFERENCES [dbo].[Addresses] ([AddressId])