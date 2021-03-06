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
/****** Object:  Table [dbo].[SalesPerson]    Script Date: 2/25/2019 7:40:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SalesPerson](
	[SalesPersonId] [bigint] IDENTITY(1,1) NOT NULL,
	[STitle] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](100) NOT NULL,
	[MiddleName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [date] NULL,
	[Gender] [nvarchar](50) NULL,
	[WorkEmail] [nvarchar](100) NULL,
	[OtherEmail] [nvarchar](100) NULL,
	[MobileNo] [nvarchar](50) NULL,
	[TelephoneNo] [nvarchar](50) NULL,
	[InActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[Attribute1] [nvarchar](max) NULL,
	[Attribute2] [nvarchar](max) NULL,
	[Attribute3] [nvarchar](max) NULL,
	[Attribute4] [nvarchar](max) NULL,
	[Attribute5] [nvarchar](max) NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_SalesPerson] PRIMARY KEY CLUSTERED 
(
	[SalesPersonId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[SalesPerson] ADD  CONSTRAINT [DF_SalesPerson_InActive]  DEFAULT ((0)) FOR [InActive]
GO
