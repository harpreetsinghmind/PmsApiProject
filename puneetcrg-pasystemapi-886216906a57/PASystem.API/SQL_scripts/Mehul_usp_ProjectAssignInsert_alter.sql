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

/****** Object:  StoredProcedure [dbo].[usp_ProjectAssignInsert]    Script Date: 7/31/2019 2:11:36 PM ******/
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
				,[AssignDate]
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
GO

