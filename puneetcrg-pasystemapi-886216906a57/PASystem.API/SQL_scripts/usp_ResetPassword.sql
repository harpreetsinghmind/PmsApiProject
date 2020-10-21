CREATE PROCEDURE [dbo].[usp_ResetPassword]
(
	@Token NVARCHAR(MAX),
	@Password NVARCHAR(MAX)
)
AS
BEGIN
		DECLARE @UserId BIGINT 
		SELECT	@UserId = U.UserId
		FROM	[dbo].[ForgotPasswordToken] T
		join	[dbo].[Users] U on T.UserId = U.UserId
		WHERE	u.InActive = 0
		AND		U.EmailConfirmed = 1
		AND		T.IsActive = 1
		AND		T.Token = @Token
		AND     T.ExpiryDate >= GETDATE()

		UPDATE Users
		SET	   PasswordHash = @Password
		WHERE  UserId = @UserId

		UPDATE  ForgotPasswordToken
		SET		IsActive = 0
		WHERE	Token = @Token
END