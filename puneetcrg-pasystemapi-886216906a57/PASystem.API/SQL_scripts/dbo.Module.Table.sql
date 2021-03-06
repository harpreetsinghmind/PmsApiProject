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
/****** Object:  Table [dbo].[Module]    Script Date: 3/28/2019 4:19:57 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Module](
	[ModuleId] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[InActive] [bit] NULL,
 CONSTRAINT [PK_Module] PRIMARY KEY CLUSTERED 
(
	[ModuleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Module] ON 

INSERT [dbo].[Module] ([ModuleId], [Name], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [InActive]) VALUES (5, N'Employee', NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Module] ([ModuleId], [Name], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [InActive]) VALUES (6, N'Customer', NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Module] ([ModuleId], [Name], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [InActive]) VALUES (7, N'Sales', NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[Module] ([ModuleId], [Name], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [InActive]) VALUES (8, N'Master', NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[Module] OFF
