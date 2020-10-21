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

/****** Object:  StoredProcedure [dbo].[usp_UsersGetAll]    Script Date: 4/3/2019 2:42:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_UsersGetAll] 
	@PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @Condition is null
SELECT @SQLStatement = 'SELECT Users.UserId, [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [isAuthorized], Users.[InActive], Users.[CreatedBy], Users.[CreatedDate], Users.[UpdatedBy], Users.[UpdatedDate],
	(Employees.FirstName+'' ''+CASE when LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) = '' '' then LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) ELSE LTRIM(RTRIM(Employees.MiddleName)) +'' ''end +Employees.LastName) AS FullName
	FROM   [dbo].[Users] inner join Employees on Employees.UserId = Users.UserId where Users.InActive = ''0'' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'select * from(SELECT Users.UserId, [Email], [EmailConfirmed], [PasswordHash], [SecurityStamp], [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEndDateUtc], [LockoutEnabled], [AccessFailedCount], [UserName], [isAuthorized], Users.[InActive], Users.[CreatedBy], Users.[CreatedDate], Users.[UpdatedBy], Users.[UpdatedDate],
	(Employees.FirstName+'' ''+CASE when LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) = '' '' then LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) ELSE LTRIM(RTRIM(Employees.MiddleName)) +'' ''end +Employees.LastName) AS FullName 
	FROM   [dbo].[Users] inner join Employees on Employees.UserId = Users.UserId where Users.InActive = ''0'') x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement

Select @CountStatement ='Select Count(*) as FilterCount from((select (Employees.FirstName+'' ''+CASE when LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) = '' '' then LTRIM(RTRIM(ISNULL(Employees.MiddleName,''''))) ELSE LTRIM(RTRIM(Employees.MiddleName)) +'' ''end +Employees.LastName) AS FullName from [dbo].[Users] inner join Employees on Employees.UserId = Users.UserId where Users.InActive = ''0'')) x ' +@Condition
END
EXEC(@SQLStatement)
EXEC(@CountStatement)
	

	COMMIT


	 
GO

