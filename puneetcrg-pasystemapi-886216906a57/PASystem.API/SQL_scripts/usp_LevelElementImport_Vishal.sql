ALTER PROC [dbo].[usp_LevelElementImport] 

    @Name nvarchar(500),
	@StructureName nvarchar(500),
    @Description nvarchar(MAX),
	@InActive bit,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
IF EXISTS(SELECT * FROM  OrgStructure WHERE LOWER(Name) =LOWER(@StructureName))
BEGIN	
	IF NOT EXISTS(SELECT * FROM  OrgStructureLevel WHERE LOWER(Name) =LOWER(@Name))
		BEGIN
						IF @IsDeleted = 0 
							BEGIN
								IF @allowAdd = 1
									BEGIN
										INSERT INTO [dbo].[OrgStructureLevel] 
										   ([Name], 
											[Description],
											[InActive],
											[Notes],
											[CreatedDate])
										SELECT 
											@Name, 
											@Description,
											@InActive, 
											@Notes,
											GETDATE()
	
										-- Begin Return Select <- do not remove
										select SCOPE_IDENTITY()
									END
								ELSE
									BEGIN
										SELECT 5
									END
							END
						ELSE
							BEGIN
								SELECT 2 --NOT FOUND
							END
		END
	ELSE
		BEGIN
						IF @IsDeleted = 1
							BEGIN
								DELETE FROM [OrgStructureLevel] WHERE LOWER(Name) =LOWER(@Name) AND OrgStructureId = (SELECT OrgStructureId FROM  OrgStructure WHERE LOWER(Name) =LOWER(@StructureName))
								SELECT 3 --DELETE
							END
						ELSE
							BEGIN
								IF @allowEdit = 1
									BEGIN
										UPDATE [OrgStructureLevel] 
											SET [OrgStructureId] = (SELECT OrgStructureId FROM  OrgStructure WHERE LOWER(Name) =LOWER(@StructureName)),
												[name] = @Name,
												[Description] = @Description,
												[InActive] = @InActive,
												[Notes] = @Notes,
												[UpdatedDate]= GETDATE()
										WHERE LOWER(Name) =LOWER(@Name)
										SELECT TOP 1 OrgStructureLevelId FROM [OrgStructureLevel] WHERE LOWER(Name) =LOWER(@Name)--UPDATE
									END
								ELSE
									BEGIN
										SELECT 5
									END
							END
		END
END
ELSE
BEGIN
	SELECT -1
END