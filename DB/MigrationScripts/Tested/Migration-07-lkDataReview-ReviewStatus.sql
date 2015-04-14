USE LCCHPTestImport
GO

Insert into ReviewStatus (HistoricReviewStatusID,ReviewStatusName)
Select ReviewStatusCode,ReviewStatus from TESTAccessImport..lkDataReview


Select * from ReviewStatus
Select * from TESTAccessImport..lkDataReview