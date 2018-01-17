SET NOCOUNT ON;
go
exec tSQLt.NewTestClass 'Test_Calculate_Entropy';
go
CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__Object__Exists__dbo_Calculate_Entropy 
as
BEGIN

	exec tSQLt.AssertObjectExists 
	@ObjectName = 'dbo.Calculate_Entropy'
END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__Object__Exists__dbo_Entropy_Dataset 
as
BEGIN

	if not exists (select 1 from sys.types where name = 'Entropy_Dataset')
		exec tSQLt.Fail @Message0='Table Type object dbo.Entropy_Dataset does not exist'

END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__Columns__dbo_Entropy_Dataset 
as
BEGIN

	/*Set Up*/
	select
	column_name
	,data_type_name
	,is_nullable
	,precision
	,scale,max_length
	into #Expected
	from
	(values
		('Member_Name','nvarchar',0,0,0,1000)
		,('Member_Count','bigint',0,19,0,8)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)

	/*Execute*/
	select
	c.name as[column_name]
	,t.name as [data_type_name]
	,c.is_nullable
	,c.precision
	,c.scale
	,c.max_length
	into #Actual
	from
	sys.table_types tt
	inner join
	sys.columns c
	on
	tt.type_table_object_id=c.object_id
	inner join
	sys.types t
	on
	c.user_type_id=t.user_type_id
	where
	tt.name='Entropy_Dataset'
	and
	tt.schema_id=schema_id('dbo')


	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'

END
go

exec tSQLt.RunAll;