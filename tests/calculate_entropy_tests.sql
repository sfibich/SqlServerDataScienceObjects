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
		,('Member_Count','decimal',0,9,0,5)
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



CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__Interface__Input__dbo_Calculate_Entropy 
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
		('@Entropy_Dataset','Entropy_Dataset',1,0,0,-1)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)

	/*Execute*/
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	into #Actual
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Entropy'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =0


	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'
END
go



CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__Interface__Output__dbo_Calculate_Entropy 
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
		('@Entropy','decimal',1,9,8,5)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)

	/*Execute*/
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	into #Actual
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Entropy'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =1

	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'
END
go


CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__dbo_Calculate_Entropy__2__Row__Input 
as
BEGIN

	/*Set Up*/
	declare @Entropy_Dataset Entropy_Dataset;
	declare @Actual_Entropy decimal(9,8);
	declare @Expected_Entropy decimal(9,8)=.88129090;

	insert into @Entropy_Dataset
	Values('Group 1',7);
	insert into @Entropy_Dataset
	Values('Group 2',3);


	/*Execute*/
	execute dbo.Calculate_Entropy
	@Entropy_Dataset = @Entropy_Dataset 
	,@Entropy=@Actual_Entropy OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Entropy,@Actual=@Actual_Entropy
END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__dbo_Calculate_Entropy__1__Row__Input 
as
BEGIN

	/*Set Up*/
	declare @Entropy_Dataset Entropy_Dataset;
	declare @Actual_Entropy decimal(9,8);
	declare @Expected_Entropy decimal(9,8)=0;

	insert into @Entropy_Dataset
	Values('Group 1',7);

	/*Execute*/
	execute dbo.Calculate_Entropy
	@Entropy_Dataset = @Entropy_Dataset 
	,@Entropy=@Actual_Entropy OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Entropy,@Actual=@Actual_Entropy
END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__dbo_Calculate_Entropy__Multi__Row__Input 
as
BEGIN

	/*Set Up*/
	declare @Entropy_Dataset Entropy_Dataset;
	declare @Actual_Entropy decimal(9,8);
	declare @Expected_Entropy decimal(9,8)=.88129090;

	insert into @Entropy_Dataset
	Values('Group 1',7);
	insert into @Entropy_Dataset
	Values('Group 2',2);
	insert into @Entropy_Dataset
	Values('Group 2',1);

	/*Execute*/
	execute dbo.Calculate_Entropy
	@Entropy_Dataset = @Entropy_Dataset 
	,@Entropy=@Actual_Entropy OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Entropy,@Actual=@Actual_Entropy
END
go


CREATE OR ALTER PROCEDURE Test_Calculate_Entropy.Test__dbo_Calculate_Entropy__4__Row__Input 
as
BEGIN

	/*Set Up*/
	declare @Entropy_Dataset Entropy_Dataset;
	declare @Actual_Entropy decimal(9,8);
	declare @Expected_Entropy decimal(9,8)=1.57095059;

	insert into @Entropy_Dataset
	Values('Group 1',6);
	insert into @Entropy_Dataset
	Values('Group 2',2);
	insert into @Entropy_Dataset
	Values('Group 3',1);
	insert into @Entropy_Dataset
	Values('Group 4',1);

	/*Execute*/
	execute dbo.Calculate_Entropy
	@Entropy_Dataset = @Entropy_Dataset 
	,@Entropy=@Actual_Entropy OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Entropy,@Actual=@Actual_Entropy
END
go

exec tSQLt.NewTestClass 'Test_Calculate_Information_Gain';
go
CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__Object__Exists__dbo_Calculate_Information_Gain 
as
BEGIN

	exec tSQLt.AssertObjectExists 
	@ObjectName = 'dbo.Calculate_Information_Gain'
END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__Object__Exists__dbo_Information_Gain_Dataset 
as
BEGIN

	if not exists (select 1 from sys.types where name = 'Information_Gain_Dataset')
		exec tSQLt.Fail @Message0='Table Type object dbo.Information_Gain_Dataset does not exist'

END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__Columns__dbo_Information_Gain_Dataset
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
		('Classification_Name','nvarchar',0,0,0,1000)
		,('Member_Name','nvarchar',0,0,0,1000)
		,('Member_Count','decimal',0,9,0,5)
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
	tt.name='Information_Gain_Dataset'
	and
	tt.schema_id=schema_id('dbo')


	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'

END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__Interface__Input__dbo_Calculate_Information_Gain
as
BEGIN

	/*Set Up*/
	Create table #Expected (
	column_name sysname
	,data_type_name  sysname
	,is_nullable bit
	,precision int
	,scale int
	,max_length int
	);

	Create table #Actual (
	column_name sysname
	,data_type_name  sysname
	,is_nullable bit
	,precision int
	,scale int
	,max_length int
	);

	insert into #Expected
	select
	column_name
	,data_type_name
	,is_nullable
	,precision
	,scale
	,max_length
	from
	(values
		('@Information_Gain_Dataset','Information_Gain_Dataset',1,0,0,-1)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)


	/*Execute*/
	insert into #Actual
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Information_Gain'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =0


	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'

END
go




CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__Interface__Output__dbo_Calculate_Information_Gain 
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
		('@Information_Gain','decimal',1,9,8,5)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)

	/*Execute*/
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	into #Actual
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Information_Gain'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =1

	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'
END
go


exec tSQLt.NewTestClass 'Test_Calculate_Information_Gain_Parent_Entropy';
go
CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain_Parent_Entropy.Test__Object__Exists__dbo_Calculate_Information_Gain_Parent_Entropy 
as
BEGIN

	exec tSQLt.AssertObjectExists 
	@ObjectName = 'dbo.Calculate_Information_Gain_Parent_Entropy'
END
go


CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain_Parent_Entropy.Test__Interface__Input__dbo_Calculate_Information_Gain_Parent_Entropy
as
BEGIN

	/*Set Up*/
	Create table #Expected (
	column_name sysname
	,data_type_name  sysname
	,is_nullable bit
	,precision int
	,scale int
	,max_length int
	);

	Create table #Actual (
	column_name sysname
	,data_type_name  sysname
	,is_nullable bit
	,precision int
	,scale int
	,max_length int
	);

	insert into #Expected
	select
	column_name
	,data_type_name
	,is_nullable
	,precision
	,scale
	,max_length
	from
	(values
		('@Information_Gain_Dataset','Information_Gain_Dataset',1,0,0,-1)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)


	/*Execute*/
	insert into #Actual
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Information_Gain_Parent_Entropy'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =0


	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'

END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain_Parent_Entropy.Test__Interface__Output__dbo_Calculate_Information_Gain_Parent_Entropy 
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
		('@Parent_Entropy','decimal',1,9,8,5)
	) as Expected(column_name,data_type_name,is_nullable,precision,scale,max_length)

	/*Execute*/
	select
	par.name as[column_name]
	,t.name as [data_type_name]
	,par.is_nullable
	,par.precision
	,par.scale
	,par.max_length
	into #Actual
	from
	sys.procedures p
	inner join
	sys.parameters par
	on
	par.object_id=p.object_id
	inner join
	sys.types t
	on
	par.user_type_id=t.user_type_id
	where
	p.name='Calculate_Information_Gain_Parent_Entropy'
	and
	p.schema_id=schema_id('dbo')
	and
	par.is_output =1

	/*Test*/
	execute tSQLt.AssertEqualsTable @Expected='#Expected',@Actual='#Actual'
END
go



CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain_Parent_Entropy.Test__dbo_Calculate_Information_Gain_Parent_Entropy__2__Class__Input 
as
BEGIN

	/*Set Up*/
	declare @Information_Gain_Dataset Information_Gain_Dataset;
	declare @Actual_Parent_Entropy decimal(9,8);
	declare @Expected_Parent_Entropy decimal(9,8)=.99679163;

	insert into @Information_Gain_Dataset
	Values('LessThan50K','Group 1',12);
	insert into @Information_Gain_Dataset
	Values('LessThan50K','Group 2',1);
	insert into @Information_Gain_Dataset
	Values('MoreThan50K','Group 1',4);
	insert into @Information_Gain_Dataset
	Values('MoreThan50K','Group 2',13);


	/*Execute*/
	execute dbo.Calculate_Information_Gain_Parent_Entropy
	@Information_Gain_Dataset = @Information_Gain_Dataset 
	,@Parent_Entropy=@Actual_Parent_Entropy OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Parent_Entropy,@Actual=@Actual_Parent_Entropy
END
go

CREATE OR ALTER PROCEDURE Test_Calculate_Information_Gain.Test__dbo_Calculate_Information_Gain__2__Class__Input 
as
BEGIN

	/*Set Up*/
	declare @Information_Gain_Dataset Information_Gain_Dataset;
	declare @Actual_Information_Gain decimal(9,8);
	declare @Expected_Information_Gain decimal(9,8)=.13;

	insert into @Information_Gain_Dataset
	Values('LessThan50K','Group 1',12);
	insert into @Information_Gain_Dataset
	Values('LessThan50K','Group 2',1);
	insert into @Information_Gain_Dataset
	Values('MoreThan50K','Group 1',4);
	insert into @Information_Gain_Dataset
	Values('MoreThan50K','Group 2',13);


	/*Execute*/
	execute dbo.Calculate_Information_Gain
	@Information_Gain_Dataset = @Information_Gain_Dataset 
	,@Information_Gain=@Actual_Information_Gain OUTPUT;

	/*Test*/
	execute tSQLt.AssertEquals @Expected=@Expected_Information_Gain,@Actual=@Actual_Information_Gain
END
go
exec tSQLt.RunAll;

