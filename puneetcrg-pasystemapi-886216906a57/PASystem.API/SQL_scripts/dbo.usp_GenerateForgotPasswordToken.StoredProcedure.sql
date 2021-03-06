CREATE PROC [dbo].[usp_GenerateForgotPasswordToken] 
    @Email nvarchar(256)
AS 
	SET NOCOUNT ON 
	SET XACT_ABORT ON  

	DECLARE @UserId BIGINT
	DECLARE @Token NVARCHAR(100) = NULL

	SELECT @UserId = [UserId]
	FROM [dbo].[Users] U (NOLOCK)
	WHERE U.[Email] = @Email
	AND U.[InActive] = 0

	IF @UserId IS NOT NULL
	BEGIN
		UPDATE [dbo].[ForgotPasswordToken]
		SET [IsActive] = 0
		WHERE [UserId]= @UserId

		SET @Token = NewID()

		INSERT INTO [dbo].[ForgotPasswordToken]
		(	[UserId]
		,	[Token]
		)
		VALUES
		(	@UserId
		,	@Token
		)
	END

	SELECT @Token
GO
