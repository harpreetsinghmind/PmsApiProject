USE [PASystem]
GO

ALTER TABLE TaskList ADD DueDate datetime, UserId bigint, Status bit;
GO

ALTER TABLE TaskList ADD  CONSTRAINT [DF_TaskList_Status]  DEFAULT ((0)) FOR [Status]
GO
