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

/****** Object:  StoredProcedure [dbo].[usp_StatesSelectByCountry]    Script Date: 3/7/2019 12:08:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_StatesSelectByCountry] 
    @CountryId bigint
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	SELECT [StateId], [CountryId], [StateName], [StateCode], [InActive], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate] ,[Notes] 
	FROM   [dbo].[States] 
	WHERE  ([CountryId] = @CountryId) and [InActive]= 'false'

	COMMIT
GO

