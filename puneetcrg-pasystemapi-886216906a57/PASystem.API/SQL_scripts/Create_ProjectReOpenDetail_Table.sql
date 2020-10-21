CREATE TABLE [dbo].[ProjectReOpenDetail](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[ReOpenDate] [datetime] NOT NULL,
	[Reason] [nvarchar](max) NOT NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ProjectReopenDetail] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProjectReOpenDetail]  WITH CHECK ADD  CONSTRAINT [FK_ProjectReopenDetail_Projects] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Projects] ([ProjectId])
GO

ALTER TABLE [dbo].[ProjectReOpenDetail] CHECK CONSTRAINT [FK_ProjectReopenDetail_Projects]
GO