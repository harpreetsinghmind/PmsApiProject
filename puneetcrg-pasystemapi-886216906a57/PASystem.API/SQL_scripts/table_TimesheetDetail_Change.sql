/*
   06 September 201917:06:31
   User: sa
   Server: LAPTOP-4OQRB9IH
   Database: PASystem
   Application: 
*/

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.TimesheetDetail
	DROP CONSTRAINT FK_TimesheetDetail_Timesheet
GO
ALTER TABLE dbo.Timesheet SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
BEGIN TRANSACTION
GO
CREATE TABLE dbo.Tmp_TimesheetDetail
	(
	Id bigint NOT NULL IDENTITY (1, 1),
	TimesheetId bigint NULL,
	Day datetime NOT NULL,
	WeekDay int NOT NULL,
	Detail nvarchar(MAX) NOT NULL,
	Status int NULL,
	CreatedBy nvarchar(250) NULL,
	CreatedDate datetime NULL,
	UpdatedBy nvarchar(250) NULL,
	UpdatedDate datetime NULL,
	Hours decimal(10, 2) NULL,
	BillingNote nvarchar(255) NULL,
	OHours decimal(10, 2) NULL
	)  ON [PRIMARY]
	 TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE dbo.Tmp_TimesheetDetail SET (LOCK_ESCALATION = TABLE)
GO
SET IDENTITY_INSERT dbo.Tmp_TimesheetDetail ON
GO
IF EXISTS(SELECT * FROM dbo.TimesheetDetail)
	 EXEC('INSERT INTO dbo.Tmp_TimesheetDetail (Id, TimesheetId, Day, WeekDay, Detail, Status, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate, Hours, BillingNote, OHours)
		SELECT Id, TimesheetId, Day, WeekDay, Detail, Status, CreatedBy, CreatedDate, UpdatedBy, UpdatedDate, CONVERT(decimal(10, 2), Hours), BillingNote, CONVERT(decimal(10, 2), OHours) FROM dbo.TimesheetDetail WITH (HOLDLOCK TABLOCKX)')
GO
SET IDENTITY_INSERT dbo.Tmp_TimesheetDetail OFF
GO
DROP TABLE dbo.TimesheetDetail
GO
EXECUTE sp_rename N'dbo.Tmp_TimesheetDetail', N'TimesheetDetail', 'OBJECT' 
GO
ALTER TABLE dbo.TimesheetDetail ADD CONSTRAINT
	PK_TimesheetDetail PRIMARY KEY CLUSTERED 
	(
	Id
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

GO
ALTER TABLE dbo.TimesheetDetail ADD CONSTRAINT
	FK_TimesheetDetail_Timesheet FOREIGN KEY
	(
	TimesheetId
	) REFERENCES dbo.Timesheet
	(
	Id
	) ON UPDATE  NO ACTION 
	 ON DELETE  NO ACTION 
	
GO
COMMIT
