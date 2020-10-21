/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Express Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO

/****** Object:  StoredProcedure [dbo].[usp_ProjectInsert]    Script Date: 7/12/2019 12:27:21 PM ******/
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
	@ContactPersonId bigint,
    @InActive bit,
	@PlannedStartDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ActualDate DATETIME,
    @CreatedBy nvarchar(255) = NULL,
	@PaymentType int,
	@WorkingDays nvarchar(255) = NULL

    
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


	DECLARE @RoleId bigint, @UserId bigint
	select @RoleId = RoleId from Roles where Name = 'Manager'
	select @RoleId = ISNULL(@RoleId,0)
	select @UserId = UserId from Employees where Employees.EmployeeId = @ManagerId

	IF @RoleId <> 0
	BEGIN
		EXEC usp_UserRolesInsert  @UserId, @RoleId, 'false'
	END


	INSERT INTO [dbo].[Projects] 
		([Name], 
		[Code], 
		[ShortDescription], 
		[Description], 
		[Status], 
		[CustomerId], 
		[ProjectTypeId], 
		[ProjectSourceId],
		[OfficeId], 
		[ManagerId], 
		[SalesPersonId], 
		[PaymentType],
		[WorkingDays],
		[ContactPersonId], 
		[InActive],
		[PlannedStartDate],
		[StartDate],
		[EndDate],
		[ActualDate], 
		[CreatedBy], 
		[CreatedDate])
	SELECT 
		@Name, 
		@projectCode, 
		@ShortDes,
		@Desc, 
		@Status,
		@CustomerId,
		@ProjectTypeId,
		@ProjectSourceId,
		@OfficeId,
		@ManagerId,
		@SalesPersonId,
		@PaymentType,
		@WorkingDays,
		@ContactPersonId,
		@InActive,
		@PlannedStartDate,
		@StartDate,
		@EndDate,
		@ActualDate,
		@CreatedBy,
		GETDATE()
	
	-- Begin Return Select <- do not remove
	SELECT SCOPE_IDENTITY()
    end
	ELSE
	BEGIN
	SELECT -1
	END
	-- End Return Select <- do not remove
               
	COMMIT
GO

