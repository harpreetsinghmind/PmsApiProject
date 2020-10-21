USE [PASystemTest]
GO

ALTER TABLE [dbo].[Timesheet] ADD [TaskId] [bigint] NULL, [SubTaskId] [bigint] NULL;
GO

ALTER TABLE [dbo].[Timesheet]  WITH NOCHECK ADD  CONSTRAINT [FK_Timesheet_ProjectSubTask] FOREIGN KEY([SubTaskId])
REFERENCES [dbo].[ProjectSubTask] ([Id])
GO

ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_Timesheet_ProjectSubTask]
GO

ALTER TABLE [dbo].[Timesheet]  WITH NOCHECK ADD  CONSTRAINT [FK_Timesheet_ProjectTask] FOREIGN KEY([TaskId])
REFERENCES [dbo].[ProjectTask] ([Id])
GO

ALTER TABLE [dbo].[Timesheet] CHECK CONSTRAINT [FK_Timesheet_ProjectTask]
GO
