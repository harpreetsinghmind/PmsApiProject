USE [PASystem]
GO

/****** Object:  Table [dbo].[TaskList]    Script Date: 6/14/2019 1:06:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[TaskList](
	[Taskid] [bigint] IDENTITY(1,1) NOT NULL,
	[Task] [nvarchar](255) NOT NULL,
	[TaskModule] [nvarchar](50) NOT NULL,
	[TaskEntityId] [bigint] NULL,
	[TaskById] [bigint] NULL,
	[CreatedBy] [nvarchar](250) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](250) NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_TaskList] PRIMARY KEY CLUSTERED 
(
	[Taskid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


