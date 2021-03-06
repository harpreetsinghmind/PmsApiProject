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
/****** Object:  Table [dbo].[OrgStructureMapping]    Script Date: 2/1/2019 12:00:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrgStructureMapping](
	[OrgStructureMapId] [bigint] IDENTITY(1,1) NOT NULL,
	[ModuleName] [nvarchar](255) NOT NULL,
	[ModuleId] [bigint] NOT NULL,
	[OrgStructureId] [bigint] NOT NULL,
	[OrgSructureLevelId] [bigint] NOT NULL,
	[Attribute1] [nvarchar](255) NULL,
	[Attribute2] [nvarchar](255) NULL,
	[Attribute3] [nvarchar](255) NULL,
	[Attribute4] [nvarchar](255) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_OrgStructureMapping] PRIMARY KEY CLUSTERED 
(
	[OrgStructureMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrgStructureMapping]  WITH CHECK ADD  CONSTRAINT [FK_OrgStructureMapping_OrgStructure] FOREIGN KEY([OrgStructureId])
REFERENCES [dbo].[OrgStructure] ([OrgStructureId])
GO
ALTER TABLE [dbo].[OrgStructureMapping] CHECK CONSTRAINT [FK_OrgStructureMapping_OrgStructure]
GO
ALTER TABLE [dbo].[OrgStructureMapping]  WITH CHECK ADD  CONSTRAINT [FK_OrgStructureMapping_OrgStructureLevel] FOREIGN KEY([OrgSructureLevelId])
REFERENCES [dbo].[OrgStructureLevel] ([OrgStructureLevelId])
GO
ALTER TABLE [dbo].[OrgStructureMapping] CHECK CONSTRAINT [FK_OrgStructureMapping_OrgStructureLevel]
GO
