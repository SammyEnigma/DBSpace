USE LCCHPTestImport
GO

Insert into ReviewStatus (HistoricReviewStatusID,ReviewStatusName)
Select ReviewStatusCode,ReviewStatus from TESTAccessImport..lkDataReview

Select ReviewStatusCode from TESTAccessImport..lkDataReview where ReviewStatusCode not in (Select historicReviewStatusID from ReviewStatus)

Select Count(*) from ReviewStatus
Select Count(*) from TESTAccessImport..lkDataReview

Select * from ReviewStatus
Select * from TESTAccessImport..lkDataReview