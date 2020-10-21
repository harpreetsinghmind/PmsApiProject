USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_SaveAttendance]    Script Date: 8/14/2019 4:26:04 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_SaveAttendance]
	@UserId bigint, @InTime DateTime, @OutTime DateTime, @InLatitude decimal(10,8), @InLongitude decimal(11,8),
	@OutLatitude decimal(10,8), @OutLongitude decimal(11,8), @InNotes nvarchar(50), @OutNotes nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	IF (@OutTime IS NOT NULL)
	BEGIN
		IF (@InTime > @OutTime)
		BEGIN
			BEGIN TRAN
				INSERT INTO [dbo].[Attendance] ([UserId], [InTime], [OutTime], [InLatitude], [InLongitude], [OutLatitude], [OutLongitude], [InNotes], [OutNotes])
					SELECT @UserId, @InTime, NULL, @InLatitude, @InLongitude, NULL, NULL, @InNotes, NULL
			COMMIT
		END
		ELSE
		BEGIN
			BEGIN TRAN
				UPDATE Attendance
					SET OutTime = @OutTime, OutLatitude = @OutLatitude, OutLongitude = @OutLongitude, OutNotes = @OutNotes
				WHERE InTime = @InTime;
			COMMIT
		END
	END
	ELSE
	BEGIN
		BEGIN TRAN
			INSERT INTO [dbo].[Attendance] ([UserId], [InTime], [OutTime], [InLatitude], [InLongitude], [OutLatitude], [OutLongitude], [InNotes], [OutNotes])
				SELECT @UserId, @InTime, @OutTime, @InLatitude, @InLongitude,@OutLatitude, @OutLongitude, @InNotes, @OutNotes
		COMMIT
	END

	--SELECT @InTime AS INTIME, @OutTime AS OUTTIME,
	--	CASE WHEN @InTime = @OutTime THEN 'Equals'
	--		 WHEN @InTime > @OutTime THEN 'In > Out'
	--		 WHEN @InTime < @OutTime THEN 'In < Out'
	--	END AS STRSTATUS,
	--	CASE WHEN CAST(@InTime AS DATETIME) = CAST(@OutTime AS DATETIME) THEN 'Equals'
	--		 WHEN CAST(@InTime AS DATETIME) > CAST(@OutTime AS DATETIME) THEN 'In > Out'
	--		 WHEN CAST(@InTime AS DATETIME) < CAST(@OutTime AS DATETIME) THEN 'In < Out'
	--	END AS DTSTATUS
	
END
GO
