/*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4001)
    Source Database Engine Edition : Microsoft SQL Server Express Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2017
    Target Database Engine Edition : Microsoft SQL Server Standard Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [PASystemTest]
GO
/****** Object:  StoredProcedure [dbo].[usp_CitiesGetAll]    Script Date: 3/15/2019 6:22:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[usp_CitiesGetAll] 
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
SELECT @SQLStatement = 'SELECT [CityId], [Cities].[StateId],[CityName], [AreaCode], [CityCode], [County], [Cities].[InActive], [Cities].[CreatedBy],Countries.CountryId, [Cities].[CreatedDate], [Cities].[UpdatedBy], [Cities].[UpdatedDate], [Cities].[Notes],States.StateName, Countries.CountryName FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
ELSE
Begin
SELECT @SQLStatement = 'SELECT [CityId], [Cities].[StateId],[CityName], [AreaCode], [CityCode], [County], [Cities].[InActive], [Cities].[CreatedBy],Countries.CountryId, [Cities].[CreatedDate], [Cities].[UpdatedBy], [Cities].[UpdatedDate], [Cities].[Notes], States.StateName, Countries.CountryName FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId '+@Condition+' order by ' + @FieldName+ ' '+ @SortType + ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
    
-- Execute the SQL statement
Select @CountStatement ='Select Count(*) as FilterCount FROM [dbo].[Cities] inner join States on States.StateId=Cities.StateId inner join Countries on Countries.CountryId=States.CountryId  ' +@Condition
End
EXEC(@SQLStatement)
EXEC(@CountStatement)

	COMMIT
