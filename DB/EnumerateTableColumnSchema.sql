
declare @SchemaTable varchar(200)
declare SchemaTables cursor for
select Table_Name from information_schema.tables 
create table ##TableColumnDetails (TableName varchar(200), ColumnName varchar(200),DataType varchar(50),
                                   MLength varchar(20), Prec int, Scale int, isNullable bit, PK bit)



open SchemaTables
FETCH Next from SchemaTables into @SchemaTable
while @@FETCH_STATUS = 0
BEGIN

Insert into ##TableColumnDetails 
								 SELECT @SchemaTable,
								c.name,
								t.Name,
								c.max_length ,
								c.precision ,
								c.scale ,
								c.is_nullable,
								ISNULL(i.is_primary_key, 0) 
								FROM    
									sys.columns c
								INNER JOIN 
									sys.types t ON c.user_type_id = t.user_type_id
								LEFT OUTER JOIN 
									sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
								LEFT OUTER JOIN 
									sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
								WHERE
									c.object_id = OBJECT_ID(@SchemaTable)
									-- and c.is_Nullable = 0
	
	
	FETCH Next from SchemaTables into @SchemaTable
END
close SchemaTables
Deallocate SchemaTables

select * from ##TableColumnDetails
order by TableName,ColumnName
-- order by columnName, DataType,MLength

drop table ##TableColumnDetails


-- usp_columnDetails 'AccessAgreement'