USE [PASystem]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetAttendance]    Script Date: 8/14/2019 4:24:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[usp_GetAttendance]
	@UserId bigint, @ToDate DateTime	--@FromDate DateTime,
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsCheckIn AS BIT;
	DECLARE @StartDate AS DATETIME;
	DECLARE @FirstCheckIn AS DATETIME;
	DECLARE @LastCheckIn AS DATETIME;
	DECLARE @LastCheckOut AS DATETIME;

	SET @StartDate = (SELECT CAST(@ToDate AS DATE));
	SET @LastCheckIn = (SELECT top 1 InTime FROM Attendance order by InTime desc);
	SET @LastCheckOut = (SELECT top 1 OutTime FROM Attendance order by OutTime desc);

	-- SELECT @StartDate AS STARTDATE, @ToDate AS TODATE, @LastCheckIn AS LASTCHECKIN, @LastCheckOut AS LASTCHECKOUT;

	IF (CAST(@LastCheckIn AS DATE) < (CAST(@ToDate AS DATE))) OR (@LastCheckIn IS NULL)
	BEGIN
		--SELECT 'IF 1';
		SET @IsCheckIn = 0;
		SELECT AC.IsCheckedIn, AC.LastActionTime, A.* 
		FROM (SELECT @IsCheckIn AS AttendId, 0 AS IsCheckedIn, @LastCheckOut AS LastActionTime) AS AC
			LEFT JOIN Attendance A ON AC.AttendId = A.AttendId
				AND A.InTime >= @StartDate AND A.OutTime >= @ToDate;
	END
	ELSE IF (CAST(@LastCheckIn AS DATE) = (CAST(@ToDate AS DATE))) AND (CAST(@LastCheckOut AS DATE) < (CAST(@ToDate AS DATE))) 
	BEGIN
		--SELECT 'IF 2';
		SET @IsCheckIn = 1;
		SELECT @IsCheckIn AS IsCheckedIn, @LastCheckIn AS LastActionTime, 
			A.AttendId, A.UserId, A.InTime, A.OutTime,
			DATEADD(ms, (DATEDIFF(SS,@LastCheckIn, @ToDate)) * 1000,0) AS TotalTime,
			A.InLatitude, A.InLongitude, A.OutLatitude, A.OutLongitude, A.InNotes, A.OutNotes
		FROM  Attendance A
		WHERE A.InTime >= @StartDate
	END
	ELSE IF (CAST(@LastCheckIn AS DATE) = (CAST(@ToDate AS DATE))) AND (CAST(@LastCheckOut AS DATE) = (CAST(@ToDate AS DATE))) 
	BEGIN
		SET @FirstCheckIn = (SELECT TOP 1 InTime FROM Attendance WHERE InTime > @StartDate ORDER BY InTime);
		--SELECT 'IF 3';
		IF (@LastCheckIn > @LastCheckOut)
		BEGIN
			--SELECT 'IF 3.1';
			SET @IsCheckIn = 1;
			SELECT @IsCheckIn AS IsCheckedIn, @LastCheckIn AS LastActionTime,
				A.AttendId, A.UserId, A.InTime, A.OutTime,
				DATEADD(ms, (DATEDIFF(SS,@FirstCheckIn, @ToDate)) * 1000,0) AS TotalTime,
				A.InLatitude, A.InLongitude, A.OutLatitude, A.OutLongitude, A.InNotes, A.OutNotes
			FROM  Attendance A
			WHERE A.InTime = @LastCheckIn
		END
		ELSE
		BEGIN
			--SELECT 'IF 3.2 Else';
			SET @IsCheckIn = 0;
			SELECT @IsCheckIn AS IsCheckedIn, @LastCheckOut AS LastActionTime,
				A.AttendId, A.UserId, A.InTime, A.OutTime,
				DATEADD(ms, (DATEDIFF(SS,@FirstCheckIn, @ToDate)) * 1000,0) AS TotalTime,
				A.InLatitude, A.InLongitude, A.OutLatitude, A.OutLongitude, A.InNotes, A.OutNotes
			FROM  Attendance A
			WHERE A.OutTime = @LastCheckOut
		END
	END
END

-- SELECT @StartDate AS STARTDATE, @ToDate AS TODATE
GO
