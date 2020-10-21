
CREATE TABLE [dbo].[BudgetCriteria](
	[BudgetId] [int] IDENTITY(1,1) NOT NULL,
	[Description] [varchar](100) NULL,
	[MinValue] [bigint] NULL,
	[MaxValue] [bigint] NULL,
 CONSTRAINT [PK_BudgetCriteria] PRIMARY KEY CLUSTERED 
(
	[BudgetId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[BudgetCriteria] ON 
GO
INSERT [dbo].[BudgetCriteria] ([BudgetId], [Description], [MinValue], [MaxValue]) VALUES (1, N'Under 1000', 0, 1000)
GO
INSERT [dbo].[BudgetCriteria] ([BudgetId], [Description], [MinValue], [MaxValue]) VALUES (2, N'1000-2000', 1000, 2000)
GO
INSERT [dbo].[BudgetCriteria] ([BudgetId], [Description], [MinValue], [MaxValue]) VALUES (3, N'2000-3000', 2000, 3000)
GO
INSERT [dbo].[BudgetCriteria] ([BudgetId], [Description], [MinValue], [MaxValue]) VALUES (4, N'Above 3000', 3000, 9223372036854775807)
GO
SET IDENTITY_INSERT [dbo].[BudgetCriteria] OFF
GO
