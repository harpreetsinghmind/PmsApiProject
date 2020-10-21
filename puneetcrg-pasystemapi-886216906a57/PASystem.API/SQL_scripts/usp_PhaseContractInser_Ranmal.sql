USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_PhaseContractInser]    Script Date: 4/2/2019 3:24:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[usp_PhaseContractInser] 
    @PhaseId BIGINT,
	@Name NVARCHAR(255),
	@Path NVARCHAR(max),
    @CreatedBy NVARCHAR(255) = NULL

    
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  
	
	BEGIN TRAN
	IF NOT EXISTS(SELECT * FROM  [PhaseContract] WHERE PhaseId = @PhaseId)
    BEGIN
		INSERT INTO [dbo].[PhaseContract]
			   ([Name]
			   ,[Path]
			   ,[PhaseId]
			   ,[InActive]
			   ,[CreatedBy]
			   ,[CreatedDate])
		 VALUES
			   (@Name
			   ,@Path
			   ,@PhaseId
			   ,0
			   ,@CreatedBy
			   ,GETDATE())
	
		SELECT SCOPE_IDENTITY()
    END
	ELSE
	BEGIN
		UPDATE [dbo].[PhaseContract]
		 SET [Name] = @Name
		  ,[Path] = @Path
		  ,[UpdatedBy] = @CreatedBy
		  ,[UpdatedDate] = GETDATE()
		WHERE PhaseId = @PhaseId
		SELECT 1
	END
	               
	COMMIT
