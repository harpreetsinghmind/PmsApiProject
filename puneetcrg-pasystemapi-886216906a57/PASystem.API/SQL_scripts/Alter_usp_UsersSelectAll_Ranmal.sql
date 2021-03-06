USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_UsersSelectAll]    Script Date: 8/9/2019 11:50:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[usp_UsersSelectAll] 
	AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
SELECT 
	Users.[UserId], 
	[Email], 
	[EmailConfirmed], 
	[PasswordHash], 
	[SecurityStamp], 
	[PhoneNumber], 
	[PhoneNumberConfirmed], 
	[TwoFactorEnabled], 
	[LockoutEndDateUtc], 
	[LockoutEnabled], 
	[AccessFailedCount], 
	[UserName], 
	[isAuthorized], 
	Users.[InActive], 
	Users.[CreatedBy],
	Users.[CreatedDate], 
	Users.[UpdatedBy], 
	Users.[UpdatedDate] ,
	Employees.ReleavingDate,
	(LTRIM(RTRIM(ISNULL([Employees].FirstName, ''))) + ' '+
		CASE WHEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) = ''
			THEN LTRIM(RTRIM(ISNULL([Employees].MiddleName, '')))
			ELSE LTRIM(RTRIM(ISNULL([Employees].MiddleName, ''))) + ' '
		END +
	LTRIM(RTRIM(ISNULL([Employees].LastName, '''')))) AS EmployeeFullName
FROM  [dbo].[Users] 
	INNER JOIN Employees ON Employees.UserId = Users.UserId WHERE Users.InActive='false'
	

	COMMIT


	 
