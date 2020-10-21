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

/****** Object:  StoredProcedure [dbo].[usp_ProjectUpdate]    Script Date: 7/12/2019 12:26:49 PM ******/
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
	@ContactPersonId bigint,
    @InActive bit,
	@PlannedStartDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@ActualDate DATETIME,
    @UpdatedBy nvarchar(255) = NULL,
	@PaymentType int,
	@WorkingDays nvarchar(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
		IF NOT EXISTS(SELECT * FROM  Projects WHERE (lower(Name) =LOWER(@Name) and CustomerId = @CustomerId) and ProjectId <> @ProjectId )
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
			[ContactPersonId] = @ContactPersonId, 
			[InActive] = @InActive, 
			[PlannedStartDate] = @PlannedStartDate,
			[StartDate] = @StartDate,
			[EndDate] = @EndDate,
			[ActualDate] = @ActualDate, 
			[UpdatedBy] = @UpdatedBy, 
			[PaymentType] = @PaymentType,
			[WorkingDays] = @WorkingDays,
			[UpdatedDate] = GETDATE()
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

		-- Begin Return Select <- do not remove
		SELECT 
			ProjectId
		FROM   
			[dbo].[Projects]
		WHERE 
			 ProjectId = @ProjectId	

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

