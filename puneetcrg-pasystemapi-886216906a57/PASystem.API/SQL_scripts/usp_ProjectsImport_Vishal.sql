CREATE PROC [dbo].[usp_ProjectsImport] 
    @Name nvarchar(MAX),
	@ShortDescription nvarchar(MAX),
	@Description nvarchar(MAX),
	@CustomerName nvarchar(MAX),
	@ProjectType nvarchar(MAX),
	@ProjectSource nvarchar(MAX),
	@Office nvarchar(MAX),
	@ManagerFirstName nvarchar(MAX),
	@ManagerMiddleName nvarchar(MAX),
	@ManagerLastName nvarchar(MAX),
	@SalesPersonFirstName nvarchar(MAX),
	@SalesPersonMiddleName nvarchar(MAX),
	@SalesPersonLastName nvarchar(MAX),
	@ContactPersonFirstName nvarchar(MAX),
	@ContactPersonMiddleName nvarchar(MAX),
	@ContactPerosnLastName nvarchar(MAX),
	@PaymentType nvarchar(MAX),
	@WorkingDays nvarchar(MAX),
	@InActive bit,
	@PlannedStartDate nvarchar(MAX),
	@StartDate nvarchar(MAX) = NULL,
	@EndDate nvarchar(MAX),
	@ActualDate nvarchar(MAX) = NULL,
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	IF EXISTS(SELECT * FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))
		BEGIN
			DECLARE @CustomerId bigint, @ContactPersonId bigint, @SalesPersonId bigint, @ProjectTypeId bigint, @ProjectSourceId bigint, @OfficeId bigint, @PaymentId bigint, @Days nvarchar(MAX), @pdate nvarchar(MAX), @edate nvarchar(MAX), @sdate nvarchar(MAX), @adate nvarchar(MAX), @ManagerId bigint;
			SET @CustomerId = (SELECT CustomerId FROM Customers WHERE LOWER(CustomerName) = LOWER(@CustomerName))
			SET @ContactPersonId = NULL;
			SET @SalesPersonId = NULL;
			SET @ProjectTypeId = NULL;
			SET @ProjectSourceId = NULL;
			SET @PaymentId = NULL;
			SET @sdate = @StartDate
			SET @adate = @ActualDate
			IF (@ContactPersonFirstName IS NOT NULL AND @ContactPersonFirstName <> '') AND (@ContactPerosnLastName IS NOT NULL AND @ContactPerosnLastName <> '')
				BEGIN
					SET @ContactPersonId = (SELECT DISTINCT [CustomerContacts].CContactId FROM [dbo].[CustomerContacts]
											INNER JOIN [CustomerContactPerson] ON [CustomerContacts].CContactId = [CustomerContactPerson].CContactId
											WHERE [CustomerContacts].InActive=0 AND [CustomerContactPerson].CustomerId = @CustomerId
											AND LOWER([CustomerContacts].FirstName) = LOWER(@ContactPersonFirstName) AND LOWER([CustomerContacts].MiddleName) = LOWER(@ContactPersonMiddleName)
											AND LOWER([CustomerContacts].LastName) = LOWER(@ContactPerosnLastName)
											)
				END
			IF (@SalesPersonFirstName IS NOT NULL AND @SalesPersonFirstName <> '') AND (@SalesPersonLastName IS NOT NULL AND @SalesPersonLastName <> '')
				BEGIN
					SET @SalesPersonId = (SELECT DISTINCT [SalesPerson].SalesPersonId FROM [dbo].[SalesPerson]
											INNER JOIN [CustomerSalesPerson] ON SalesPerson.SalesPersonId = CustomerSalesPerson.SalesPersonId
											WHERE [SalesPerson].InActive=0 AND [CustomerSalesPerson].CustomerId = @CustomerId
											AND LOWER([SalesPerson].FirstName) = LOWER(@SalesPersonFirstName) AND LOWER([SalesPerson].MiddleName) = LOWER(@SalesPersonMiddleName)
											AND LOWER([SalesPerson].LastName) = LOWER(@SalesPersonLastName)
											)
				END
			IF @ProjectType IS NOT NULL AND @ProjectType <> ''
				BEGIN
					IF EXISTS (SELECT * FROM ProjectTypes WHERE LOWER(Name) = LOWER(@ProjectType))
						BEGIN
							SET @ProjectTypeId = (SELECT ProjectTypeId FROM ProjectTypes WHERE LOWER(Name) = LOWER(@ProjectType))
						END
					ELSE
						BEGIN
							SELECT -2 --INVALID PROJECT TYPE
						END
				END
			IF @ProjectSource IS NOT NULL AND @ProjectSource <> ''
				BEGIN
					IF EXISTS (SELECT * FROM ProjectSources WHERE LOWER(Name) = LOWER(@ProjectSource))
						BEGIN
							SET @ProjectSourceId = (SELECT ProjectSourceId FROM ProjectSources WHERE LOWER(Name) = LOWER(@ProjectSource))
						END
					ELSE
						BEGIN
							SELECT -3 --INVALID PROJECT SOURCE
						END
				END
			IF @Office IS NULL OR @Office = ''
				BEGIN
					SELECT -4 --INVALID OFFICE
				END
			ELSE
				BEGIN
					IF EXISTS(SELECT DISTINCT CustomerAdresses.[AddressId] FROM   [dbo].[CustomerAdresses]
							 inner join Customers on Customers.CustomerId=CustomerAdresses.CustomerId
							 inner join Addresses on Addresses.AddressId=CustomerAdresses.AddressId
							 WHERE  CustomerAdresses.[CustomerId] = @CustomerId AND LOWER(Addresses.AddressCode) = LOWER(@Office))
						BEGIN
							SET @OfficeId = (SELECT DISTINCT CustomerAdresses.[AddressId] FROM   [dbo].[CustomerAdresses]
											 inner join Customers on Customers.CustomerId=CustomerAdresses.CustomerId
											 inner join Addresses on Addresses.AddressId=CustomerAdresses.AddressId
											 WHERE  CustomerAdresses.[CustomerId] = @CustomerId AND LOWER(Addresses.AddressCode) = LOWER(@Office))
						END
					ELSE
						BEGIN
							SELECT -4 --INVALID OFFICE
						END
				END
			IF @PaymentType IS NOT NULL AND @PaymentType <> ''
				BEGIN
					IF LOWER(@PaymentType) = LOWER('Cash')
						BEGIN
							SET @PaymentId = 1
						END
					ELSE IF LOWER(@PaymentType) = LOWER('Bank cheque')
						BEGIN
							SET @PaymentId = 2
						END
					ELSE IF LOWER(@PaymentType) = LOWER('Online')
						BEGIN
							SET @PaymentId = 3
						END
					ELSE
						BEGIN
							SELECT -5 --INVALID PAYMENT TYPE
						END
				END
			IF @WorkingDays IS NOT NULL AND @WorkingDays <> ''
				BEGIN
					IF @WorkingDays LIKE '%,'
						BEGIN
							SET @Days = (SELECT REVERSE(SUBSTRING(REVERSE(SUBSTRING(@WorkingDays, PATINDEX('%[^,]%', @WorkingDays),99999)), PATINDEX('%[^,]%', REVERSE(SUBSTRING(@WorkingDays, PATINDEX('%[^,]%', @WorkingDays),99999))),99999)))
						END
					ELSE
						BEGIN
							SET @Days = @WorkingDays
						END
				END
			ELSE
				BEGIN
					SELECT -6 -- INVALID DAYS
				END
			IF ((@PlannedStartDate IS NOT NULL AND @PlannedStartDate <> '') AND (@EndDate IS NOT NULL AND @EndDate <> '')) AND ((ISDATE(@PlannedStartDate) = 1) AND (ISDATE(@EndDate) = 1))
				BEGIN
					SET @pdate = @PlannedStartDate;
					SET @edate = @EndDate;
				END
			ELSE
				BEGIN
					SELECT -7 --INVALID DATE FORMAT
				END
			IF ((@StartDate IS NOT NULL AND @StartDate <> '') AND ISDATE(@StartDate) = 0)
				BEGIN
					SELECT -7 --INVALID DATE FORMAT
				END
			IF ((@ActualDate IS NOT NULL AND @ActualDate <> '') AND ISDATE(@ActualDate) = 0)
				BEGIN
					SELECT -7 --INVALID DATE FORMAT
				END
			IF (@ManagerFirstName IS NOT NULL AND @ManagerFirstName <> '') AND (@ManagerLastName IS NOT NULL AND @ManagerLastName <> '')
				BEGIN
					IF @ManagerMiddleName IS NOT NULL AND @ManagerMiddleName <> ''
						BEGIN
							IF EXISTS(SELECT * FROM Employees 
							LEFT join UserRoles on UserRoles.UserId = Employees.UserId
							LEFT join Roles on Roles.RoleId = UserRoles.RoleId
							where Employees.Isdeleted = 'false' or Employees.Isdeleted IS NULL
							AND (Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
							AND LOWER(Employees.FirstName) = LOWER(@ManagerFirstName) AND LOWER(Employees.MiddleName) = LOWER(@ManagerMiddleName)
							AND LOWER(Employees.LastName) = LOWER(@ManagerLastName))
								BEGIN
									SET @ManagerId = (SELECT EmployeeId FROM Employees 
									LEFT join UserRoles on UserRoles.UserId = Employees.UserId
									LEFT join Roles on Roles.RoleId = UserRoles.RoleId
									where Employees.Isdeleted = 'false' or Employees.Isdeleted IS NULL
									AND (Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
									AND LOWER(Employees.FirstName) = LOWER(@ManagerFirstName) AND LOWER(Employees.MiddleName) = LOWER(@ManagerMiddleName)
									AND LOWER(Employees.LastName) = LOWER(@ManagerLastName))
								END
							ELSE
								BEGIN
									SELECT -8 --INVALID MANAGER
								END
						END
					ELSE
						BEGIN
							IF EXISTS(SELECT * FROM Employees 
							LEFT join UserRoles on UserRoles.UserId = Employees.UserId
							LEFT join Roles on Roles.RoleId = UserRoles.RoleId
							where Employees.Isdeleted = 'false' or Employees.Isdeleted IS NULL
							AND (Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
							AND LOWER(Employees.FirstName) = LOWER(@ManagerFirstName) AND LOWER(Employees.MiddleName) IS NULL
							AND LOWER(Employees.LastName) = LOWER(@ManagerLastName))
								BEGIN
									SET @ManagerId = (SELECT EmployeeId FROM Employees 
									LEFT join UserRoles on UserRoles.UserId = Employees.UserId
									LEFT join Roles on Roles.RoleId = UserRoles.RoleId
									where Employees.Isdeleted = 'false' or Employees.Isdeleted IS NULL
									AND (Roles.RoleId IS NULL OR Roles.Name <> 'Admin')
									AND LOWER(Employees.FirstName) = LOWER(@ManagerFirstName) AND LOWER(Employees.MiddleName) IS NULL
									AND LOWER(Employees.LastName) = LOWER(@ManagerLastName))
								END
							ELSE
								BEGIN
									SELECT -8 --INVALID MANAGER
								END
						END
				END
			ELSE
				BEGIN
					SELECT -8 --INVALID MANAGER
				END
			IF NOT EXISTS(SELECT * FROM  Projects WHERE lower(Name) =LOWER(@Name) and CustomerId = @CustomerId)
				BEGIN
					IF @IsDeleted = 0
						BEGIN
							IF @allowAdd = 1
								BEGIN
									DECLARE @projectCode NVARCHAR(MAX), @lastProjectId BIGINT, @initVal BIGINT =1
									SELECT TOP 1 @lastProjectId = ProjectId FROM Projects ORDER BY ProjectId DESC
									SELECT @lastProjectId = (ISNULL(@lastProjectId, 0) + @initVal)
									SET @projectCode = 'PRJ' + FORMAT(@lastProjectId,'00#')

									INSERT INTO Projects
									(Name
									,Code
									,ShortDescription
									,Description
									,CustomerId
									,ProjectTypeId
									,ProjectSourceId
									,OfficeId
									,PlannedStartDate
									,StartDate
									,EndDate
									,ActualDate
									,PaymentType
									,ManagerId
									,SalesPersonId
									,ContactPersonId
									,WorkingDays
									,InActive
									,CreatedBy)
									SELECT
									@Name,
									@projectCode,
									@ShortDescription,
									@Description,
									@CustomerId,
									@ProjectTypeId,
									@ProjectSourceId,
									@OfficeId,
									CONVERT(datetime,@pdate),
									CASE WHEN @sdate ='' THEN NULL ELSE CONVERT(datetime,@sdate) END,
									CONVERT(datetime,@edate),
									CASE WHEN @adate ='' THEN NULL ELSE CONVERT(datetime,@adate) END,
									@PaymentId,
									@ManagerId,
									@SalesPersonId,
									@ContactPersonId,
									@Days,
									@InActive,
									GETDATE()
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
					ELSE
						BEGIN
							SELECT 2 --NOT FOUND
						END
				END
			ELSE
				BEGIN
					IF @IsDeleted = 1
						BEGIN
							DELETE FROM Projects WHERE LOWER(Name) = LOWER(@Name) and CustomerId = @CustomerId
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE Projects
									SET ShortDescription = @ShortDescription,
										Description = @Description,
										ProjectTypeId = @ProjectTypeId,
										ProjectSourceId = @ProjectSourceId,
										OfficeId = @OfficeId,
										PlannedStartDate = CONVERT(datetime,@pdate),
										StartDate = CASE WHEN @sdate ='' THEN NULL ELSE CONVERT(datetime,@sdate) END,
										EndDate =  CONVERT(datetime,@edate),
										ActualDate =  CASE WHEN @adate ='' THEN NULL ELSE CONVERT(datetime,@adate) END,
										PaymentType = @PaymentId,
										ManagerId = @ManagerId,
										SalesPersonId = @SalesPersonId,
										ContactPersonId = @ContactPersonId,
										WorkingDays = @Days,
										InActive = @InActive,
										UpdatedDate = GETDATE()
									WHERE LOWER(Name) = LOWER(@Name) AND CustomerId = @CustomerId
									SELECT TOP 1 ProjectId FROM Projects WHERE LOWER(Name) = LOWER(@Name) AND CustomerId = @CustomerId --UPDATE
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
				END
		END
	ELSE
		BEGIN
			SELECT -1 --INVALID CUSTOMER
		END
