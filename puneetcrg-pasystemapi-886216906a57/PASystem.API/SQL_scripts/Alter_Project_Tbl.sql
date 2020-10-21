ALTER TABLE Projects
DROP CONSTRAINT [FK_Projects_Offices];

ALTER TABLE Projects
ADD CONSTRAINT [FK_Projects_Offices]
FOREIGN KEY (OfficeId) REFERENCES [dbo].[Addresses] ([AddressId]);
