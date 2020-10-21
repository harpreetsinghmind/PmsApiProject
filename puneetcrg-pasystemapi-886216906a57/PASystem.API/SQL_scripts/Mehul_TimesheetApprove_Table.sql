/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  Table [dbo].[TimesheetApprove]    Script Date: 7/23/2019 6:22:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TimesheetApprove](
	[ApproveId] [bigint] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [bigint] NOT NULL,
	[TimesheetId] [bigint] NOT NULL,
	[Notes] [nvarchar](150) NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[Approved] [bit] NULL,
 CONSTRAINT [PK_TimesheetApprove] PRIMARY KEY CLUSTERED 
(
	[ApproveId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TimesheetApprove]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetApprove_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employees] ([EmployeeId])
GO

ALTER TABLE [dbo].[TimesheetApprove] CHECK CONSTRAINT [FK_TimesheetApprove_Employees]
GO

ALTER TABLE [dbo].[TimesheetApprove]  WITH CHECK ADD  CONSTRAINT [FK_TimesheetApprove_Timesheet] FOREIGN KEY([TimesheetId])
REFERENCES [dbo].[Timesheet] ([Id])
GO

ALTER TABLE [dbo].[TimesheetApprove] CHECK CONSTRAINT [FK_TimesheetApprove_Timesheet]
GO

