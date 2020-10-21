ALTER PROCEDURE [dbo].[usp_BudgetCriteriaSelect]  
  
  
AS  
BEGIN  
   
           SELECT BudgetId,  
				 [Description],  
				  MinValue,  
				  MaxValue  
     FROM BudgetCriteria  
  
END