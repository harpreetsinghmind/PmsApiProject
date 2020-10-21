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

/****** Object:  StoredProcedure [dbo].[usp_SalesPersonGetAllForExport]    Script Date: 3/1/2019 2:52:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_SalesPersonGetAllForExport] 
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT ROW_NUMBER() OVER (ORDER BY SalesPersonId) AS 'Sr. No',[STitle] as Title, [FirstName], [MiddleName], [LastName], [DOB], [Gender], [WorkEmail], [OtherEmail],SalesPerson.[MobileNo], SalesPerson.[TelephoneNo],SalesPerson.[Notes],CASE SalesPerson.[InActive] 
 WHEN 1 THEN 'InActive' 
 WHEN 0 THEN 'Active'
 END as Status FROM [dbo].[SalesPerson]

	COMMIT
GO

