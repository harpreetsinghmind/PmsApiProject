CREATE PROCEDURE [dbo].[usp_VerifyToken]
(
	@Token NVARCHAR(MAX)
)
AS
BEGIN
		SELECT	*
		FROM	[dbo].[ForgotPasswordToken] T
		join	[dbo].[Users] U on T.UserId = U.UserId
		WHERE	u.InActive = 0
		AND		U.EmailConfirmed = 1
		AND		T.IsActive = 1
		AND		T.Token = @Token
		AND     T.ExpiryDate >= GETDATE()
END