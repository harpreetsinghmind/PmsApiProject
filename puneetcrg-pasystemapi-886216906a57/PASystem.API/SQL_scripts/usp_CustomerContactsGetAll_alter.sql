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

/****** Object:  StoredProcedure [dbo].[usp_CustomerContactsGetAll]    Script Date: 3/22/2019 4:33:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomerContactsGetAll] 
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
SELECT @SQLStatement = 'SELECT [CContactId], CustomerContacts.[CustomerId], [CTitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [DOB], [Gender], [WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate],CustomerContacts.[Notes] FROM [dbo].[CustomerContacts] order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
BEGIN
SELECT @SQLStatement = 'select * from (SELECT [CContactId], CustomerContacts.[CustomerId],[CTitle], [FirstName], [MiddleName], [LastName],(FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName, [DOB], [Gender], [WorkEmail], [OtherEmail], CustomerContacts.[AddressId], CustomerContacts.[MobileNo], CustomerContacts.[TelephoneNo],CustomerContacts.[InActive], CustomerContacts.[CreatedBy], CustomerContacts.[CreatedDate], CustomerContacts.[UpdatedBy], CustomerContacts.[UpdatedDate], CustomerContacts.[Notes] FROM [dbo].[CustomerContacts]) x '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM (SELECT (FirstName+'' ''+CASE when LTRIM(RTRIM(MiddleName)) = '' '' then LTRIM(RTRIM(MiddleName)) ELSE LTRIM(RTRIM(MiddleName)) +'' ''end +LastName) AS FullName FROM [dbo].[CustomerContacts]) x ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)
COMMIT
GO

