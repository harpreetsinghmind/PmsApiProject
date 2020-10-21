USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_CustomersGetAllParent]    Script Date: 09-09-2019 12:39:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROC [dbo].[usp_CustomersGetAllParent] 
    @PageNo bigint,
	@NoOfRecords bigint,
	@SortType nvarchar(50),
	@FieldName nvarchar(100),
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null,
	@All bit = 0
AS 
	SET NOCOUNT ON 
	 

	BEGIN TRAN

	DECLARE @SQLStatement varchar(MAX)
	DECLARE @CountStatement varchar(MAX)

	DECLARE @CommonQuery varchar(MAX)
	SET @CommonQuery = 'SELECT DISTINCT customers.[CustomerId], [CustomerName]'+ CASE WHEN @ALL = 0 THEN ', [CustomerCode], [ShipingAddressId], [BillingAddressId], Customers.[BusinessTypeId],BusinessTypes.[BTName], Customers.[FaxNo], [Website], Customers.[Notes], [Logo], Customers.[InActive], Customers.[IsDeleted], [ParentId], Customers.[CreatedBy], Customers.[CreatedDate], Customers.[UpdatedBy], Customers.[UpdatedDate]' ELSE '' END +' from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId inner join Projects on Projects.CustomerId = Customers.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where ParentId is null and Customers.InActive = 0 and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) 
	DECLARE @CommonQuery2 varchar(MAX)
	SET @CommonQuery2 = 'SELECT DISTINCT customers.[CustomerId], [CustomerName]'+ CASE WHEN @ALL = 0 THEN ', [CustomerCode], [ShipingAddressId], [BillingAddressId], Customers.[BusinessTypeId],BusinessTypes.[BTName], Customers.[FaxNo], [Website], Customers.[Notes], [Logo], Customers.[InActive], Customers.[IsDeleted], [ParentId], Customers.[CreatedBy], Customers.[CreatedDate], Customers.[UpdatedBy], Customers.[UpdatedDate]' ELSE '' END + 'from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId inner join Projects on Projects.CustomerId = Customers.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where ParentId is null and Customers.InActive = 0 and Employees.UserId ='+ CAST(@UserId AS VARCHAR(MAX)) 
	DECLARE @CountQuery varchar(MAX)
	SET @CountQuery = 'SELECT COUNT(*) AS FilterCount FROM (Select DISTINCT customers.[CustomerId] from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId inner join Projects on Projects.CustomerId = Customers.CustomerId inner join ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId inner join Employees on Employees.EmployeeId = ProjectAssign.EmployeeId where ParentId is null and Customers.InActive = 0 and Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + ' and ' + @Condition +') AS T1'
	DECLARE @CountQuery2 varchar(MAX)
	SET @CountQuery2 = 'SELECT COUNT(*) AS FilterCount FROM (Select DISTINCT customers.[CustomerId] from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId inner join Projects on Projects.CustomerId = Customers.CustomerId inner join Employees on Employees.EmployeeId = Projects.ManagerId where ParentId is null and Customers.InActive = 0 and Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) + ' and ' + @Condition +') AS T1'
    
-- Enter the dynamic SQL statement into the
-- variable @SQLStatement
IF @UserType = 1
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'SELECT DISTINCT customers.[CustomerId], [CustomerName]' + 
			CASE WHEN @ALL = 0 
				THEN ', [CustomerCode], [ShipingAddressId], [BillingAddressId], Customers.[BusinessTypeId],BusinessTypes.[BTName], Customers.[FaxNo], [Website], Customers.[Notes], [Logo], Customers.[InActive], Customers.[IsDeleted], [ParentId], Customers.[CreatedBy], Customers.[CreatedDate], Customers.[UpdatedBy], Customers.[UpdatedDate]' 
				ELSE '' END 
		+ ' from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId where ParentId is null order by ' + @FieldName+ ' '+ @SortType + 
			CASE WHEN @ALL = 0 
				THEN ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)'
				ELSE '' END
		 ELSE
		 BEGIN
		 SELECT @SQLStatement = 'SELECT DISTINCT customers.[CustomerId], [CustomerName]'+ 
			CASE WHEN @ALL = 0 
				THEN ', [CustomerCode], [ShipingAddressId], [BillingAddressId], Customers.[BusinessTypeId],BusinessTypes.[BTName], Customers.[FaxNo], [Website], Customers.[Notes], [Logo], Customers.[InActive], Customers.[IsDeleted], [ParentId], Customers.[CreatedBy], Customers.[CreatedDate], Customers.[UpdatedBy], Customers.[UpdatedDate]' 
				ELSE '' END 
		 + ' from [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId where ParentId is null and ' + @Condition + ' order by ' + @FieldName+ ' '+ @SortType + 
			CASE WHEN @ALL = 0 
				THEN ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)' 
				ELSE '' END
		-- Execute the SQL statement
		Select @CountStatement ='SELECT COUNT(*) AS FilterCount FROM [Customers] inner join BusinessTypes on BusinessTypes.BusinessTypeId=Customers.BusinessTypeId where ParentId is null  and ' + @Condition 
		End
	END
ELSE
	BEGIN
		IF @Condition is null
		SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery + ') UNION ('+ @CommonQuery2 +')) x order by x.'+@FieldName+' '+@SortType+ CASE WHEN @ALL = 0 THEN ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)' ELSE '' END
		 ELSE
		 BEGIN
		 SELECT @SQLStatement = 'select DISTINCT * from(('+ @CommonQuery +' and '+@Condition+ ') UNION ('+ @CommonQuery2 +' and '+@Condition+ ')) x order by x.'+@FieldName+' '+@SortType+ CASE WHEN @ALL = 0 THEN ' OFFSET '+ CAST(@NoOfRecords * (@PageNo - 1) as varchar(MAX))+ '  ROWS FETCH NEXT ' + CAST(@NoOfRecords as varchar(50)) + ' ROWS ONLY OPTION (RECOMPILE)' ELSE '' END
		-- Execute the SQL statement
		Select @CountStatement = 'select DISTINCT * from((' + @CountQuery +') UNION ('+ @CountQuery2 +')) x'
		End
	END

-- print @SQLStatement;

EXEC(@SQLStatement)
EXEC(@CountStatement)
COMMIT
