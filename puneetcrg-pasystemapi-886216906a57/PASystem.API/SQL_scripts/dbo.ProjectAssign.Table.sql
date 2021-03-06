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
/****** Object:  Table [dbo].[ProjectAssign]    Script Date: 5/27/2019 7:35:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProjectAssign](
	[AssignId] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[RoleId] [bigint] NOT NULL,
	[WorkingHours] [int] NULL,
	[BillableCost] [int] NULL,
	[InActive] [bit] NULL,
	[Assigned] [bit] NULL,
 CONSTRAINT [PK_ProjectAssign] PRIMARY KEY CLUSTERED 
(
	[AssignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ProjectAssign]  WITH CHECK ADD  CONSTRAINT [FK_ProjectAssign_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO
ALTER TABLE [dbo].[ProjectAssign] CHECK CONSTRAINT [FK_ProjectAssign_Employees]
GO
ALTER TABLE [dbo].[ProjectAssign]  WITH CHECK ADD  CONSTRAINT [FK_ProjectAssign_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([ProjectId])
GO
ALTER TABLE [dbo].[ProjectAssign] CHECK CONSTRAINT [FK_ProjectAssign_Projects]
GO
