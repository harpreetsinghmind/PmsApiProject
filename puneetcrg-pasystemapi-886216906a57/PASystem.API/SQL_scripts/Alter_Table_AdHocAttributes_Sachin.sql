USE [PASystem]
GO

ALTER TABLE AdHocAttributes ADD ListDisplay bit;
GO

ALTER TABLE AdHocAttributes ADD  CONSTRAINT [DF_AdHocAttributes_ListDisplay]  DEFAULT ((1)) FOR [ListDisplay]
GO
