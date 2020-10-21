USE [PASystem]
GO

/****** Object:  Table [dbo].[Attendance]    Script Date: 8/14/2019 4:16:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Attendance](
	[AttendId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NULL,
	[InTime] [datetime] NULL,
	[OutTime] [datetime] NULL,
	[TotalTime] [bigint] NULL,
	[InLatitude] [decimal](10, 8) NULL,
	[InLongitude] [decimal](11, 8) NULL,
	[OutLatitude] [decimal](10, 8) NULL,
	[OutLongitude] [decimal](11, 8) NULL,
	[InNotes] [nvarchar](50) NULL,
	[OutNotes] [nvarchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Attendance]  WITH CHECK ADD  CONSTRAINT [FK_Attendance_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[Attendance] CHECK CONSTRAINT [FK_Attendance_Users]
GO


/****** Object:  Trigger [dbo].[TRG_UpdateTotalTime]    Script Date: 8/14/2019 4:18:02 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TRG_UpdateTotalTime]
   ON [dbo].[Attendance]
   AFTER UPDATE AS 
BEGIN
	SET NOCOUNT ON;
	UPDATE A
	SET A.TotalTime = DATEDIFF(ss,D.InTime,I.OutTime)
	FROM Attendance A
		JOIN inserted I ON A.AttendId = I.AttendId
		JOIN deleted D ON A.AttendId = D.AttendId;
END
GO

ALTER TABLE [dbo].[Attendance] ENABLE TRIGGER [TRG_UpdateTotalTime]
GO

