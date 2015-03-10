 /* Create triggers for all tables with an ID column name of the form: tableName + ID
 */

DECLARE @Table varchar(50), @CreateTrigger Varchar(2000);
DECLARE tables_cursor Cursor for
	Select name from sys.tables where is_filetable = 0 
			and (name not like 'Personto%' or name not like 'Contractorto%'
				or name not like 'PropertyTo%' or name not like 'ForeignFoodto%'
				or name not like 'DayCaretoProperty')

open tables_cursor
FETCH NEXT FROM tables_cursor INTO @Table

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @CreateTrigger = 'create trigger trUpdate' + @Table + ' on ' + @Table + ' AFTER UPDATE
	as
	 begin
	  if @@rowcount = 0
		return
	  if not update(ModifiedDate) update ' + @Table + ' set ModifiedDate = getdate() where ' + @Table + 'ID in (select ' + @Table + 'ID from inserted)

	end'

	SELECT (@CreateTrigger);
	
	FETCH NEXT FROM tables_cursor INTO @Table
END

CLOSE tables_cursor
DEALLOCATE tables_cursor