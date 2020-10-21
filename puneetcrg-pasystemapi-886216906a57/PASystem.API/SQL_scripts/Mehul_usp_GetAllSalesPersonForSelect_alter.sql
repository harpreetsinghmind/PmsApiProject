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

/****** Object:  StoredProcedure [dbo].[usp_GetAllSalesPersonForSelect]    Script Date: 7/10/2019 2:43:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER PROC [dbo].[usp_GetAllSalesPersonForSelect]
	@UserId bigint,
	@UserType int 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
		BEGIN
			SELECT 
				 [SalesPerson].SalesPersonId,
				 LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
				 CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
				END +
				LTRIM(RTRIM(ISNULL([SalesPerson].LastName, ''))) as SalesPersonName
			FROM   
				[dbo].[SalesPerson] 
			WHERE 
				[SalesPerson].InActive=0
		END
	ELSE
		BEGIN
			select DISTINCT * from((SELECT 
				 [SalesPerson].SalesPersonId,
				 LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
				 CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
				END +
				LTRIM(RTRIM(ISNULL([SalesPerson].LastName, ''))) as SalesPersonName
			FROM   
				[dbo].[SalesPerson] 
				inner join Projects on Projects.SalesPersonId = SalesPerson.SalesPersonId 
				inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
				inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
			WHERE 
			Employees.UserId = @UserId and [SalesPerson].InActive=0)
			UNION
			(SELECT 
				 [SalesPerson].SalesPersonId,
				 LTRIM(RTRIM(ISNULL([SalesPerson].FirstName, ''))) + ' '+
				 CASE WHEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([SalesPerson].MiddleName, ''))) + ' '
				END +
				LTRIM(RTRIM(ISNULL([SalesPerson].LastName, ''))) as SalesPersonName
			FROM   
				[dbo].[SalesPerson] 
				inner join Projects on Projects.SalesPersonId = SalesPerson.SalesPersonId 
				inner join Employees on Employees.EmployeeId = Projects.ManagerId
			WHERE 
			Employees.UserId = @UserId and [SalesPerson].InActive=0)) x
		END
	COMMIT
GO

