USE LCCHPPublic
GO
set nocount on

Insert into ReviewStatus (HistoricReviewStatusID,ReviewStatusName)
Select ReviewStatusCode,ReviewStatus from LCCHPImport..lkDataReview

select 'Rows in lkdatareview that are not in ReviewStatus'
Select ReviewStatusCode from LCCHPImport..lkDataReview where ReviewStatusCode not in (Select historicReviewStatusID from ReviewStatus)

select 'comparing row count of ReviewStatus and lkdataReview'
Select Count(*) from ReviewStatus
Select Count(*) from LCCHPImport..lkDataReview

select 'listing ReviewStatus rows and lkDataReview rows'
Select HistoricReviewStatusID,ReviewStatusName from ReviewStatus
Select * from LCCHPImport..lkDataReview