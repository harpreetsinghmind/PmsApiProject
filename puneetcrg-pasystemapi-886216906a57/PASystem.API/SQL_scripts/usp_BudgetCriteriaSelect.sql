CREATE PROCEDURE [dbo].[usp_BudgetCriteriaSelect]


AS
BEGIN

 
           SELECT BudgetId,
		          [Description]
		   FROM BudgetCriteria

END