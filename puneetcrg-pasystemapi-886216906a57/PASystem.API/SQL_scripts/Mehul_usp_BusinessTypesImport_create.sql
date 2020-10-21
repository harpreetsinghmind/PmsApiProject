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

/****** Object:  StoredProcedure [dbo].[usp_BusinessTypesImport]    Script Date: 8/13/2019 4:40:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_BusinessTypesImport] 
	@BusinessType nvarchar(300),
    @InActive bit,
	@IsDeleted bit,
	@allowEdit bit,
	@allowAdd bit
AS 
			IF NOT EXISTS(SELECT * FROM  BusinessTypes WHERE LOWER(BTName) =LOWER(@BusinessType))
				BEGIN
					IF @IsDeleted = 0 
						BEGIN
							IF @allowAdd = 1
								BEGIN
									INSERT INTO [dbo].[BusinessTypes] 
									   ([BTName], 
										[InActive], 
										[CreatedDate])
									SELECT 
										@BusinessType, 
										@InActive, 
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
							DELETE FROM [BusinessTypes] WHERE LOWER(BTName) =LOWER(@BusinessType)
							SELECT 3 --DELETE
						END
					ELSE
						BEGIN
							IF @allowEdit = 1
								BEGIN
									UPDATE [BusinessTypes] 
										SET [BTName] = @BusinessType, 
											[InActive] = @InActive, 
											[UpdatedDate]= GETDATE()
									WHERE LOWER(BTName) =LOWER(@BusinessType)
									SELECT 1 --UPDATE
								END
							ELSE
								BEGIN
									SELECT 5
								END
						END
				END
	-- End Return Select <- do not remove
               
	
GO

