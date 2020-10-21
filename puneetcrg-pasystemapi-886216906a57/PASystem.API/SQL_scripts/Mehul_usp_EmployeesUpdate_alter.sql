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

/****** Object:  StoredProcedure [dbo].[usp_EmployeesUpdate]    Script Date: 4/11/2019 5:04:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_EmployeesUpdate] 
    @EmployeeId bigint,
    @EmpCode nvarchar(100),
    @EmpTitle nvarchar(50),
    @FirstName nvarchar(100),
    @MiddleName nvarchar(100) = NULL,
    @LastName nvarchar(100) = NULL,
    @JoiningDate datetime = NULL,
    @DOB datetime = NULL,
    @Gender nvarchar(50) = NULL,
    @WorkEmail nvarchar(100) = NULL,
    @PersonalEmail nvarchar(100) = NULL,
    @DepartmentId bigint = NULL,
    @DesignationId bigint = NULL,
    @ReportingTo bigint = NULL,
    @IDNo nvarchar(100) = NULL,
    @FatherName nvarchar(255) = NULL,
    @MobileNo nvarchar(50) = NULL,
    @LandlineNo nvarchar(50) = NULL,
    @EmpStatus nvarchar(100) = NULL,
    @ReleavingDate datetime = NULL,
    @InActive bit,
    @CreatedBy nvarchar(255) = NULL,
    @CreatedDate datetime = NULL,
    @UpdatedBy nvarchar(255) = NULL,
    @UpdatedDate datetime = NULL,
    @EmpType nvarchar(100) = NULL,
    @InActiveDate datetime = NULL,
    @InActiveReason nvarchar(MAX) = NULL,
    @BillingRate float = NULL,
    @CostRate float = NULL,
    @BillingTarget float = NULL,
    @ExpenseEntry bit = NULL,
    @PaymentMethod nvarchar(200) = NULL,
    @RateSGroup nvarchar(500) = NULL,
    @VendorID nvarchar(200) = NULL,
    @UserNumber nvarchar(300) = NULL,
    @UserId nchar(128) = NULL,
    @PayrollState nvarchar(255) = NULL,
    @HomePhoneNo nvarchar(50) = NULL,
    @MaritalStaus bit = NULL,
    @SpouseName nvarchar(300) = NULL,
    @EthnicOrigin nvarchar(300) = NULL,
	@Address nvarchar(MAX) = NULL,
	@CountryId bigint = NULL,
	@StateId bigint = NULL,
	@CityId bigint = NULL,
	@ZipcodeId bigint = NULL
    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(select * from Employees where MobileNo = @MobileNo and EmployeeId <>@EmployeeId)
	BEGIN
		IF NOT EXISTS(select * from Employees where LTRIM(RTRIM(LOWER(VendorID))) = LTRIM(RTRIM(LOWER(ISNULL(@VendorID,'')))) and EmployeeId <>@EmployeeId)
		BEGIN
		UPDATE [dbo].[Employees]
		SET    [EmpCode] = @EmpCode, [EmpTitle] = @EmpTitle, [FirstName] = @FirstName, [MiddleName] = @MiddleName, [LastName] = @LastName, [JoiningDate] = @JoiningDate, [DOB] = @DOB, [Gender] = @Gender, [WorkEmail] = @WorkEmail, [PersonalEmail] = @PersonalEmail, [DepartmentId] = @DepartmentId, [DesignationId] = @DesignationId, [ReportingTo] = @ReportingTo, [IDNo] = @IDNo, [FatherName] = @FatherName, [MobileNo] = @MobileNo, [LandlineNo] = @LandlineNo, [EmpStatus] = @EmpStatus, [ReleavingDate] = @ReleavingDate, [InActive] = @InActive, [CreatedBy] = @CreatedBy, [CreatedDate] = @CreatedDate, [UpdatedBy] = @UpdatedBy, [UpdatedDate] = @UpdatedDate,  [EmpType] = @EmpType, [InActiveDate] = @InActiveDate, [InActiveReason] = @InActiveReason, [BillingRate] = @BillingRate, [CostRate] = @CostRate, [BillingTarget] = @BillingTarget, [ExpenseEntry] = @ExpenseEntry, [PaymentMethod] = @PaymentMethod, [RateSGroup] = @RateSGroup, [VendorID] = @VendorID, [UserNumber] = @UserNumber, [UserId] = @UserId, [PayrollState] = @PayrollState, [HomePhoneNo] = @HomePhoneNo, [MaritalStaus] = @MaritalStaus, [SpouseName] = @SpouseName, [EthnicOrigin] = @EthnicOrigin,[Address]=@Address,CountryId=@CountryId,StateId=@StateId,CityId=@CityId,ZipcodeId=@ZipcodeId
		WHERE  [EmployeeId] = @EmployeeId
	
		-- Begin Return Select <- do not remove
		SELECT [EmployeeId], [EmpCode], [EmpTitle], [FirstName], [MiddleName], [LastName], [JoiningDate], [DOB], [Gender], [WorkEmail], [PersonalEmail], [DepartmentId], [DesignationId], [ReportingTo], [IDNo], [FatherName], [MobileNo], [LandlineNo], [EmpStatus], [ReleavingDate], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [EmpType], [InActiveDate], [InActiveReason], [BillingRate], [CostRate], [BillingTarget], [ExpenseEntry], [PaymentMethod], [RateSGroup], [VendorID], [UserNumber], [UserId], [PayrollState], [HomePhoneNo], [MaritalStaus], [SpouseName], [EthnicOrigin],[Address],[CountryId],[StateId],[CityId],[ZipcodeId]
		FROM   [dbo].[Employees]
		WHERE  [EmployeeId] = @EmployeeId	
		-- End Return Select <- do not remove
		END
		ELSE
		BEGIN
		SELECT -3
		END
	END
	ELSE
	BEGIN
	SELECT -2
	END
	COMMIT
GO

