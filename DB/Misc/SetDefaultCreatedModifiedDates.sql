 /* Create triggers for all tables with an ID column name of the form: tableName + ID
 */

DECLARE @Table varchar(50), @UpdateModifiedDate Varchar(2000), @UpdateCreatedDate Varchar(2000);
DECLARE tables_cursor Cursor for
	Select name from sys.tables where is_filetable = 0 
			and (name not like 'Personto%' or name not like 'Contractorto%'
				or name not like 'PropertyTo%' or name not like 'ForeignFoodto%'
				or name not like 'DayCaretoProperty')
CREATE TABLE ##UpdateDates (SQLCMD VARCHAR(2000))
open tables_cursor
FETCH NEXT FROM tables_cursor INTO @Table

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO ##UpdateDates SELECT 'update ' + @Table + ' set ModifiedDate = getdate()' 

	INSERT INTO ##UpdateDates SELECT 'update ' + @Table + ' set CreatedDate = getdate() where CreatedDate is null' 

	
-- SELECT (@UpdateCreatedDate);
	
	FETCH NEXT FROM tables_cursor INTO @Table
END

CLOSE tables_cursor
DEALLOCATE tables_cursor

SELECT * FROM ##UpdateDates
DROP Table ##UpdateDates