CREATE TABLE [dbo].[ForgotPasswordToken](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[Token] [nvarchar](100) NOT NULL,
	[IsActive] [bit]  DEFAULT(1),
	[CreatedDate] [datetime] NULL DEFAULT(GETDATE()),
	[ExpiryDate] [datetime] NULL DEFAULT(GETDATE() + 1),
	[UpdatedDate] [datetime] NULL,
	CONSTRAINT [FK_ForgotPasswordToken_UserId] FOREIGN KEY ([UserId])
    REFERENCES [dbo].[Users]([UserId]),
	CONSTRAINT [PK_ForgotPasswordToken] PRIMARY KEY CLUSTERED ([Id] ASC)
	WITH (	PAD_INDEX = OFF, 
			STATISTICS_NORECOMPUTE = OFF, 
			IGNORE_DUP_KEY = OFF, 
			ALLOW_ROW_LOCKS = ON, 
			ALLOW_PAGE_LOCKS = ON
		) ON [PRIMARY]
) ON [PRIMARY]
GO

