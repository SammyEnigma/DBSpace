CREATE TABLE [ErrorLog]
(	ErrorID int IDENTITY (1,1) NOT NULL,
	Username nvarchar(128) NOT NULL,
	ErrorNumber int NULL,
	ErrorSeverity int NULL,
	ErrorState int NULL,
	ErrorProcedure nvarchar(128) NULL,
	ErrorLine int NULL,
	ErrorMessage nvarchar(4000) NULL
	CONSTRAINT [PK_Error] PRIMARY KEY CLUSTERED 
	(
		[ErrorID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
);