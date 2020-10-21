USE [PASystem]
GO
/****** Object:  StoredProcedure [dbo].[usp_ResetPassword]    Script Date: 6/19/2019 2:59:38 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[usp_ResetPassword]
(
	@UserId BIGINT ,
	@Password NVARCHAR(MAX)
)
AS
BEGIN
		UPDATE Users
		SET	   PasswordHash = @Password
		WHERE  UserId = @UserId
END
