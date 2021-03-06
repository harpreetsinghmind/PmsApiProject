USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetCustomerSummary]    Script Date: 7/25/2019 1:33:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetCustomerSummary] 
    @UserId bigint,
	@UserType int
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
	BEGIN
		SELECT 
			c.CustomerId,
			c.CustomerName,
			CASE c.InActive
				WHEN 0 THEN 'Active'
				WHEN 1 THEN 'InActive'
			END as Status 
		FROM  
			Customers c
	END
	ELSE
	BEGIN
		SELECT 
		c.CustomerId,
		c.CustomerName,
		CASE c.InActive
			WHEN 0 THEN 'Active'
			WHEN 1 THEN 'InActive'
		END as Status 
		FROM  
			Customers c
			INNER JOIN Projects p on p.CustomerId = c.CustomerId
			INNER JOIN ProjectAssign pa on pa.ProjectId = p.ProjectId
			INNER JOIN Employees e on pa.EmployeeId = e.EmployeeId
		WHERE
			e.UserId = @UserId
	END
	COMMIT
