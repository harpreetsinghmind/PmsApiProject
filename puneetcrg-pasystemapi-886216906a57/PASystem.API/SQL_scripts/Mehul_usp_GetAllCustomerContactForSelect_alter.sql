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

/****** Object:  StoredProcedure [dbo].[usp_GetAllCustomerContactForSelect]    Script Date: 7/10/2019 2:43:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_GetAllCustomerContactForSelect] 
	@UserId bigint,
	@UserType int 
    AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN
	IF @UserType = 1
		BEGIN
			SELECT 
				 [CustomerContacts].CContactId,
				 LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
				 CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
					THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
					ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
				END +
				LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))) as ContactPersonName
			FROM   
				[dbo].[CustomerContacts] 
			WHERE 
				[CustomerContacts].InActive=0
		END
	ELSE
		BEGIN
			select DISTINCT * from((SELECT 
					 [CustomerContacts].CContactId,
					 LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
					 CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
						THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
						ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))) as ContactPersonName
				FROM   
					[dbo].[CustomerContacts] 
					inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
					inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId 
					inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
				WHERE 
					Employees.UserId = @UserId and [CustomerContacts].InActive=0)
				UNION
				(SELECT 
					 [CustomerContacts].CContactId,
					 LTRIM(RTRIM(ISNULL([CustomerContacts].FirstName, ''))) + ' '+
					 CASE WHEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) = ''
						THEN LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, '')))
						ELSE LTRIM(RTRIM(ISNULL([CustomerContacts].MiddleName, ''))) + ' '
					END +
					LTRIM(RTRIM(ISNULL([CustomerContacts].LastName, ''))) as ContactPersonName
				FROM   
					[dbo].[CustomerContacts] 
					inner join Projects on Projects.ContactPersonId = CustomerContacts.CContactId 
					inner join Employees on Employees.EmployeeId = Projects.ManagerId
				WHERE 
					Employees.UserId = @UserId and [CustomerContacts].InActive=0)) x
		END
	COMMIT
GO

