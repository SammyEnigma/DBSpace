USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@InsertedAccessAgreementID int

EXEC	@return_value = [dbo].[usp_InsertAccessAgreement]
		@AccessPurposeID = 1,
		@Notes = N'Initial inspection of property',
		@AccessAgreementFile = NULL,
		@PropertyID = 2359,
		@InsertedAccessAgreementID = @InsertedAccessAgreementID OUTPUT



Select AA.* from AccessAgreement AS AA
RIGHT OUTER join AccessAgreementNotes AS AAN on AA.AccessAgreementID = AAN.AccessAgreementNotesID