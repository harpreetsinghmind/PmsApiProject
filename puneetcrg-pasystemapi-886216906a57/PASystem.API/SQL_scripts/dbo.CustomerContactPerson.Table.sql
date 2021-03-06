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
/****** Object:  Table [dbo].[CustomerContactPerson]    Script Date: 3/14/2019 4:30:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerContactPerson](
	[CContactPersonId] [bigint] IDENTITY(1,1) NOT NULL,
	[AddressId] [bigint] NULL,
	[CContactId] [bigint] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_CustomerContactPerson] PRIMARY KEY CLUSTERED 
(
	[CContactPersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerContactPerson]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContactPerson_CustomerContacts] FOREIGN KEY([CContactId])
REFERENCES [dbo].[CustomerContacts] ([CContactId])
GO
ALTER TABLE [dbo].[CustomerContactPerson] CHECK CONSTRAINT [FK_CustomerContactPerson_CustomerContacts]
GO
ALTER TABLE [dbo].[CustomerContactPerson]  WITH CHECK ADD  CONSTRAINT [FK_CustomerContactPerson_Customers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO
ALTER TABLE [dbo].[CustomerContactPerson] CHECK CONSTRAINT [FK_CustomerContactPerson_Customers]
GO
