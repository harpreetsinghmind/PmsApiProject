/****** Object:  Table [dbo].[ProjectTask]    Script Date: 17-12-2019 12:20:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProjectTask](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[SubPhaseId] [bigint] NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NOT NULL,
	[TargetCost] [numeric](18, 2) NULL,
	[VendorTarget] [numeric](18, 2) NULL,
	[LaborTarget] [numeric](18, 2) NULL,
	[BillingType] [int] NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[ActualDate] [datetime] NULL,
	[EstimatedStartDate] [datetime] NULL,
 CONSTRAINT [PK_ProjectTask] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProjectTask]  WITH NOCHECK ADD  CONSTRAINT [FK_ProjectTask_ProjectSubPhase] FOREIGN KEY([SubPhaseId])
REFERENCES [dbo].[ProjectSubPhase] ([Id])
GO

ALTER TABLE [dbo].[ProjectTask] CHECK CONSTRAINT [FK_ProjectTask_ProjectSubPhase]
GO
