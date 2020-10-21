ALTER PROC [dbo].[usp_EmployeesDelete] 
    @EmployeeId bigint,
	@UserId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN

	DELETE FROM [dbo].[Employees] WHERE  [EmployeeId] = @EmployeeId

	DELETE FROM [dbo].[Users] WHERE  [UserId] = @UserId

	COMMIT