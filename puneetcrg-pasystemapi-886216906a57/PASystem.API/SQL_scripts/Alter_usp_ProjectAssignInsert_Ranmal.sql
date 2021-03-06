USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ProjectAssignInsert]    Script Date: 7/12/2019 12:19:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_ProjectAssignInsert] 
	@AssignId bigint = NULL,
	@ProjectId bigint,
   	@EmployeeId bigint,
    @RoleId bigint,
	@WorkingHours int,
	@BillableCost int,
	@Multiplier int,
	@InActive bit,
	@Assigned bit,
	@ReportingTo bigint

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	 IF @AssignId IS NULL
	 BEGIN
		INSERT INTO [dbo].[ProjectAssign]
				([ProjectId]
				,[EmployeeId]
				,[RoleId]
				,[WorkingHours]
				,[BillableCost]
				,[Multiplier]
				,[InActive]
				,[Assigned]
				,[UpdatedDate]
				,[ReportingTo]
				)
		VALUES
				(@ProjectId
				,@EmployeeId
				,@RoleId
				,@WorkingHours
				,@BillableCost
				,@Multiplier
				,@InActive
				,@Assigned
				,GETDATE()
				,@ReportingTo
				)
		SELECT SCOPE_IDENTITY()
	 END
	 ELSE
	 BEGIN
		 IF EXISTS (select * from ProjectAssign WHERE AssignId = @AssignId AND [Assigned] = @Assigned)
		 BEGIN
			UPDATE [dbo].[ProjectAssign]
			SET [ProjectId] = @ProjectId
				,[EmployeeId] = @EmployeeId
				,[RoleId] = @RoleId
				,[WorkingHours] = @WorkingHours
				,[BillableCost] = @BillableCost
				,[Multiplier] = @Multiplier
				,[InActive] = @InActive
				,[Assigned] = @Assigned
				,[ReportingTo] = @ReportingTo
			WHERE AssignId = @AssignId
		END
		ELSE
		BEGIN
			UPDATE [dbo].[ProjectAssign]
			SET [ProjectId] = @ProjectId
				,[EmployeeId] = @EmployeeId
				,[RoleId] = @RoleId
				,[WorkingHours] = @WorkingHours
				,[BillableCost] = @BillableCost
				,[Multiplier] = @Multiplier
				,[InActive] = @InActive
				,[Assigned] = @Assigned
				,[UpdatedDate] = GETDATE()
				,[ReportingTo] = @ReportingTo
			WHERE AssignId = @AssignId
			SELECT @AssignId
		END
	END
	COMMIT
