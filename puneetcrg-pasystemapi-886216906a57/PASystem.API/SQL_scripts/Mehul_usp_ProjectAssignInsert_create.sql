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

/****** Object:  StoredProcedure [dbo].[usp_ProjectAssignInsert]    Script Date: 5/27/2019 7:35:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[usp_ProjectAssignInsert] 
	@AssignId bigint = NULL,
	@ProjectId bigint,
   	@EmployeeId bigint,
    @RoleId bigint,
	@WorkingHours int,
	@BillableCost int,
	@InActive bit,
	@Assigned bit

    
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
				,[InActive]
				,[Assigned]
				)
		VALUES
				(@ProjectId
				,@EmployeeId
				,@RoleId
				,@WorkingHours
				,@BillableCost
				,@InActive
				,@Assigned
				)
		SELECT SCOPE_IDENTITY()
	 END
	 ELSE
	 BEGIN
		UPDATE [dbo].[ProjectAssign]
		SET [ProjectId] = @ProjectId
			,[EmployeeId] = @EmployeeId
			,[RoleId] = @RoleId
			,[WorkingHours] = @WorkingHours
			,[BillableCost] = @BillableCost
			,[InActive] = @InActive
			,[Assigned] = @Assigned
		WHERE AssignId = @AssignId
		SELECT @AssignId
	 END
	COMMIT
GO

