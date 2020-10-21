CREATE PROC [dbo].[usp_ProjectPhaseGetAllForExport] -- exec [usp_ProjectPhaseGetAllForExport] 10071,1, NULL
	@UserId bigint,
	@UserType int,
	@Condition nvarchar(MAX)=null
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	BEGIN TRAN

	DECLARE @sqlBasic1 NVARCHAR(MAX)
	DECLARE @sqlBasic2 NVARCHAR(MAX)
	DECLARE @SQLStatement varchar(MAX)


SET @sqlBasic1 ='
	SELECT   
		  ProjectPhase.ProjectId,  
		  [Code],
		  [Projects].[Name] AS ProjectName,
		  --ProjectPhase.Id AS PhaseId, 
		  ProjectPhase.Name AS PhaseName,  
		  --ProjectSubPhase.Id AS SubPhaseId,  
		  ProjectSubPhase.Name AS SubPhaseName,  
		  CONVERT(VARCHAR(20),ProjectPhase.EstimatedStartDate,103) AS [PhaseESDate],  
		  CONVERT(VARCHAR(20),ProjectPhase.StartDate,103) AS [PhaseSDate],  
		  CONVERT(VARCHAR(20),ProjectPhase.EndDate,103) AS [PhaseEDate],  
		  CONVERT(VARCHAR(20),ProjectPhase.ActualDate,103) AS [PhaseADate],  
		  Revenue,  
		  Budget,  
		  ProjectPhase.TargetCost AS [PhaseCostTarget],  
		  ProjectPhase.VendorTarget AS [PhaseVendorTarget],  
		  --(ProjectPhase.TargetCost - ProjectPhase.VendorTarget) AS [PhaseLaborTarget],  
		  (CASE WHEN ProjectPhase.BillingType = 1 THEN ''Billable'' WHEN ProjectPhase.BillingType = 2 THEN ''Non–Billable'' WHEN ProjectPhase.BillingType = 3 THEN ''FOC'' ELSE '''' END) AS [PhaseBillingType],  
		  ProjectPhase.Locked,
		  CONVERT(VARCHAR(20),ProjectSubPhase.EstimatedStartDate,103) AS [SubPhaseESDate],  
		  CONVERT(VARCHAR(20),ProjectSubPhase.StartDate,103) AS [SubPhaseSDate],  
		  CONVERT(VARCHAR(20),ProjectSubPhase.EndDate,103) AS [SubPhaseEDate],  
		  CONVERT(VARCHAR(20),ProjectSubPhase.ActualDate,103) AS [SubPhaseADate],  
		  ProjectSubPhase.TargetCost AS [SubPhaseCostTarget],  
		  ProjectSubPhase.VendorTarget AS [SubPhaseVendorTarget],  
		  --(ProjectSubPhase.TargetCost - ProjectSubPhase.VendorTarget) AS [SubPhaseLaborTarget],  
		  (CASE WHEN ProjectSubPhase.BillingType = 1 THEN ''Billable'' WHEN ProjectSubPhase.BillingType = 2 THEN ''Non–Billable'' WHEN ProjectSubPhase.BillingType = 3 THEN ''FOC'' ELSE '''' END) AS [SubPhaseBillingType]
     FROM ProjectPhase Inner join Projects On ProjectPhase.ProjectId = Projects.ProjectId 
	                   INNER JOIN ProjectSubPhase ON ProjectSubPhase.PhaseId = ProjectPhase.Id '  
     
   
 --SET @sqlBasic2 =' 
	-- SELECT   
	--	  ProjectSubPhase.Id AS SubPhaseId,  
	--	  ProjectSubPhase.Name AS PhaseName,  
	--	  ProjectSubPhase.PhaseId,  
	--	  [Code],
	--	  ProjectPhase.ProjectId,  
	--	  ProjectSubPhase.EstimatedStartDate AS ESDate,  
	--	  ProjectSubPhase.StartDate AS SDate,  
	--	  ProjectSubPhase.EndDate AS EDate,  
	--	  ProjectSubPhase.ActualDate AS ADate,  
	--	  ProjectSubPhase.TargetCost AS CostTarget,  
	--	  ProjectSubPhase.VendorTarget,  
	--	  (ProjectSubPhase.TargetCost - ProjectSubPhase.VendorTarget) AS LaborTarget,  
	--	  ProjectSubPhase.BillingType  
	--  FROM ProjectSubPhase INNER JOIN ProjectPhase ON ProjectSubPhase.PhaseId = ProjectPhase.Id 
	--                       Inner join Projects On ProjectPhase.ProjectId = Projects.ProjectId'  
 
  
 
	

	IF @UserType <> 1
	BEGIN
		SET @SQLStatement = 'SELECT x.* FROM(('+ @sqlBasic1 + 
								' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
								WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
								UNION
								(' + @sqlBasic1 +  
								' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
								INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
								WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
								) x  WHERE '+ ISNULL(@Condition,'1=1') 

		--SET @SQLStatement =  @SQLStatement + ' 
		--                       SELECT x.* FROM(('+ @sqlBasic2 + 
		--						' INNER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  
		--						WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
		--						UNION
		--						(' + @sqlBasic2 + 
		--						' INNER JOIN ProjectAssign on ProjectAssign.ProjectId = Projects.ProjectId
		--						INNER JOIN Employees on Employees.EmployeeId = ProjectAssign.EmployeeId
		--						WHERE  Employees.UserId =' + CAST(@UserId AS VARCHAR(MAX)) +')
		--						) x  WHERE '+ ISNULL(@Condition,'1=1') 

	END
	ELSE
	BEGIN
		SET @SQLStatement = 'SELECT x.* FROM(('+ @sqlBasic1 + 
								' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  ) x 
								INNER JOIN Projects on Projects.Code = x.[Code]) WHERE '+ ISNULL(@Condition,'1=1') 

		--SET @SQLStatement = @SQLStatement + '
		--									SELECT x.* FROM(('+ @sqlBasic2 + 
		--									' LEFT OUTER JOIN Employees on Employees.EmployeeId=Projects.ManagerId  ) x 
		--									INNER JOIN Projects on Projects.Code = x.[Code]) WHERE '+ ISNULL(@Condition,'1=1') 
	END

	--PRINT @SQLStatement
    EXEC(@SQLStatement)

	
COMMIT


