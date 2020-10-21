USE [PASystem]
GO

/****** Object:  Trigger [dbo].[Projects_UPDATE]    Script Date: 4/3/2019 3:25:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[Projects_UPDATE]
       ON [dbo].[Projects]
AFTER UPDATE
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='UPDATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL,
			@manager NVARCHAR(250),
			@salesPerson NVARCHAR(250),
			@contactperson NVARCHAR(250)

 
       SELECT 
		@entityId = INSERTED.ProjectId, @updatedBy = INSERTED.UpdatedBy 
		FROM INSERTED
		
		IF UPDATE(Name)
		BEGIN
			 SELECT @detail = 'Updated Project Name=' + Name	FROM INSERTED
		END	
		DECLARE @shDescription NVARCHAR(255)	
		IF UPDATE(ShortDescription)
		BEGIN
			 SELECT @shDescription = 'Updated Project Description=' +  ISNULL(ShortDescription,'')	FROM INSERTED
		END	
		
		DECLARE @projectType NVARCHAR(255)	
		IF UPDATE(ProjectTypeId)
		BEGIN
			SELECT @projectType = 'Updated Project Type=' + ISNULL(ProjectTypes.Name,'')	FROM INSERTED i
			LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=i.ProjectTypeId 
		END	
		DECLARE @customerName NVARCHAR(255)		
		IF UPDATE(CustomerId)
		BEGIN
			SELECT @customerName = 'Updated Project Customer=' + ISNULL(Customers.CustomerName,'')	FROM INSERTED i
			LEFT OUTER JOIN Customers on Customers.CustomerId=i.CustomerId 
		END	
		DECLARE @sourceName NVARCHAR(255)		
		IF UPDATE(ProjectSourceId)
		BEGIN
			SELECT @sourceName = 'Updated Project Source=' + ISNULL(ProjectSources.Name,'')	FROM INSERTED i
			LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=i.ProjectSourceId
		END	
		DECLARE @addressName NVARCHAR(255)		
		IF UPDATE(OfficeId)
		BEGIN
			SELECT @addressName = 'Updated Project Office=' + ISNULL(Addresses.AddressCode,'')	FROM INSERTED i
			LEFT OUTER JOIN Addresses on Addresses.AddressId=i.OfficeId 
		END		
		IF UPDATE(ManagerId)
		BEGIN
			SELECT @manager ='Project Manager = '+(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
					CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
						THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
						ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL([Employees].LastName, ''))))	
			FROM INSERTED i
			 LEFT OUTER JOIN Employees on Employees.EmployeeId=i.ManagerId 
		END		
		IF UPDATE(SalesPersonId)
		BEGIN
			SELECT @salesPerson= 'Project Sales Person = '+(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
					CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
						THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
						ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL([SalesPerson].LastName, ''))))
			FROM INSERTED i
			 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=i.SalesPersonId 
		END		
		IF UPDATE(ContactPersonId)
		BEGIN
			SELECT @contactperson= 'Project Contact Person = '+(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
					CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
						THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
						ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))))
			FROM INSERTED i
				LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=i.ContactPersonId  
		END		

	   DECLARE @msg AS NVARCHAR(MAX) =  @detail + ', '+ @shDescription + ', ' + @projectType +', '+ @customerName + ', '+  @sourceName +', ' + @addressName + ', ' + @manager+ ', '+ @salesPerson + ', ' + @contactperson; 
	   print @msg
	   IF @msg IS NOT NULL
	   BEGIN
		EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @msg, @updatedBy
	   END
END
GO

ALTER TABLE [dbo].[Projects] ENABLE TRIGGER [Projects_UPDATE]
GO


