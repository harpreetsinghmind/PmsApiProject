
--Execute this query first
ALTER TABLE OrgStructureMapping
  ALTER COLUMN Attribute1 bigint NOT NULL;
  
  
--Execute this after first
  USE PASystemTest;  
GO  
EXEC sp_rename 'OrgStructureMapping.Attribute1', 'UserId', 'COLUMN';  
GO  

--Execute this for employees table
alter table Employees add Isdeleted bit NULL;
