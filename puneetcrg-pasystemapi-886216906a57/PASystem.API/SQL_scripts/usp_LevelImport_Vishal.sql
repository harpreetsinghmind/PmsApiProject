ALTER PROC [dbo].[usp_LevelImport] 

    @Name nvarchar(500),
    @Description nvarchar(MAX),
	@InActive bit,
	@OrgSOrder int,
	@Notes nvarchar(MAX),
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
	
IF NOT EXISTS(SELECT * FROM  OrgStructure WHERE LOWER(Name) =LOWER(@Name))
	BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[OrgStructure] 
									   ([Name], 
										[Description],
										[InActive],
										[OrgSOrder],
										[Notes],
										[CreatedDate])
									SELECT 
										@Name, 
										@Description,
										@InActive, 
										@OrgSOrder,
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
							DELETE FROM [OrgStructure] WHERE LOWER(Name) =LOWER(@Name)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [OrgStructure] 
										SET [name] = @Name,
											[Description] = @Description,
											[InActive] = @InActive,
											[OrgSOrder] = @OrgSOrder,
											[Notes] = @Notes,
											[UpdatedDate]= GETDATE()
									WHERE LOWER(Name) =LOWER(@Name)
									SELECT TOP 1 OrgStructureId FROM [OrgStructure] WHERE LOWER(Name) =LOWER(@Name)  --UPDATE
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
	END
	-- End Return Select <- do not remove
              
