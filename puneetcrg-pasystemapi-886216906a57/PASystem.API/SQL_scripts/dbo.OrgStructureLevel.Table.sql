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
/****** Object:  Table [dbo].[OrgStructureLevel]    Script Date: 3/4/2019 12:58:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrgStructureLevel](
	[OrgStructureLevelId] [bigint] IDENTITY(1,1) NOT NULL,
	[OrgStructureId] [bigint] NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](max) NULL,
	[InActive] [bit] NOT NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[Notes] [nvarchar](max) NULL,
 CONSTRAINT [PK_OrgStructureLevel] PRIMARY KEY CLUSTERED 
(
	[OrgStructureLevelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[OrgStructureLevel] ADD  CONSTRAINT [DF_OrgStructureLevel_InActive]  DEFAULT ((0)) FOR [InActive]
GO
ALTER TABLE [dbo].[OrgStructureLevel]  WITH CHECK ADD  CONSTRAINT [FK_OrgStructureLevel_OrgStructure] FOREIGN KEY([OrgStructureId])
REFERENCES [dbo].[OrgStructure] ([OrgStructureId])
GO
ALTER TABLE [dbo].[OrgStructureLevel] CHECK CONSTRAINT [FK_OrgStructureLevel_OrgStructure]
GO
