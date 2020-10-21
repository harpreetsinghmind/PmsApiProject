/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ProjectContactPerson](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[ProjectId] [bigint] NOT NULL,
	[CustomerContactID] [bigint] NOT NULL,
	[EmailDSR] [bit] NOT NULL,
	[EmailWSR] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedBy] [nvarchar](255) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [nvarchar](255) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProjectContactPerson] ADD  CONSTRAINT [DF_ProjectContactPerson_EmailDSR]  DEFAULT ((0)) FOR [EmailDSR]
GO

ALTER TABLE [dbo].[ProjectContactPerson] ADD  CONSTRAINT [DF_ProjectContactPerson_EmailWSR]  DEFAULT ((0)) FOR [EmailWSR]
GO

/****************************************************************************************************************************/
ALTER TABLE [dbo].[ForgotPasswordToken] ADD [UserType] [int] NULL;
GO

/****************************************************************************************************************************/
BEGIN TRAN
UPDATE ForgotPasswordToken SET UserType = 2
COMMIT
GO

/****************************************************************************************************************************/
BEGIN TRAN
INSERT INTO ProjectContactPerson (ProjectId, CustomerContactID, CreatedDate, CreatedBy)
SELECT ProjectId, ContactPersonId, GETDATE(), 'Admin' FROM Projects WHERE ContactPersonId IS NOT NULL
COMMIT
GO

/****************************************************************************************************************************/
BEGIN TRAN
UPDATE Projects SET ContactPersonId = NULL
COMMIT
GO

/****************************************************************************************************************************/
ALTER TABLE ProjectContactPerson ADD CONSTRAINT unq_ProjectContactPerson UNIQUE(ProjectId,CustomerContactID);
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ProjectPhase_UPDATE]
       ON [dbo].[ProjectPhase]
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ProjectId BIGINT
	SELECT @ProjectId = ProjectId FROM inserted
		
    IF UPDATE(StartDate)
	BEGIN
		--UPDATE Projects SET StartDate = (SELECT MIN(StartDate) FROM ProjectPhase WHERE ProjectId = @ProjectId)
		UPDATE Projects SET StartDate = B.StartDate
			FROM Projects P 
			JOIN (SELECT PP.ProjectId, MIN(PP.StartDate) AS StartDate FROM ProjectPhase PP
					JOIN inserted i ON PP.ProjectId = i.ProjectId
					GROUP BY PP.ProjectId) B
				ON P.ProjectId = B.ProjectId
	END

	IF UPDATE(ActualDate)
	BEGIN
		UPDATE Projects SET ActualDate = B.ActualDate
			FROM Projects P 
			JOIN (SELECT PP.ProjectId, MAX(PP.ActualDate) AS ActualDate FROM ProjectPhase PP
					JOIN inserted i ON PP.ProjectId = i.ProjectId
					WHERE (SELECT COUNT(*) FROM ProjectPhase PP2 WHERE PP2.ProjectId = PP.ProjectId AND PP2.ActualDate IS NULL) = 0
					GROUP BY PP.ProjectId) B
				ON P.ProjectId = B.ProjectId

		--IF NOT EXISTS(SELECT ActualDate FROM ProjectPhase WHERE ProjectId = @ProjectId AND ActualDate IS NULL)
		--BEGIN
		--	UPDATE Projects SET ActualDate = (SELECT MAX(ActualDate) FROM ProjectPhase WHERE ProjectId = @ProjectId)
		--END
	END
	   
END
GO

ALTER TABLE [dbo].[ProjectPhase] ENABLE TRIGGER [ProjectPhase_UPDATE]
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER TRIGGER [dbo].[ProjectPhase_INSERT]
       ON [dbo].[ProjectPhase]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='CREATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL

 
       SELECT 
		@entityId = INSERTED.ProjectId, 
		@updatedBy = INSERTED.UpdatedBy,
		@detail = 'Project Phase Name=' + Name + ', ' + 'Project Phase Start Date=' +  CAST(ISNULL(StartDate,'') AS NVARCHAR(250)) + ', ' + 'Project Phase End Date=' + CAST(ISNULL(EndDate,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Revenue=' + CAST(ISNULL(Revenue,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Budget=' + CAST(ISNULL(Budget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Target Cost=' + CAST(ISNULL(TargetCost,'') AS NVARCHAR(250)) +
		', ' + 'Project Phase Vendor Target=' + CAST(ISNULL(VendorTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Labor Target=' +  CAST(ISNULL(LaborTarget,'') AS NVARCHAR(250)) + ', ' + 'Project Phase Billing Type=' + CAST(ISNULL(BillingType,'') AS NVARCHAR(250))
       FROM INSERTED 
		
		
       EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @detail, @updatedBy

	--UPDATE Projects SET StartDate = MIN(i.StartDate)
	--FROM Projects P JOIN inserted i ON P.ProjectId = i.ProjectId
	
	--UPDATE Projects SET ActualDate = MAX(i.ActualDate) 
	--FROM Projects P JOIN inserted i ON P.ProjectId = i.ProjectId AND i.ActualDate IS NOT NULL

	UPDATE Projects SET StartDate = B.StartDate
			FROM Projects P 
			JOIN (SELECT PP.ProjectId, MIN(PP.StartDate) AS StartDate FROM ProjectPhase PP
					JOIN inserted i ON PP.ProjectId = i.ProjectId
					GROUP BY PP.ProjectId) B
				ON P.ProjectId = B.ProjectId
	UPDATE Projects SET ActualDate = B.ActualDate
			FROM Projects P 
			JOIN (SELECT PP.ProjectId, MAX(PP.ActualDate) AS ActualDate FROM ProjectPhase PP
					JOIN inserted i ON PP.ProjectId = i.ProjectId
					WHERE (SELECT COUNT(*) FROM ProjectPhase PP2 WHERE PP2.ProjectId = PP.ProjectId AND PP2.ActualDate IS NULL) = 0
					GROUP BY PP.ProjectId) B
				ON P.ProjectId = B.ProjectId
END
GO

/****************************************************************************************************************************/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GetAssociatedCustomers]
	(@Id BIGINT, @Type VARCHAR(2))
RETURNS NVARCHAR(MAX)
AS
BEGIN

	DECLARE @Customers NVARCHAR(MAX)
	IF @Type = 'CP'
		SELECT @Customers = COALESCE(@Customers + ', ','') + ISNULL(C.CustomerName,'') FROM Customers C
			JOIN CustomerContactPerson CCP ON CCP.CustomerId = C.CustomerId AND CCP.CContactId = @Id
	ELSE IF @Type = 'SP'
		SELECT @Customers = COALESCE(@Customers + ', ','') + ISNULL(C.CustomerName,'') FROM Customers C
			JOIN CustomerSalesPerson SP ON SP.CustomerId = C.CustomerId AND SP.SalesPersonId = @Id

	RETURN @Customers
    
END
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_GetTotalAssociations]
	(@Id BIGINT, @Type VARCHAR(2))
RETURNS INT
AS
BEGIN

	DECLARE @TotalContacts INT
	IF @Type = 'CP'
		SELECT @TotalContacts = COUNT(DISTINCT CustomerId) FROM CustomerContactPerson WHERE CContactId = @Id
	ELSE IF @Type = 'SP'
		SELECT @TotalContacts = COUNT(DISTINCT CustomerId) FROM CustomerSalesPerson WHERE SalesPersonId = @Id

	RETURN @TotalContacts
    
END
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomerContactsGetAll] 
    @PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null,
	@CustomerId BIGINT = NULL
AS 
	SET NOCOUNT ON 

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)

	DECLARE @CommonQuery varchar(MAX)
	SET @CommonQuery = 
		'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],
			(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName, 
			CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], 
			CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], 
			CustomerContacts.[UpdatedDate],CustomerContacts.[Notes],CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
		FROM [dbo].[CustomerContacts] 
			inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
			inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
			inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId 
		where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 
		'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],
			(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName,
			CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], 
			CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], 
			CustomerContacts.[UpdatedDate],CustomerContacts.[Notes],CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
		FROM [dbo].[CustomerContacts] 
			inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
			inner join Employees on Employees.EmployeeId = Projects.ManagerId 
		where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX))
	
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'Select DISTINCT * FROM  (SELECT (CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
	
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'Select DISTINCT * FROM  (SELECT (CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName FROM [dbo].[CustomerContacts] inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId inner join Employees on Employees.EmployeeId = Projects.ManagerId where Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +') x '+@Condition+''
	
	DECLARE @SelctedContact VARCHAR(MAX)
	SET @SelctedContact = ' WHERE CContactId NOT IN (SELECT CContactId FROM CustomerContactPerson WHERE CustomerId = ' +  CAST(@CustomerId AS VARCHAR(MAX)) + ')
						UNION ALL SELECT 1 ''SELECTED'', [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],
							(CustomerContacts.FirstName + '' '' + CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) + '' '' end + CustomerContacts.LastName) AS FullName, 
							CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], 
							CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], 
							CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes],
							CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
						FROM [dbo].[CustomerContacts] 
						WHERE CContactId IN (SELECT CContactId FROM CustomerContactPerson WHERE CustomerId = ' +  CAST(@CustomerId AS VARCHAR(MAX)) + ')'

	IF @UserType = 1
	BEGIN
		IF @Condition is null
			SELECT @SQLStatement = 
				'SELECT 2 ''SELECTED'', [CContactId], CustomerContacts.[CustomerId], [CTitle], 
					CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],
					(CustomerContacts.FirstName+'' ''+CASE when LTRIM(RTRIM(CustomerContacts.MiddleName)) = '' '' then LTRIM(RTRIM(CustomerContacts.MiddleName)) ELSE LTRIM(RTRIM(CustomerContacts.MiddleName)) +'' ''end +CustomerContacts.LastName) AS FullName, 
					CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], 
					CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate],
					CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes],CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
				FROM [dbo].[CustomerContacts]' + 
				IIF(@CustomerId IS NOT NULL, @SelctedContact, '') +
				' ORDER BY SELECTED, ' + @FieldName+ ' ' + @SortType + 
				' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + 
				' ROWS ONLY OPTION (RECOMPILE)'
		ELSE
		BEGIN
			SELECT @SQLStatement = 'select DISTINCT * from (
				SELECT 2 ''SELECTED'', [CContactId], CustomerContacts.[CustomerId],[CTitle], [FirstName], [MiddleName], [LastName],
					(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName,
					[DOB], [Gender], [WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], 
					CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate], CustomerContacts.[Notes],
					CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
				FROM [dbo].[CustomerContacts]) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + 
					' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'

			Select @CountStatement ='Select Count(*) as FilterCount FROM (SELECT (FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName FROM [dbo].[CustomerContacts]) x ' +@Condition
		End
	END

	IF @UserType = 2
	BEGIN
		IF @Condition is null
			SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery + ') UNION ('+ @CommonQuery2 +')) x order by x.'+@FieldName+' '+@SortType+ ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
		ELSE
		BEGIN
			SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +') UNION ('+ @CommonQuery2 +')) x '+@Condition+' order by x.'+@FieldName+' '+@SortType+' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'   

			SELECT @CountStatement ='select DISTINCT Count(*) as FilterCount from((' + @CountQuery +') UNION ('+ @CountQuery2 +')) y'
		End
	END

	IF @UserType = 3
	BEGIN
		SELECT @SQLStatement = 'select DISTINCT * from (
			(SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], CustomerContacts.[FirstName], CustomerContacts.[MiddleName], CustomerContacts.[LastName],
				 CustomerContacts.[FirstName] + '' '' + IIF(LEN(LTRIM(RTRIM(CustomerContacts.[MiddleName]))) > 0,CustomerContacts.[MiddleName] + '' '','''') + CustomerContacts.[LastName] AS FullName,
				 CustomerContacts.[DOB], CustomerContacts.[Gender], CustomerContacts.[WorkEmail], [OtherEmail], CustomerContacts.[AddressId], 
				 CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], 
				 CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes],CustomerContacts.[CPassword], ISNULL(dbo.fn_GetAssociatedCustomers(CustomerContacts.CContactId,''CP''),'''') Associations
			FROM [dbo].[CustomerContacts] WHERE CContactId IN 
				(SELECT CP.CContactId FROM CustomerContactPerson CP JOIN CustomerContactPerson CCP ON CP.CustomerId = CCP.CustomerId AND CCP.CContactId = ' + CAST(@UserId AS VARCHAR(MAX)) + '))
			) x 
			order by x.' + @FieldName + ' ' + @SortType + 
				' OFFSET ' + CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX)) + 
				' ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'

		SELECT @CountStatement = 'SELECT COUNT(*) AS FilterCount FROM [dbo].[CustomerContacts] WHERE CContactId IN 
				(SELECT CP.CContactId FROM CustomerContactPerson CP JOIN CustomerContactPerson CCP ON CP.CustomerId = CCP.CustomerId AND CCP.CContactId = ' + CAST(@UserId AS VARCHAR(MAX)) + ')'
	END

	--PRINT(@SQLStatement)
	EXEC(@SQLStatement)
	EXEC(@CountStatement)
GO

/****************************************************************************************************************************/
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
		ContactPerson = ''['' + COALESCE(STUFF((SELECT '',{"id":'' + CAST(PCP.CustomerContactID AS VARCHAR(MAX)) + '',"text":"'' + CC.FirstName + '' '' + CC.LastName + ''"}''
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

	PRINT(@SQLStatement)
	PRINT(@CountStatement)

	EXEC(@SQLStatement)  
	EXEC(@CountStatement)  
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectInsert]  
    @Name nvarchar(255),
    @ShortDes nvarchar(550),
    @Desc text, 
    @Status int,
    @CustomerId bigint,
    @ProjectTypeId bigint,
    @ProjectSourceId bigint,
    @OfficeId bigint, 
    @ManagerId bigint,
    @SalesPersonId bigint,
    -- @ContactPersonId bigint,	-- Changed for Multiple Seletion
	@ContactPersonIds NVARCHAR(MAX),
    @InActive bit,
    @PlannedStartDate DATETIME,
    @StartDate DATETIME,
    @EndDate DATETIME,
    @ActualDate DATETIME,
    @CreatedBy nvarchar(255) = NULL, 
	@PaymentType int,
	@WorkingDays nvarchar(255) = NULL,
	@DSR bit = 0,
	@WSR bit= 0
  
      
AS   
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
   
 BEGIN TRAN  
 IF NOT EXISTS(SELECT * FROM  Projects WHERE lower(Name) =LOWER(@Name) and CustomerId = @CustomerId)  
    BEGIN  
		DECLARE @projectCode NVARCHAR(MAX), @lastProjectId BIGINT, @initVal BIGINT =1  
		SELECT TOP 1 @lastProjectId = ProjectId FROM Projects ORDER BY ProjectId DESC  
		SELECT @lastProjectId = (ISNULL(@lastProjectId, 0) + @initVal)  
		SET @projectCode = 'PRJ' + FORMAT(@lastProjectId,'00#')  
		
		DECLARE @RoleId bigint, @UserId bigint, @NewProjectId bigint
		select @RoleId = RoleId from Roles where Name = 'Manager'  
		select @RoleId = ISNULL(@RoleId,0)  
		select @UserId = UserId from Employees where Employees.EmployeeId = @ManagerId  
  
		INSERT INTO [dbo].[Projects]
			([Name], [Code], [ShortDescription], [Description], [Status], [CustomerId], [ProjectTypeId], [ProjectSourceId], [OfficeId], [ManagerId], [SalesPersonId],
			[PaymentType], [WorkingDays], /*[ContactPersonId],*/ [InActive], [PlannedStartDate], [StartDate], [EndDate], [ActualDate], [CreatedBy], [CreatedDate],
			[DSR], [WSR] )
		SELECT
			@Name, @projectCode, @ShortDes, @Desc, @Status, @CustomerId, @ProjectTypeId, @ProjectSourceId, @OfficeId, @ManagerId, @SalesPersonId,
			@PaymentType, @WorkingDays, /*@ContactPersonId,*/ @InActive, @PlannedStartDate, @StartDate, @EndDate, @ActualDate, @CreatedBy, GETDATE(),
			@DSR, @WSR

		SELECT @NewProjectId = SCOPE_IDENTITY()
		IF LEN(@ContactPersonIds) > 0
		BEGIN
			INSERT INTO ProjectContactPerson (ProjectId,CustomerContactID,CreatedDate,CreatedBy)
			SELECT P.ProjectId, CP.items 'ContactId', GETDATE(), 'Admin'
			FROM PROJECTS P CROSS APPLY dbo.Split(@ContactPersonIds,',') CP WHERE P.ProjectId = @NewProjectId
		END

		-- Return Project Id
		SELECT @NewProjectId

		IF @RoleId <> 0
		BEGIN
			EXEC usp_UserRolesInsert  @UserId, @RoleId, 'false'
		END
    end
 ELSE
BEGIN
	SELECT -1
END

COMMIT
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectUpdate] 
	@ProjectId bigint,
   	@Name nvarchar(255),
    @ShortDes nvarchar(550),
    @Desc text,
    @Status int,
    @CustomerId bigint,
    @ProjectTypeId bigint,
    @ProjectSourceId bigint,
    @OfficeId bigint,
    @ManagerId bigint,
    @SalesPersonId bigint,
	--@ContactPersonId bigint,
	@ContactPersonIds NVARCHAR(MAX),
    @InActive bit,
	@PlannedStartDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ActualDate DATETIME,
    @UpdatedBy nvarchar(255) = NULL,
	@PaymentType int,
	@WorkingDays nvarchar(255) = NULL,
	@DSR bit = 0,
	@WSR bit= 0

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		IF EXISTS(SELECT * FROM  Projects WHERE lower(Name) =LOWER(@Name) and CustomerId = @CustomerId and ProjectId = @ProjectId)
		BEGIN

		DECLARE @RoleId bigint, @UserId bigint
		select @RoleId = RoleId from Roles where Name = 'Manager'
		select @RoleId = ISNULL(@RoleId,0)
		select @UserId = UserId from Employees where Employees.EmployeeId = @ManagerId

		DECLARE @oldManagerId BIGINT,
				@assignId BIGINT
		SELECT @oldManagerId = ManagerId from Projects where ProjectId = @ProjectId
		SELECT @assignId = AssignId FROM ProjectAssign WHERE ProjectId = @ProjectId AND RoleId =1 AND EmployeeId = @oldManagerId

		UPDATE  [dbo].[Projects] 
		SET 
			[Name] = @Name, 
			[ShortDescription] = @ShortDes, 
			[Description] = @Desc, 
			[Status] = @Status, 
			[CustomerId] = @CustomerId, 
			[ProjectTypeId] = @ProjectTypeId , 
			[ProjectSourceId] = @ProjectSourceId,
			[OfficeId] = @OfficeId, 
			[ManagerId] = @ManagerId, 
			[SalesPersonId] = @SalesPersonId, 
			--[ContactPersonId] = @ContactPersonId, 
			[InActive] = @InActive, 
			[PlannedStartDate] = @PlannedStartDate,
			[StartDate] = @StartDate,
			[EndDate] = @EndDate,
			[ActualDate] = @ActualDate, 
			[UpdatedBy] = @UpdatedBy, 
			[PaymentType] = @PaymentType,
			[WorkingDays] = @WorkingDays,
			[UpdatedDate] = GETDATE(),
			[DSR] = @DSR,
			[WSR] = @WSR
		WHERE 
			ProjectId = @ProjectId
	
		IF EXISTS(SELECT * FROM ProjectAssign WHERE ProjectId = @ProjectId AND RoleId =1 AND EmployeeId = @oldManagerId)
		BEGIN
			IF NOT EXISTS(SELECT * FROM ProjectAssign WHERE ProjectId = @ProjectId AND RoleId =1 AND EmployeeId = @ManagerId)
			BEGIN
				Update ProjectAssign 
					SET EmployeeId = @ManagerId
					WHERE AssignId = @assignId
			END
		END

		DELETE FROM ProjectContactPerson WHERE ProjectId = @ProjectId
		IF LEN(@ContactPersonIds) > 0
		BEGIN
			INSERT INTO ProjectContactPerson (ProjectId,CustomerContactID,CreatedDate,CreatedBy)
			SELECT P.ProjectId, CP.items 'ContactId', GETDATE(), 'Admin'
			FROM PROJECTS P CROSS APPLY dbo.Split(@ContactPersonIds,',') CP WHERE P.ProjectId = @ProjectId
		END

		
		SELECT @ProjectId		

		IF @RoleId <> 0
		BEGIN
			EXEC usp_UserRolesInsert  @UserId, @RoleId, 'false'
		END
    END
	ELSE
	BEGIN
		SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
GO

/****************************************************************************************************************************/
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

	IF @DSR = 0
		UPDATE ProjectContactPerson SET EmailDSR = 0 WHERE ProjectId = @ProjectId
	ELSE IF @RPT = 'D' AND LEN(@ContactPersonIds) > 0
		EXEC('UPDATE ProjectContactPerson SET EmailDSR = 1 WHERE CustomerContactID IN (' + @ContactPersonIds + ')')

	IF @WSR = 0
		UPDATE ProjectContactPerson SET EmailWSR = 0 WHERE ProjectId = @ProjectId
	ELSE IF @RPT = 'W' AND LEN(@ContactPersonIds) > 0
		EXEC('UPDATE ProjectContactPerson SET EmailWSR = 1 WHERE CustomerContactID IN (' + @ContactPersonIds + ')')

	COMMIT;

END
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetProjectSummary] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	IF @UserType = 1
	BEGIN
		SELECT 
			ProjectId,
			Name AS ProjectName,
			Projects.CustomerId,
			CASE Projects.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			Projects.CreatedDate, C.CustomerName, E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName AS ManagerName,
			Projects.PlannedStartDate AS ESDate, Projects.StartDate AS SDate, Projects.EndDate AS EDate, Projects.ActualDate AS ADate
		FROM  
			Projects
			JOIN Customers C ON PROJECTS.CustomerId = C.CustomerId
			JOIN Employees E ON PROJECTS.ManagerId = E.EmployeeId
	END
	
	IF @UserType = 2
	BEGIN
		SELECT 
			P.ProjectId,
			P.Name AS ProjectName,
			P.CustomerId,
			CASE P.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (P.StartDate IS NULL or P.StartDate >= GETDATE()) and (P.PlannedStartDate >= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (P.StartDate <= GETDATE() or P.PlannedStartDate <= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			P.CreatedDate, C.CustomerName, E.EmpTitle + ' ' + E.FirstName + ' ' + E.LastName AS ManagerName,
			P.PlannedStartDate AS ESDate, P.StartDate AS SDate, P.EndDate AS EDate, P.ActualDate AS ADate
		FROM  
			Projects P
			JOIN ProjectAssign PA ON PA.ProjectId = P.ProjectId
			JOIN Employees E ON PA.EmployeeId = E.EmployeeId
			JOIN Customers C ON P.CustomerId = C.CustomerId 
		WHERE
			E.UserId = @UserId
	END

	IF @UserType = 3
	BEGIN
		SELECT
			P.ProjectId,
			P.Name AS ProjectName,
			P.CustomerId,
			CASE P.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status,
			CASE WHEN (P.StartDate IS NULL or P.StartDate >= GETDATE()) and (P.PlannedStartDate >= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'NOT-STARTED'
			WHEN (P.StartDate <= GETDATE() or P.PlannedStartDate <= GETDATE()) and (P.ActualDate >= GETDATE() or P.ActualDate is null) 
				THEN 'OPENED'
				ELSE 'CLOSED'
			END AS ProStatus,
			P.CreatedDate, 
			--C.CustomerName, 
			--CC.CTitle + ' ' + CC.FirstName + ' ' + IIF(CC.MiddleName IS NULL, '', CC.MiddleName + ' ') + CC.LastName AS ManagerName,
			'' AS CustomerName, '' AS ManagerName,
			P.PlannedStartDate AS ESDate, P.StartDate AS SDate, P.EndDate AS EDate, P.ActualDate AS ADate
		FROM Projects P
			JOIN ProjectContactPerson PCP ON PCP.ProjectId = P.ProjectId AND PCP.CustomerContactID = @UserId
			--JOIN Customers C ON C.CustomerId = P.CustomerId 
			--JOIN CustomerContactPerson CP ON CP.CustomerId = C.CustomerId AND CP.CContactId = @UserId
			--JOIN CustomerContacts CC ON CC.CContactId = P.ContactPersonId
		--WHERE P.ContactPersonId = @UserId
	END

GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectGetAllForSelect]   
 @UserId bigint,  
 @UserType int  
AS
BEGIN
 SET NOCOUNT ON   
 SET XACT_ABORT ON    
  
 IF @UserType = 1
 BEGIN  
  SELECT * FROM(SELECT   
   -1 AS RoleId,  
   Projects.ProjectId,  
   Projects.Name AS ProjectName,  
   Projects.Code AS ProjectCode,  
   Projects.Locked,  
   Projects.PaymentType,  
   Projects.PlannedStartDate,  
   Projects.StartDate,  
   Projects.EndDate,  
   Projects.ActualDate,  
   Projects.ShortDescription AS ShortDesc,  
   Customers.CustomerName,  
   Projects.ManagerId,  
   Employees.EmployeeId,  
   Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
  (LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+  
  CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''  
   THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))  
   ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '  
  END +  
  LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,  
  (LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
  CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
   THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
   ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
  END +  
  LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
  --(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
  --CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
  -- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
  -- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
  --END +  
  --LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
  ContactPerson = COALESCE(STUFF((SELECT ', ' + CC.FirstName + ' ' + CC.LastName
	FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
	WHERE PCP.ProjectId = Projects.ProjectId
	FOR XML PATH('')),1,1,N''),N''),
  CASE WHEN Projects.InActive = 0  
   THEN  
    CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
     THEN 'NOT-STARTED'  
     WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
     THEN 'OPEN'  
     ELSE 'CLOSED'  
    END   
   ELSE 'ARCHIVED'  
  END AS ProStatus,  
  (SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
     CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
      THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
      ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
      END +  
     LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]
   FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
   WHERE PA.ProjectId = [Projects].ProjectId AND   
         PA.RoleId = 1 AND   
      PA.EmployeeId <> [Projects].ManagerId FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
  ) AS SecondaryProjectManager,
  Projects.WorkingDays
  FROM [dbo].[Projects]  
   LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId 
   LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
   --LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
   LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
   INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId) x  
 END  
 
 IF @UserType = 2
 BEGIN  
  SELECT DISTINCT ProjectAssign.RoleId, x.*   
  FROM (  
   (SELECT   
    Projects.ProjectId,  
    Projects.Name AS ProjectName,  
    Projects.Code AS ProjectCode,  
    Projects.Locked,  
    Projects.PaymentType,  
    Projects.PlannedStartDate,  
    Projects.StartDate,  
    Projects.EndDate,  
    Projects.ActualDate,  
    Projects.ShortDescription AS ShortDesc,  
    Customers.CustomerName,  
    Projects.ManagerId,  
    Employees.EmployeeId,  
    Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
   --(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+  
   --CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''  
   -- THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))  
   -- ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '  
   --END +  
   --LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager, 
   (SELECT (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
	CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
	THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
	ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
	END +  
	LTRIM(RTRIM(ISNULL(E.LastName, '')))) FROM Employees E WHERE E.EmployeeId = Projects.ManagerId) AS ProjectManager,  
   (LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
   CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
    THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
    ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
   END +  
   LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
  -- (LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
  --CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
  -- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
  -- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
  --END +  
  --LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
  ContactPerson = COALESCE(STUFF((SELECT ',' + CC.FirstName + ' ' + CC.LastName
	FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
	WHERE PCP.ProjectId = Projects.ProjectId
	FOR XML PATH('')),1,1,N''),N''),
   CASE WHEN Projects.InActive = 0  
    THEN  
     CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
      THEN 'NOT-STARTED'  
      WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
      THEN 'OPEN'  
      ELSE 'CLOSED'  
     END   
    ELSE 'ARCHIVED'  
   END AS ProStatus,  
  (SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
     CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
      THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
      ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
      END +  
     LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]
   FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
   WHERE PA.ProjectId = [Projects].ProjectId AND   
         PA.RoleId = 1 AND   
      PA.EmployeeId <> [Projects].ManagerId FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
  ) AS SecondaryProjectManager,
  Projects.WorkingDays
   FROM [dbo].[Projects]  
    LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId  
    LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
    --LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
    LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
    INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId  
   WHERE Employees.UserId = @UserId  AND Projects.InActive <> 1)  
  UNION  
   (SELECT   
    Projects.ProjectId,  
    Projects.Name AS ProjectName,  
    Projects.Code AS ProjectCode,  
    Projects.Locked,  
    Projects.PaymentType,  
    Projects.PlannedStartDate,  
    Projects.StartDate,  
    Projects.EndDate,  
    Projects.ActualDate,  
    Projects.ShortDescription AS ShortDesc,  
    Customers.CustomerName,  
    Projects.ManagerId,  
    Employees.EmployeeId,  
    Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
   --(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+  
   --CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''  
   -- THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))  
   -- ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '  
   --END +  
   --LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,  
   (SELECT (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
	CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
	THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
	ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
	END +  
	LTRIM(RTRIM(ISNULL(E.LastName, '')))) FROM Employees E WHERE E.EmployeeId = Projects.ManagerId) AS ProjectManager,  
   (LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
   CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
    THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
    ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
   END +  
   LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
  -- (LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
  --CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
  -- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
  -- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
  --END +  
  --LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
  ContactPerson = COALESCE(STUFF((SELECT ',' + CC.FirstName + ' ' + CC.LastName
	FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
	WHERE PCP.ProjectId = Projects.ProjectId
	FOR XML PATH('')),1,1,N''),N''),
   CASE WHEN Projects.InActive = 0  
    THEN  
     CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
      THEN 'NOT-STARTED'  
      WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
      THEN 'OPEN'  
      ELSE 'CLOSED'  
     END   
    ELSE 'ARCHIVED'  
   END AS ProStatus ,  
  (SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
     CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
      THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
      ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
      END +  
     LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]   
   FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
   WHERE PA.ProjectId = [Projects].ProjectId AND   
         PA.RoleId = 1 AND   
      PA.EmployeeId <> [Projects].ManagerId FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
  ) AS SecondaryProjectManager,
  Projects.WorkingDays
   FROM [dbo].[Projects]  
    LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId  
    LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
    --LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
    LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
    INNER JOIN ProjectAssign ON ProjectAssign.ProjectId = Projects.ProjectId  
    INNER JOIN Employees ON ProjectAssign.EmployeeId = Employees.EmployeeId  
   WHERE Employees.UserId = @UserId AND Projects.InActive <> 1 )  
   ) x  
   LEFT JOIN   
   ProjectAssign ON ProjectAssign.ProjectId = x.ProjectId AND ProjectAssign.EmployeeId = x.EmployeeId  
 END  
 
IF @UserType = 3
 BEGIN  
  SELECT * FROM(SELECT   
   -1 AS RoleId,  
   Projects.ProjectId,  
   Projects.Name AS ProjectName,  
   Projects.Code AS ProjectCode,  
   Projects.Locked,  
   Projects.PaymentType,  
   Projects.PlannedStartDate,  
   Projects.StartDate,  
   Projects.EndDate,  
   Projects.ActualDate,  
   Projects.ShortDescription AS ShortDesc,  
   Customers.CustomerName,  
   Projects.ManagerId,  
   Employees.EmployeeId,  
   Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
  (LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+  
  CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''  
   THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))  
   ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '  
  END +  
  LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,  
  (LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
  CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
   THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
   ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
  END +  
  LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
  --(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
  --CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
  -- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
  -- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
  --END +  
  --LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
  ContactPerson = COALESCE(STUFF((SELECT ',' + CC.FirstName + ' ' + CC.LastName
	FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
	WHERE PCP.ProjectId = Projects.ProjectId
	FOR XML PATH('')),1,1,N''),N''),
  CASE WHEN Projects.InActive = 0  
   THEN  
    CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
     THEN 'NOT-STARTED'  
     WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
     THEN 'OPEN'  
     ELSE 'CLOSED'  
    END   
   ELSE 'ARCHIVED'  
  END AS ProStatus,  
  (SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
     CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
      THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
      ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
      END +  
     LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]   
   FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
   WHERE PA.ProjectId = [Projects].ProjectId AND   
         PA.RoleId = 1 AND   
      PA.EmployeeId <> [Projects].ManagerId FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
  ) AS SecondaryProjectManager,
  Projects.WorkingDays
  FROM [dbo].[Projects]
   LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
   --INNER JOIN CustomerContactPerson CCP ON CCP.CustomerId = Customers.CustomerId AND CCP.CContactId = @UserId
   LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
   --LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId
   LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
   INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId
   INNER JOIN ProjectContactPerson PCP ON PCP.ProjectId = Projects.ProjectId AND PCP.CustomerContactID = @UserId
  --WHERE Projects.ContactPersonId = @UserId
  ) x
 END
END

GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_ProjectAssignGetAllForSelect]
	@UserId bigint, @UserType int
AS   
	SET NOCOUNT ON   
	SET XACT_ABORT ON    
 
	IF @UserType = 1
	BEGIN
			SELECT
				  -1 AS RoleId,
				   Projects.ProjectId,
				   Projects.Name AS ProjectName,
				   Projects.Code AS ProjectCode,
				   Projects.Locked,
				   Projects.PaymentType,
				   Projects.PlannedStartDate,
				   Projects.StartDate,
				   Projects.EndDate,
				   Projects.ActualDate,
				   Projects.ManagerId,
				   Projects.ShortDescription AS ShortDesc,
				   Customers.CustomerName,
				   Employees.BillingRate,
				   Employees.EmployeeId,
				   Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,
				  (LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
				  CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
				   THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
				   ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
				  END +
				  LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,
				  (LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
				  CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
				   THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
				   ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
				  END +  
				  LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
				  --(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
				  --CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
				  -- THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
				  -- ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
				  --END +  
				  --LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,
				  ContactPerson = COALESCE(STUFF((SELECT ', ' + CC.FirstName + ' ' + CC.LastName
					FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
					WHERE PCP.ProjectId = Projects.ProjectId
					FOR XML PATH('')),1,1,N''),N''),
				  CASE WHEN Projects.InActive = 0  
				   THEN  
					CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
					 THEN 'NOT-STARTED'  
					 WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
					 THEN 'OPEN'  
					 ELSE 'CLOSED'  
					END   
				   ELSE 'ARCHIVED'  
				  END AS ProStatus,  
				  (SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
					 CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
					  THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
					  ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
					  END +  
					 LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]   
				   FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
				   WHERE PA.ProjectId = [Projects].ProjectId AND   
						 PA.RoleId = 1 AND   
					  PA.EmployeeId <> [Projects].ManagerId FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
				  ) AS SecondaryProjectManager     
				  FROM [dbo].[Projects]  
				   LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId  
				   LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
				   --LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
				   LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
				   LEFT JOIN Employees ON Projects.ManagerId = Employees.EmployeeId  
	END
	
	IF @UserType = 2
	BEGIN
			SELECT DISTINCT ProjectAssign.RoleId, T1.* FROM (
				(SELECT   
					Projects.ProjectId,  
					Projects.Name AS ProjectName,  
					Projects.Code AS ProjectCode,  
					Projects.Locked,  
					Projects.PaymentType,  
					Projects.PlannedStartDate,  
					Projects.StartDate,  
					Projects.EndDate,  
					Projects.ActualDate,  
					Projects.ManagerId,  
					Projects.ShortDescription AS ShortDesc,  
					Customers.CustomerName,  
					Employees.BillingRate,  
					Employees.EmployeeId,  
					Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
					(SELECT (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
					CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
						THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
						ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
					END +  
					LTRIM(RTRIM(ISNULL(E.LastName, '')))) FROM Employees E WHERE E.EmployeeId = Projects.ManagerId) AS ProjectManager,  
					(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
					CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
						THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
						ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
					END +  
					LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
					--(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
					--CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
					--	THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
					--	ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
					--END +  
					--LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
					ContactPerson = COALESCE(STUFF((SELECT ', ' + CC.FirstName + ' ' + CC.LastName
						FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
						WHERE PCP.ProjectId = Projects.ProjectId
						FOR XML PATH('')),1,1,N''),N''),
					CASE WHEN Projects.InActive = 0  
						THEN  
						CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
							THEN 'NOT-STARTED'  
							WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
							THEN 'OPEN'  
							ELSE 'CLOSED'  
						END   
						ELSE 'ARCHIVED'  
						END AS ProStatus,  
					(SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
						CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
							THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
							ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
						END +  
						LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]   
					FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
					WHERE PA.ProjectId = [Projects].ProjectId AND PA.RoleId = 1 AND PA.EmployeeId <> [Projects].ManagerId 
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')
					) AS SecondaryProjectManager     
				FROM [dbo].[Projects]  
					LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId  
					LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
					--LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
					LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
					INNER JOIN Employees ON Projects.ManagerId = Employees.EmployeeId  
				WHERE Employees.UserId = @UserId AND Projects.InActive <> 1)  
  
			UNION
   
			   (SELECT   
					Projects.ProjectId,  
					Projects.Name AS ProjectName,  
					Projects.Code AS ProjectCode,  
					Projects.Locked,  
					Projects.PaymentType,  
					Projects.PlannedStartDate,  
					Projects.StartDate,  
					Projects.EndDate,  
					Projects.ActualDate,  
					Projects.ManagerId,  
					Projects.ShortDescription AS ShortDesc,  
					Customers.CustomerName,  
					Employees.BillingRate,  
					Employees.EmployeeId,  
					Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,  
					(SELECT (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
					CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
						THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
						ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
					END +  
					LTRIM(RTRIM(ISNULL(E.LastName, '')))) FROM Employees E WHERE E.EmployeeId = Projects.ManagerId) AS ProjectManager,  
					(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+  
					CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''  
						THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))  
						ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '  
					END +  
					LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,  
					--(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+  
					--CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''  
					--	THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))  
					--	ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '  
					--END +  
					--LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,  
					ContactPerson = COALESCE(STUFF((SELECT ', ' + CC.FirstName + ' ' + CC.LastName
						FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
						WHERE PCP.ProjectId = Projects.ProjectId
						FOR XML PATH('')),1,1,N''),N''),
					CASE WHEN Projects.InActive = 0  
						THEN  
						CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
						THEN 'NOT-STARTED'  
						WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)   
						THEN 'OPEN'  
						ELSE 'CLOSED'  
						END   
						ELSE 'ARCHIVED'  
					END AS ProStatus,  
					(SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+  
						CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''  
							THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))  
							ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '  
						END +  
						LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]   
					FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId  
					WHERE PA.ProjectId = [Projects].ProjectId AND PA.RoleId = 1 AND PA.EmployeeId <> [Projects].ManagerId
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')  
					) AS SecondaryProjectManager     
				FROM [dbo].[Projects]  
					LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId  
					LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId  
					--LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId  
					LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId  
					INNER JOIN ProjectAssign ON ProjectAssign.ProjectId = Projects.ProjectId   
					INNER join Employees on ProjectAssign.EmployeeId =Employees.EmployeeId AND ProjectAssign.EmployeeId = Employees.EmployeeId  
				   WHERE Employees.UserId = @UserId AND Projects.InActive <> 1)  
			) T1 LEFT JOIN ProjectAssign ON ProjectAssign.ProjectId = T1.ProjectId AND ProjectAssign.EmployeeId = T1.EmployeeId
	END

	IF @UserType = 3
	BEGIN
		SELECT
			-1 AS RoleId,
			Projects.ProjectId,
			Projects.Name AS ProjectName,
			Projects.Code AS ProjectCode,
			Projects.Locked,
			Projects.PaymentType,
			Projects.PlannedStartDate,
			Projects.StartDate,
			Projects.EndDate,
			Projects.ActualDate,
			Projects.ManagerId,
			Projects.ShortDescription AS ShortDesc,
			Customers.CustomerName,
			Employees.BillingRate,
			Employees.EmployeeId,
			Addresses.AddressCode +'('+ Addresses.AddressLine1 +')' AS Office,
			(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
				CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
				END +
			LTRIM(RTRIM(ISNULL([Employees].LastName, '')))) AS ProjectManager,
			(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
				CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
				END +
			LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))) AS SalesPerson,
			--(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
			--	CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
			--		THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
			--		ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
			--	END +
			--LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, '')))) AS ContactPerson,
			ContactPerson = COALESCE(STUFF((SELECT ', ' + CC.FirstName + ' ' + CC.LastName
					FROM ProjectContactPerson PCP JOIN CustomerContacts CC ON CC.CContactId=PCP.CustomerContactID
					WHERE PCP.ProjectId = Projects.ProjectId
					FOR XML PATH('')),1,1,N''),N''),
			CASE WHEN Projects.InActive = 0
				THEN
				CASE WHEN (StartDate IS NULL or StartDate >= GETDATE()) and (PlannedStartDate >= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)
					THEN 'NOT-STARTED'
					WHEN (StartDate <= GETDATE() or PlannedStartDate <= GETDATE()) and (ActualDate >= GETDATE() or ActualDate is null)
					THEN 'OPEN'
					ELSE 'CLOSED'
				END
				ELSE 'ARCHIVED'
			END AS ProStatus,
			(SELECT STUFF((SELECT ', ' + (LTRIM(RTRIM(ISNULL(E.FirstName, ''))) + ' '+
					CASE WHEN LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL(E.MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL(E.MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL(E.LastName, '')))) [text()]
				FROM  ProjectAssign PA INNER JOIN Employees E ON PA.EmployeeId = E.EmployeeId
				WHERE PA.ProjectId = [Projects].ProjectId AND
					PA.RoleId = 1 AND PA.EmployeeId <> [Projects].ManagerId
			FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' ')
			) AS SecondaryProjectManager
		FROM [dbo].[Projects]
			LEFT JOIN Customers ON Projects.CustomerId = Customers.CustomerId
			--INNER JOIN CustomerContactPerson CCP ON CCP.CustomerId = Customers.CustomerId AND CCP.CContactId = @UserId
			LEFT JOIN SalesPerson ON Projects.SalesPersonId = SalesPerson.SalesPersonId
			--LEFT JOIN CustomerContacts ON Projects.ContactPersonId = CustomerContacts.CContactId
			LEFT JOIN Addresses ON Projects.OfficeId = Addresses.AddressId
			LEFT JOIN Employees ON Projects.ManagerId = Employees.EmployeeId
			INNER JOIN ProjectContactPerson PCP ON PCP.ProjectId = Projects.ProjectId AND PCP.CustomerContactID = @UserId
		--WHERE Projects.ContactPersonId = @UserId
	END

GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetAllFilterdEmployee] 
   
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	select	[EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail],
			[DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], E.[InActive],
			E.[CreatedBy], E.[CreatedDate], E.[UpdatedBy], E.[UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], 
			[BillingTarget], [ExpenseEntry], [PaymentMethod], [RateSGroup], [VendorID], [UserNumber], E.[UserId], [PayrollState], [HomePhoneNo], 
			[MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId],
			FirstName + ' ' + iif(MiddleName is null, '', MiddleName + '  ') + LastName as EmployeeName 
	from Employees E
	where (E.Isdeleted = 'false' or E.Isdeleted IS NULL) AND E.InActive = 0
		and E.UserId IN (SELECT UR.UserId FROM UserRoles UR JOIN Roles R ON R.RoleId = UR.RoleId AND (R.RoleId IS NULL OR R.Name <> 'Admin'))
	order by FirstName

	COMMIT
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GenerateForgotPasswordToken] 
    @Email nvarchar(256)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	DECLARE @UserId BIGINT, @UserType INT
	DECLARE @Token NVARCHAR(100) = NULL

	SELECT @UserId = [UserId], @UserType = 2
	FROM [dbo].[Users] U (NOLOCK)
	WHERE U.[Email] = @Email
	AND U.[InActive] = 0

	IF @UserId IS NULL
	BEGIN
		SELECT	@UserId = [CContactId], @UserType = 3
		FROM	[dbo].[CustomerContacts] CC (NOLOCK)
		WHERE	CC.[WorkEmail] = @Email AND 
				CC.[InActive] = 0
	END

	IF @UserId IS NOT NULL
	BEGIN
		UPDATE [dbo].[ForgotPasswordToken]
		SET [IsActive] = 0
		WHERE [UserId]= @UserId

		SET @Token = NewID()

		INSERT INTO [dbo].[ForgotPasswordToken]
		(	[UserId]
		,	[Token]
		,	[UserType]
		)
		VALUES
		(	@UserId
		,	@Token
		,	@UserType
		)

		SELECT @Token
	END
GO

/****************************************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[usp_ResetPassword]
(
	@Token NVARCHAR(MAX),
	@Password NVARCHAR(MAX)
)
AS
BEGIN
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	DECLARE @UserId BIGINT, @UserType int

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
	END

	IF @UserType = 3
	BEGIN
		BEGIN TRAN
		UPDATE CustomerContacts
		SET	   CPassword = @Password
		WHERE  CContactId = @UserId
		COMMIT;
	END
	
	SELECT @@ROWCOUNT
	
END
GO

/****************************************************************************************************************************/
