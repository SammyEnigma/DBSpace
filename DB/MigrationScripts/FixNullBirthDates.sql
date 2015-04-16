USE LCCHPDev
GO
DROP TABLE DateRanges

CREATE TABLE DateRanges (
  StartDate DATE NOT NULL,
  EndDate DATE NOT NULL
);
GO

ALTER TABLE DateRanges
ADD CONSTRAINT CK_PositiveRange CHECK (EndDate > StartDate);

INSERT INTO DateRanges (
  StartDate,
  EndDate
)
VALUES
  ('1968-01-01 22:30', '2015-01-05');
GO

select * from DateRanges

select BirthDate,PersonID into ##BirthDateLess  from Person where BirthDate is null or PersonCode in ('10576','10577')


DECLARE @Counter int = 1, @NewBirthDate date;

	SELECT
	  @NewBirthDate = DATEADD(
		MINUTE,
		ABS(CHECKSUM(NEWID())) % DATEDIFF(MINUTE, StartDate, EndDate) + DATEDIFF(MINUTE, 0, StartDate),
		0
	  )
	FROM DateRanges;

WHILE @Counter < 20
BEGIN 
	Update Person set BirthDate = @NewBirthDate where PersonID = (Select Max(PersonID) from Person where BirthDate is null or PersonCode in ('10576','10577'))
	SELECT @NewBirthDate =
	  DATEADD(
		MINUTE,
		ABS(CHECKSUM(NEWID())) % DATEDIFF(MINUTE, StartDate, EndDate) + DATEDIFF(MINUTE, 0, StartDate),
		0
	  ) 
	FROM DateRanges;

	SELECT @COUNTER +=1;
END




select BirthDate,PersonID from Person where  PersonID in (Select PersonID from ##BirthDateLess )

DROP Table ##BirthDateLess

exec usp_SlPeopleCountByAge