DECLARE @LID int;

EXEC usp_insertLanguage 'Italian', @LID OUTPUT

select 'INSERTED LANGUAGE ID: ' + CAST(@LID as varchar)

select * from language