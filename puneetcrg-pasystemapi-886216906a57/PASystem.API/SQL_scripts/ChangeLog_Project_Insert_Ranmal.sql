CREATE TRIGGER [dbo].[Projects_INSERT]
       ON [dbo].[Projects]
AFTER INSERT
AS
BEGIN
       SET NOCOUNT ON;
 
      DECLARE @entityId BIGINT,
			@change NVARCHAR(250)='CREATED',
			@detail NVARCHAR(MAX),
			@updatedBy NVARCHAR(250) = NULL,
			@customerName NVARCHAR(250),
			@manager NVARCHAR(250),
			@salesPerson NVARCHAR(250),
			@contactperson NVARCHAR(250)

 
       SELECT 
		@entityId = i.ProjectId, 
		@updatedBy = i.UpdatedBy,
		@detail = 'Project Name = ' + i.Name  + ', Project Code = ' + i.Code  + ', Project Description = ' + ISNULL(i.ShortDescription,'NULL') + ', Project Type = ' + ISNULL([ProjectTypes].Name,'NULL')  + ', Project Source = ' + ISNULL([ProjectSources].Name,'NULL') + ', Project Office = ' + ISNULL([Addresses].AddressCode,'NULL'),
		@manager ='Project Manager = '+(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([Employees].LastName, '')))),
		@salesPerson= 'Project Sales Person = '+(LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([SalesPerson].LastName, '')))),
		@contactperson= 'Project Contact Person = '+(LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
		END +
		LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))))
       FROM INSERTED i
		 LEFT OUTER JOIN Customers on Customers.CustomerId=i.CustomerId 
		 LEFT OUTER JOIN ProjectTypes on ProjectTypes.ProjectTypeId=i.ProjectTypeId 
		 LEFT OUTER JOIN ProjectSources on ProjectSources.ProjectSourceId=i.ProjectSourceId
		 LEFT OUTER JOIN Addresses on Addresses.AddressId=i.OfficeId 
		 LEFT OUTER JOIN Employees on Employees.EmployeeId=i.ManagerId 
		 LEFT OUTER JOIN SalesPerson on SalesPerson.SalesPersonId=i.SalesPersonId 
		 LEFT OUTER JOIN CustomerContacts on CustomerContacts.CContactId=i.ContactPersonId   
		
		print @detail
		print @manager
		print @salesPerson
		print @contactperson
	   DECLARE @msg AS NVARCHAR(MAX) =  @detail + ', '+ @manager+ ', '+ @salesPerson + ', ' + @contactperson; 
	   print @msg
       EXEC [dbo].[usp_ChangeLogInsert] @entityId,1, @change, @msg, @updatedBy
END