SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_TimesheetUpdate] 
	@TimesheetId BIGINT,
    @ProjectId BIGINT,
	@ProjectPhaseId BIGINT,
    @ProjectSubPhaseId BIGINT,
	@ProjectTaskId BIGINT,
	@ProjectSubTaskId BIGINT,
    @EmployeeId BIGINT,
	@Billing INT,
    @Day1 DECIMAL(10,2),
    @Day2 DECIMAL(10,2),
    @Day3 DECIMAL(10,2),
    @Day4 DECIMAL(10,2),
    @Day5 DECIMAL(10,2),
    @Day6 DECIMAL(10,2),
    @Day7 DECIMAL(10,2),
	@ODay1 DECIMAL(10,2),
    @ODay2 DECIMAL(10,2),
    @ODay3 DECIMAL(10,2),
    @ODay4 DECIMAL(10,2),
    @ODay5 DECIMAL(10,2),
    @ODay6 DECIMAL(10,2),
    @ODay7 DECIMAL(10,2),
    @DDay1 DATETIME,
    @DDay2 DATETIME,
    @DDay3 DATETIME,
    @DDay4 DATETIME,
    @DDay5 DATETIME,
    @DDay6 DATETIME,
    @DDay7 DATETIME,
    @CreatedBy NVARCHAR(250) = NULL,
	@UserEmitted BIT = 0
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	
	IF EXISTS(SELECT * FROM Timesheet WHERE Id = @TimesheetId)
	BEGIN
		IF	(@Day1 > 0 OR @Day2 > 0 OR @Day3 > 0 OR @Day4 > 0 OR @Day5 > 0 OR @Day6 > 0 OR @Day7 > 0) OR
			(@ODay1 > 0 OR @ODay2 > 0 OR @ODay3 > 0 OR @ODay4 > 0 OR @ODay5 > 0 OR @ODay6 > 0 OR @ODay7 > 0)
		BEGIN
			UPDATE [dbo].[Timesheet]
			   SET [EmployeeId] = @EmployeeId
				  ,[Billing] = @Billing
				  ,[ProjectId] = @ProjectId
				  ,[PhaseId] = @ProjectPhaseId
				  ,[SubPhaseId] = @ProjectSubPhaseId
				  ,[TaskId] = @ProjectTaskId
				  ,[SubTaskId] = @ProjectSubTaskId
				  ,[Day1] = ISNULL(@Day1,0.00)
				  ,[Day2] = ISNULL(@Day2,0.00)
				  ,[Day3] = ISNULL(@Day3,0.00)
				  ,[Day4] = ISNULL(@Day4,0.00)
				  ,[Day5] = ISNULL(@Day5,0.00)
				  ,[Day6] = ISNULL(@Day6,0.00)
				  ,[Day7] = ISNULL(@Day7,0.00)
				  ,[ODay1] = ISNULL(@ODay1,0.00)
				  ,[ODay2] = ISNULL(@ODay2,0.00)
				  ,[ODay3] = ISNULL(@ODay3,0.00)
				  ,[ODay4] = ISNULL(@ODay4,0.00)
				  ,[ODay5] = ISNULL(@ODay5,0.00)
				  ,[ODay6] = ISNULL(@ODay6,0.00)
				  ,[ODay7] = ISNULL(@ODay7,0.00)
				  ,[DDay1] = @DDay1
				  ,[DDay2] = @DDay2
				  ,[DDay3] = @DDay3
				  ,[DDay4] = @DDay4
				  ,[DDay5] = @DDay5
				  ,[DDay6] = @DDay6
				  ,[DDay7] = @DDay7
				  ,[UpdatedBy] = @CreatedBy
				  ,[UpdatedDate] = GETDATE()
			 WHERE Id = @TimesheetId
	
			-- Begin Return Select <- do not remove
			SELECT @TimesheetId
		END
		ELSE
			DELETE FROM Timesheet WHERE Id = @TimesheetId
	END
	ELSE IF @UserEmitted = 1 AND 
			(@Day1 > 0 OR @Day2 > 0 OR @Day3 > 0 OR @Day4 > 0 OR @Day5 > 0 OR @Day6 > 0 OR @Day7 > 0 OR
			 @ODay1 > 0 OR @ODay2 > 0 OR @ODay3 > 0 OR @ODay4 > 0 OR @ODay5 > 0 OR @ODay6 > 0 OR @ODay7 > 0)
		SELECT -2
	ELSE
	BEGIN
		INSERT INTO [dbo].[Timesheet]
           ([EmployeeId]
		   ,[Billing]
           ,[ProjectId]
           ,[PhaseId]
           ,[SubPhaseId]
		   ,[TaskId]
		   ,[SubTaskId]
           ,[Day1]
           ,[Day2]
           ,[Day3]
           ,[Day4]
           ,[Day5]
           ,[Day6]
           ,[Day7]
		   ,[ODay1]
           ,[ODay2]
           ,[ODay3]
           ,[ODay4]
           ,[ODay5]
           ,[ODay6]
           ,[ODay7]
           ,[DDay1]
           ,[DDay2]
           ,[DDay3]
           ,[DDay4]
           ,[DDay5]
           ,[DDay6]
           ,[DDay7]
           ,[CreatedBy]
           ,[CreatedDate])
		VALUES
           (@EmployeeId
		   ,@Billing
           ,@ProjectId
           ,@ProjectPhaseId
           ,@ProjectSubPhaseId
		   ,@ProjectTaskId
		   ,@ProjectSubTaskId
           ,ISNULL(@Day1,0.00)
           ,ISNULL(@Day2,0.00)
           ,ISNULL(@Day3,0.00)
           ,ISNULL(@Day4,0.00)
           ,ISNULL(@Day5,0.00)
           ,ISNULL(@Day6,0.00)
           ,ISNULL(@Day7,0.00)
		   ,ISNULL(@ODay1,0.00)
           ,ISNULL(@ODay2,0.00)
           ,ISNULL(@ODay3,0.00)
           ,ISNULL(@ODay4,0.00)
           ,ISNULL(@ODay5,0.00)
           ,ISNULL(@ODay6,0.00)
           ,ISNULL(@ODay7,0.00)
           ,@DDay1
           ,@DDay2
           ,@DDay3
           ,@DDay4
           ,@DDay5
           ,@DDay6
           ,@DDay7
           ,@CreatedBy
           ,GETDATE())

		SELECT SCOPE_IDENTITY()	
	END
                   
	COMMIT

GO
------------------------------------------------------------------------------------------------------------------------------------

INSERT INTO Permissions (Permission, InActive, CreatedBy, CreatedDate)
SELECT 'EDIT_PRIMARY_MANAGER',0,'',GETDATE()
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_TimesheetDetailDelete] 
    @TimesheetDetailId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

		DECLARE @timesheetId BIGINT,
				@WeekDay INT
		SELECT 
			@timesheetId = TimesheetId,
			@WeekDay = WeekDay 
		FROM 
			TimesheetDetail 
		WHERE 
			Id = @TimesheetDetailId

		DELETE 
		FROM 
			[dbo].[TimesheetDetail]
		WHERE  
			Id = @TimesheetDetailId


		UPDATE Timesheet 
			SET Day1 = CASE 
						WHEN @WeekDay = 1 THEN  (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 1)
						ELSE Day1
					END,
				Day2 = CASE 
						WHEN @WeekDay = 2 THEN  (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 2)
						ELSE Day2
					END,
				Day3 = CASE 
						WHEN @WeekDay = 3 THEN  (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 3)
						ELSE Day3
					END,
				Day4 = CASE 
						WHEN @WeekDay = 4 THEN  (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 4)
						ELSE Day4
					END,
				Day5 = CASE 
						WHEN @WeekDay = 5 THEN  (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 5)
						ELSE Day5
					END,
				Day6 = CASE 
						WHEN @WeekDay = 6 THEN (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 6)
						ELSE Day6
					END,
				Day7 = CASE 
						WHEN @WeekDay = 7 THEN (SELECT ISNULL(SUM(TimesheetDetail.Hours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 7)
						ELSE Day7
					END
			WHERE Id = @TimesheetId
		
		UPDATE Timesheet 
			SET ODay1 = CASE 
						WHEN @WeekDay = 1 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 1)
						ELSE ODay1
					END,
				ODay2 = CASE 
						WHEN @WeekDay = 2 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 2)
						ELSE ODay2
					END,
				ODay3 = CASE 
						WHEN @WeekDay = 3 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 3)
						ELSE ODay3
					END,
				ODay4 = CASE 
						WHEN @WeekDay = 4 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 4)
						ELSE ODay4
					END,
				ODay5 = CASE 
						WHEN @WeekDay = 5 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 5)
						ELSE ODay5
					END,
				ODay6 = CASE 
						WHEN @WeekDay = 6 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 6)
						ELSE ODay6
					END,
				ODay7 = CASE 
						WHEN @WeekDay = 7 THEN  (SELECT ISNULL(SUM(TimesheetDetail.OHours),0) FROM TimesheetDetail WHERE TimesheetId = @TimesheetId AND WeekDay = 7)
						ELSE ODay7
					END
			WHERE Id = @TimesheetId
		

	COMMIT
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_UpdateAutoEmailSetting]
	@ProjectId BIGINT, @DSR bit, @WSR bit, @RPT char, @ContactPersonIds NVARCHAR(MAX)
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @Query NVARCHAR(MAX)

	BEGIN TRAN

	UPDATE Projects SET DSR = @DSR, WSR = @WSR WHERE ProjectId = @ProjectId
	SELECT @@ROWCOUNT

	--IF @DSR = 0
	--	UPDATE ProjectContactPerson SET EmailDSR = 0 WHERE ProjectId = @ProjectId
	--ELSE 
	IF @RPT = 'D' AND LEN(@ContactPersonIds) > 0
	BEGIN
		EXEC('UPDATE ProjectContactPerson SET EmailDSR = 1 WHERE CustomerContactID IN (' + @ContactPersonIds + ')')
		EXEC('UPDATE ProjectContactPerson SET EmailDSR = 0 WHERE CustomerContactID NOT IN (' + @ContactPersonIds + ')')
	END

	--IF @WSR = 0
	--	UPDATE ProjectContactPerson SET EmailWSR = 0 WHERE ProjectId = @ProjectId
	--ELSE 
	IF @RPT = 'W' AND LEN(@ContactPersonIds) > 0
	BEGIN
		EXEC('UPDATE ProjectContactPerson SET EmailWSR = 1 WHERE CustomerContactID IN (' + @ContactPersonIds + ')')
		EXEC('UPDATE ProjectContactPerson SET EmailWSR = 0 WHERE CustomerContactID NOT IN (' + @ContactPersonIds + ')')
	END

	COMMIT;

END
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectGetAll]
	@PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null
AS   
	SET NOCOUNT ON   
 
	DECLARE @SQLStatement varchar(MAX)  
	DECLARE @CountStatement varchar(MAX)  
     
	DECLARE @sqlBasic1 NVARCHAR(MAX)  
	DECLARE @sqlBasic2 NVARCHAR(MAX)  
  
	SET @sqlBasic1 ='  
		SELECT   
		Projects.[ProjectId],  
		[Projects].[Name] AS ProjectName,   
		[Code] AS ProjectCode,   
		[ShortDescription] AS ShortDesc,   
		[Description] AS Notes,   
		[Customers].CustomerName,   
		[Projects].CustomerId,   
		[Projects].PaymentType,  
		[Projects].WorkingDays,  
		[ProjectTypes].Name AS ProjectType,   
		[ProjectTypes].ProjectTypeId,   
		[ProjectSources].Name AS ProjectSource,  
		[ProjectSources].ProjectSourceId,   
		[Addresses].AddressCode AS Office,   
		[Projects].OfficeId,  
		[Employees].EmployeeId,   
		[Projects].Locked,   
		[Projects].[PlannedStartDate],  
		[Projects].[StartDate],  
		[Projects].[EndDate],  
		[Projects].[ActualDate],   
		(SELECT(LTRIM(RTRIM(ISNULL(E.FirstName, ''''))) + '' ''+  
		CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''''))) = ''''  
		 THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '''')))  
		 ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''''))) + '' ''  
		END +  
		LTRIM(RTRIM(ISNULL(E.LastName, '''')))) FROM Employees E WHERE E.EmployeeId = Projects.ManagerId) AS ProjectManager,  
		[Projects].ManagerId,  
		(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''''))) + '' ''+  
		CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) = ''''  
		 THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '''')))  
		 ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''''))) + '' ''  
		END +  
		LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '''')))) AS SalesPerson,  
		[Projects].SalesPersonId,  
		ContactPerson = ''['' + COALESCE(STUFF((SELECT '',{"id":'' + CAST(PCP.CustomerContactID AS VARCHAR(MAX)) + '',"text":"'' + CC.FirstName + '' '' + CC.LastName + 
								''","DSR":'' + CAST(PCP.EmailDSR AS VARCHAR(MAX)) + '',"WSR":'' + CAST(PCP.EmailWSR AS VARCHAR(MAX)) + ''}''
			FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
			WHERE PCP.ProjectId = Projects.ProjectId
			FOR XML PATH('''')),1,1,N''''),N'''') + '']'',
		ContactPersonId = COALESCE(STUFF((SELECT '','' + CAST(PCP.CustomerContactID AS VARCHAR(MAX))
			FROM ProjectContactPerson PCP WHERE PCP.ProjectId = Projects.ProjectId
			FOR XML PATH('''')),1,1,N''''),N''''),
		[Projects].inActive,  
		[Projects].CreatedDate AS Created,  
		CASE [Projects].[InActive]  
		  WHEN 0 THEN ''Active''  
		  WHEN 1 THEN ''InActive''  
		END as Status,  
		CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
		THEN ''NOT-STARTED''  
		WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
		THEN ''OPEN''  
		ELSE ''CLOSED''  
		END AS ProStatus,  
		ISNULL((SELECT SUM(Budget) FROM [dbo].[ProjectPhase] WHERE [ProjectPhase].ProjectId = [Projects].ProjectId),0) As ProjectBudget,
		[Projects].[DSR],
		[Projects].[WSR]
		'  
  
		--(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''''))) + '' ''+  
		--CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) = ''''  
		-- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '''')))  
		-- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''''))) + '' ''  
		--END +  
		--LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '''')))) AS ContactPerson,  
		--[Projects].ContactPersonId,   

	SET @sqlBasic2=' FROM [dbo].[Projects]   
			LEFT OUTER JOIN Customers on Customers.CustomerId=Projects.CustomerId   
			LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=Projects.ProjectTypeId   
			LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=Projects.ProjectSourceId  
			LEFT OUTER JOIN Addresses on Addresses.AddressId=Projects.OfficeId   
			LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=Projects.SalesPersonId   
		'
		--LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=Projects.ContactPersonId   

	IF @UserType = 2
	BEGIN  
   
		SELECT @SQLStatement = 'SELECT DISTINCT ProjectAssign.RoleId, x.* FROM (  
			(' + @sqlBasic1 + @sqlBasic2 +   
			' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId    
			WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')  
			UNION  
			(' + @sqlBasic1 + @sqlBasic2 +   
			' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId  
			INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId  
			WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')  
			) x LEFT JOIN ProjectAssign ON ProjectAssign.ProjectId = x.ProjectId AND ProjectAssign.EmployeeId = x.EmployeeId  
			WHERE '+ ISNULL(@Condition,'1=1') + ' ORDER BY x.' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+   
		   ' ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'  
  
		SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount FROM(  
			SELECT DISTINCT * FROM (  
			(' + @sqlBasic1 + @sqlBasic2 +   
			' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId    
			WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')  
			UNION  
			(' + @sqlBasic1 + @sqlBasic2 +   
			' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId  
			INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId  
			WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')  
			) x  WHERE '+ ISNULL(@Condition,'1=1') + ') y'  
	END

	IF @UserType = 1
	BEGIN
  
		SELECT @SQLStatement = 'SELECT DISTINCT -1 AS RoleId, x.* FROM   
			(' + @sqlBasic1 + @sqlBasic2 +   
			' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId   
			) x  WHERE '+ ISNULL(@Condition,'1=1') + ' ORDER BY x.' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+   
			'  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'  
  
		SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount ' + @sqlBasic2 +
			' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId'
	END

	IF @UserType = 3
	BEGIN
		SELECT @SQLStatement = 'SELECT DISTINCT -1 AS RoleId, x.* FROM   
			(' + @sqlBasic1 + @sqlBasic2 +   
			' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId
			  WHERE [Projects].ProjectId IN (SELECT DISTINCT ProjectId FROM ProjectContactPerson WHERE CustomerContactID = ' + CAST(@UserId AS VARCHAR(MAX)) + ')
			) x  WHERE '+ ISNULL(@Condition,'1=1') + ' ORDER BY x.' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+   
			'  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'  
			-- WHERE [Projects].ContactPersonId = ' + CAST(@UserId AS VARCHAR(MAX)) + '
			-- WHERE [Projects].CustomerId IN (SELECT CustomerId FROM CustomerContactPerson WHERE CContactId = ' + CAST(@UserId AS VARCHAR(MAX)) + ')
		
		SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount ' + @sqlBasic2 +
			' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId
			  WHERE [Projects].ContactPersonId = ' + CAST(@UserId AS VARCHAR(MAX))
	END

	--PRINT(@SQLStatement)
	--PRINT(@CountStatement)

	EXEC(@SQLStatement)  
	EXEC(@CountStatement)  
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[usp_DailyStatusReport]  
	@ProjectId BIGINT, @ReportDate DATETIME  
AS  
BEGIN  
	SET NOCOUNT ON;  
   
	WITH ProjectEmps AS  
	(  
	 SELECT PA.ProjectId, PA.EmployeeId, E.FirstName + ' ' + E.LastName AS Employee,
			PA.ReportingTo AS ManagerId, ME.FirstName + ' ' + ME.LastName AS ManagerName, ME.PersonalEmail AS ManagerEmail
		FROM ProjectAssign PA  
		 JOIN Employees E ON PA.EmployeeId = E.EmployeeId AND (E.InActive = 0 OR (E.InActive = 1 AND CONVERT(Date,E.InActiveDate) >= CONVERT(VARCHAR, @ReportDate)))
		 JOIN Employees ME ON PA.ReportingTo = ME.EmployeeId
		WHERE PA.ProjectId = @ProjectId
		AND (PA.InActive = 0 OR (PA.InActive = 1 AND CONVERT(Date,PA.InActiveDate) >= CONVERT(VARCHAR, @ReportDate)))
		AND (PA.Assigned = 1 OR (PA.Assigned = 0 AND CONVERT(Date,PA.UnAssignDate) >= CONVERT(VARCHAR, @ReportDate)))
	)
	,
	TimesheetData AS  
	(  
	  SELECT T.EmployeeId, --, TD.Detail,  
			PP.Name AS Phase, PSP.Name AS SubPhase, PT.Name AS Task, ISNULL(PST.Name,'') AS SubTask,  
			CASE WHEN T.SubTaskId IS NOT NULL THEN  
			(SELECT TaskStatus FROM fn_GetTodaysStatus(PST.EndDate, PST.ActualDate))  
			ELSE  
			(SELECT TaskStatus FROM fn_GetTodaysStatus(PT.EndDate, PT.ActualDate))  
			END AS TaskStatus,
			CASE WHEN (CONVERT(date,T.DDay1) = CONVERT(date,@ReportDate)) THEN T.Day1
				WHEN (CONVERT(date,T.DDay2) = CONVERT(date,@ReportDate)) THEN T.Day2
				WHEN (CONVERT(date,T.DDay3) = CONVERT(date,@ReportDate)) THEN T.Day3
				WHEN (CONVERT(date,T.DDay4) = CONVERT(date,@ReportDate)) THEN T.Day4
				WHEN (CONVERT(date,T.DDay5) = CONVERT(date,@ReportDate)) THEN T.Day5
				WHEN (CONVERT(date,T.DDay6) = CONVERT(date,@ReportDate)) THEN T.Day6
			END AS TotalHrs
	-- FROM TimesheetDetail TD  
	--JOIN Timesheet T ON TD.TimesheetId = T.Id AND T.ProjectId = @ProjectId
	  FROM Timesheet T  
	   JOIN ProjectPhase PP ON PP.Id = T.PhaseId  
	   JOIN ProjectSubPhase PSP ON T.SubPhaseId = PSP.Id  
	   JOIN ProjectTask PT ON T.TaskId = PT.Id  
	   LEFT JOIN ProjectSubTask PST ON T.SubTaskId = PST.Id  
	  --WHERE CONVERT(date,TD.Day) = CONVERT(date,@ReportDate) AND TD.Hours > 0  
	  WHERE T.ProjectId = @ProjectId AND
		((CONVERT(date,T.DDay1) = CONVERT(date,@ReportDate) AND T.Day1 > 0) OR (CONVERT(date,T.DDay2) = CONVERT(date,@ReportDate) AND T.Day2 > 0) OR
		 (CONVERT(date,T.DDay3) = CONVERT(date,@ReportDate) AND T.Day3 > 0) OR (CONVERT(date,T.DDay4) = CONVERT(date,@ReportDate) AND T.Day4 > 0) OR
		 (CONVERT(date,T.DDay5) = CONVERT(date,@ReportDate) AND T.Day5 > 0) OR (CONVERT(date,T.DDay6) = CONVERT(date,@ReportDate) AND T.Day5 > 0) OR
		 (CONVERT(date,T.DDay6) = CONVERT(date,@ReportDate) AND T.Day6 > 0))
	 )
	 SELECT PE.ProjectId, PE.EmployeeId, PE.Employee, 
			PE.ManagerId, PE.ManagerName, PE.ManagerEmail,
			/*TDT.Detail,*/ 
			TDT.TaskStatus, TDT.Phase, TDT.SubPhase, TDT.Task, TDT.SubTask,
			ISNULL(TDT.TotalHrs,0.00) AS TotalHrs
	 FROM ProjectEmps PE  
	  LEFT JOIN TimesheetData TDT ON PE.EmployeeId = TDT.EmployeeId  
  
	--SELECT Name AS ProjectName, ManagerId AS PM FROM Projects WHERE ProjectId = @ProjectId  
  
	 SELECT T.EmployeeId, TD.Detail FROM TimesheetDetail TD   
	  JOIN Timesheet T ON T.Id = TD.TimesheetId  
	 WHERE CONVERT(date,TD.Day) = CONVERT(date,@ReportDate) AND T.ProjectId = @ProjectId  
	 --ORDER BY T.EmployeeId

	SELECT	CC.FirstName + ' ' + CC.LastName AS 'Name', CC.WorkEmail AS 'Email'
	FROM	CustomerContacts CC
	JOIN	ProjectContactPerson PCP ON CC.CContactId = PCP.CustomerContactID AND PCP.ProjectId = @ProjectId AND PCP.EmailDSR = 1
	JOIN	Projects P ON PCP.ProjectId = P.ProjectId AND P.DSR = 1
 
END
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_WeeklyStatusReport]
	@ProjectId BIGINT, @DDay1 DATETIME, @DDay6 DATETIME
AS
BEGIN
	SET NOCOUNT ON;

	SET @DDay1 = CONVERT(date,@DDay1)
	SET @DDay6 = CONVERT(date,@DDay6)

	DECLARE @ProjectTasks TABLE (PhLevel INT, ParentId BIGINT, Id BIGINT, Name varchar(max), PSDate DATETIME, PEDate DATETIME, ASDate DATETIME, AEDate DATETIME)
	INSERT INTO @ProjectTasks
	EXEC usp_ProjectPhaseLevelsDuration @ProjectId

	DECLARE @Owner TABLE (EmployeeId BIGINT, EmpName VARCHAR(MAX), ManagerId BIGINT, ManagerName VARCHAR(MAX), ManagerEmail VARCHAR(MAX), SubTaskId BIGINT, TaskId BIGINT)
	INSERT INTO @Owner
	SELECT PA.EmployeeId, E.FirstName AS EmpName, 
			PA.ReportingTo AS ManagerId, ME.FirstName + ' ' + ME.LastName AS ManagerName, ME.PersonalEmail AS ManagerEmail, 
			ISNULL(T.SubTaskId,0) AS SubTaskId, ISNULL(T.TaskId,0) AS TaskId
	FROM ProjectAssign PA
		JOIN Employees E ON E.EmployeeId = PA.EmployeeId
		JOIN Employees ME ON ME.EmployeeId = PA.ReportingTo
		LEFT JOIN Timesheet T ON T.EmployeeId = PA.EmployeeId AND T.ProjectId = PA.ProjectId AND T.DDay1 = @DDay1 AND T.DDay6 = @DDay6
	WHERE PA.ProjectId = @ProjectId

	SELECT	T.PhLevel, T.ParentId, T.Id,
			PP.Name + ' - ' + PSP.Name + ' - ' + PT.Name + ' - ' + T.Name Name,
			CASE
				WHEN T.ASDate IS NOT NULL AND T.AEDate IS NULL AND T.PEDate <= @DDay6
					THEN 'Delayed,In Progress'
				WHEN T.ASDate IS NULL AND T.PSDate <= @DDay6
					THEN 'Delayed,Not Started'
				WHEN T.ASDate IS NOT NULL AND T.ASDate > T.PSDate AND (T.ASDate >= @DDay1 AND T.ASDate <= @DDay6) AND T.AEDate IS NULL
					THEN 'Late Start,In Progress'
				WHEN T.AEDate IS NOT NULL AND T.AEDate > T.PEDate
					THEN 'Late Finish,Completed'
				WHEN T.AEDate IS NULL AND T.ASDate IS NOT NULL AND T.PEDate > @DDay6
					THEN 'In Progress'
				ELSE 'Completed'
			END AS TaskStatus,
			T.PSDate, T.PEDate, T.ASDate, T.AEDate
	FROM @ProjectTasks T
		JOIN @ProjectTasks PT ON PT.Id = T.ParentId AND PT.PhLevel = 3 AND T.PhLevel = 4
		JOIN @ProjectTasks PSP ON PSP.Id = PT.ParentId AND PSP.PhLevel = 2 AND PT.PhLevel = 3
		JOIN @ProjectTasks PP ON PP.Id = PSP.ParentId AND PP.PhLevel = 1 AND PSP.PhLevel = 2
	WHERE	T.Id IN (SELECT SubTaskId AS Id FROM @Owner WHERE SubTaskId <> 0) AND T.PhLevel = 4
			AND ((T.PSDate <= @DDay1 AND T.AEDate IS NULL)
			OR (T.PSDate <= @DDay1 AND T.AEDATE IS NOT NULL AND T.AEDate >= @DDay1 AND T.AEDate <= @DDay6)
			OR (T.PSDate >= @DDay1 AND T.PSDate <= @DDay6))
	UNION ALL
	SELECT	T.PhLevel, T.ParentId, T.Id,
			PP.Name + ' - ' + PSP.Name + ' - ' + T.Name Name,
			CASE
				WHEN T.ASDate IS NOT NULL AND T.AEDate IS NULL AND T.PEDate <= @DDay6
					THEN 'Delayed,In Progress'
				WHEN T.ASDate IS NULL AND T.PSDate <= @DDay6
					THEN 'Delayed,Not Started'
				WHEN T.ASDate IS NOT NULL AND T.ASDate > T.PSDate AND (T.ASDate >= @DDay1 AND T.ASDate <= @DDay6) AND T.AEDate IS NULL
					THEN 'Late Start,In Progress'
				WHEN T.AEDate IS NOT NULL AND T.AEDate > T.PEDate
					THEN 'Late Finish,Completed'
				WHEN T.AEDate IS NULL AND T.ASDate IS NOT NULL AND T.PEDate > @DDay6
					THEN 'In Progress'
				ELSE 'Completed'
			END AS TaskStatus,
			T.PSDate, T.PEDate, T.ASDate, T.AEDate
	FROM @ProjectTasks T
		LEFT JOIN @ProjectTasks PSP ON PSP.Id = T.ParentId AND PSP.PhLevel = 2 AND T.PhLevel = 3
		LEFT JOIN @ProjectTasks PP ON PP.Id = PSP.ParentId AND PP.PhLevel = 1 AND PSP.PhLevel = 2
	WHERE	T.Id IN (SELECT TaskId AS Id FROM @Owner WHERE SubTaskId = 0 AND TaskId <> 0) AND T.PhLevel = 3
			AND ((T.PSDate <= @DDay1 AND T.AEDate IS NULL)
			OR (T.PSDate <= @DDay1 AND T.AEDATE IS NOT NULL AND T.AEDate >= @DDay1 AND T.AEDate <= @DDay6)
			OR (T.PSDate >= @DDay1 AND T.PSDate <= @DDay6))
	ORDER BY PhLevel, Id

	SELECT * FROM @Owner ORDER BY EmployeeId, SubTaskId, TaskId

	--Overall Project Completion Percent
	DECLARE @CompletionStatus TABLE (PhLevel INT, Id BIGINT, ParentId BIGINT, Name VARCHAR(MAX), PlannedHrs DECIMAL(10,2), BookedHRS DECIMAL(10,2), Completion DECIMAL(10,2))
	INSERT INTO @CompletionStatus
	EXEC usp_GetProjectCompletionStatus @ProjectId

	SELECT ISNULL(CAST((100 * SUM(CS.BookedHrs)) / SUM(CS.PlannedHrs) AS DECIMAL(10,2)),0) Completion
	FROM @CompletionStatus CS WHERE PhLevel = 1

	--Holidays in this week
	SELECT 'CW' WK, HolidayName, HolidayDate FROM AllProjectsHolidays WHERE ProjectId = @ProjectId AND HolidayDate BETWEEN @DDay1 AND DATEADD(DD,1,@DDay6)
	UNION ALL
	SELECT 'NW' WK, HolidayName, HolidayDate FROM AllProjectsHolidays WHERE ProjectId = @ProjectId 
		AND HolidayDate BETWEEN DATEADD(DD,7,@DDay1) AND DATEADD(DD,8,@DDay6)

	--Next Week's tasks
	SET @DDay1 = DATEADD(DD,7,@DDay1)
	SET @DDay6 = DATEADD(DD,7,@DDay6)

	SELECT Name FROM @ProjectTasks
	WHERE PSDate >= @DDay1 AND PSDate <= @DDay6

	SELECT	CC.FirstName + ' ' + CC.LastName AS 'Name', CC.WorkEmail AS 'Email'
	FROM	CustomerContacts CC
	JOIN	ProjectContactPerson PCP ON CC.CContactId = PCP.CustomerContactID AND PCP.ProjectId = @ProjectId AND PCP.EmailWSR = 1
	JOIN	Projects P ON PCP.ProjectId = P.ProjectId AND P.WSR = 1

END
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROC [dbo].[usp_AssignCustomerContactPerson]
	@CustomerId BIGINT,
    @Data NVARCHAR(MAX),
    @UpdatedBy nvarchar(255) = NULL
AS 
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	DECLARE @Values AS TABLE (ContactId BIGINT, AddressId BIGINT)
	IF LEN(@Data) > 0
		INSERT INTO @Values
		SELECT * FROM OPENJSON(@Data) WITH (CContactId BIGINT, AddressId BIGINT)

	DELETE FROM CustomerContactPerson
	WHERE CustomerId = @CustomerId
	AND CContactId NOT IN (SELECT ContactId FROM @Values V)

	
	UPDATE CustomerContactPerson SET AddressId = V.AddressId, UpdatedBy = @UpdatedBy, UpdatedDate = GETDATE()
	FROM CustomerContactPerson CCP
		JOIN @Values V ON CCP.CustomerId = @CustomerId AND CCP.CContactId = V.ContactId AND (CCP.AddressId <> V.AddressID OR CCP.AddressId IS NULL)

	INSERT INTO CustomerContactPerson (CustomerId, CContactId, AddressId, CreatedBy, CreatedDate)
	SELECT @CustomerId, V.ContactId, V.AddressId, @UpdatedBy, GETDATE() FROM @Values V
	WHERE V.ContactId NOT IN (SELECT CCP.CContactId FROM CustomerContactPerson CCP WHERE CCP.CustomerId = @CustomerId)

	--UPDATE [dbo].[CustomerContactPerson]
	--SET    [AddressId] = @AddressId
	--WHERE  [CContactId] = @CContactId and [CustomerId] = @CustomerId
	
	---- Begin Return Select <- do not remove
	--SELECT * FROM   [dbo].[SalesPerson]
	---- End Return Select <- do not remove

	SELECT 0

	COMMIT
END
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_GetProjectTeam]
	@ProjectId BIGINT, @Assigned BIT = 1, @InActive BIT = 0, @All BIT = 0
AS
BEGIN
	SET NOCOUNT ON;

	IF @All = 0
		SELECT E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName [EmpName], E.PersonalEmail [Email], E.MobileNo,
				E.InActive 'EmpActive', PA.InActive 'OnProjectActive', PA.Assigned
		FROM [dbo].[ProjectAssign] PA
			JOIN Employees E ON E.EmployeeId = PA.EmployeeId AND E.InActive = 0 AND PA.Assigned = @Assigned AND PA.InActive = @InActive
		WHERE PA.ProjectId = @ProjectId
	ELSE
		SELECT E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName [EmpName], E.PersonalEmail [Email], E.MobileNo,
				E.InActive 'EmpActive', PA.InActive 'OnProjectActive', PA.Assigned
		FROM [dbo].[ProjectAssign] PA
			JOIN Employees E ON E.EmployeeId = PA.EmployeeId
		WHERE PA.ProjectId = @ProjectId

END
GO
------------------------------------------------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE [dbo].[usp_ResetPassword]
(
	--@Email NVARCHAR(MAX),
	@Token NVARCHAR(MAX),
	@Password NVARCHAR(MAX),
	@UserId BIGINT = NULL,
	@UserType INT = NULL
)
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	--DECLARE @UserType INT, @UserId BIGINT

	IF (@UserId IS NULL OR @UserId = 0) AND @Token IS NOT NULL
		SELECT @UserId = UserId, @UserType = UserType 
		FROM ForgotPasswordToken
		WHERE Token = @Token

	IF @UserType = 2
	BEGIN
		BEGIN TRAN
		UPDATE Users
		SET	   PasswordHash = @Password
		WHERE  UserId = @UserId
		COMMIT;
		SELECT @@ROWCOUNT
	END

	IF @UserType = 3
	BEGIN
		BEGIN TRAN
		UPDATE CustomerContacts
		SET	   CPassword = @Password
		WHERE  CContactId = @UserId
		COMMIT;
		SELECT @@ROWCOUNT
	END
	
END
GO
------------------------------------------------------------------------------------------------------------------------------------
