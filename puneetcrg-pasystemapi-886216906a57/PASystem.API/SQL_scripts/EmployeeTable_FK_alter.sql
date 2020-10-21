ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Cities] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([CityId])
GO

ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Cities]
GO

ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Countries] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Countries] ([CountryId])
GO

ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Countries]
GO

ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_States] FOREIGN KEY([StateId])
REFERENCES [dbo].[States] ([StateId])
GO

ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_States]
GO

ALTER TABLE [dbo].[Employees]  WITH CHECK ADD  CONSTRAINT [FK_Employees_Zipcodes] FOREIGN KEY([ZipcodeId])
REFERENCES [dbo].[Zipcodes] ([ZipcodeId])
GO

ALTER TABLE [dbo].[Employees] CHECK CONSTRAINT [FK_Employees_Zipcodes]
GO