if exists (select 1 from sys.types where name = 'Information_Gain_Dataset' and schema_id=schema_id('dbo'))
	drop type dbo.Information_Gain_Dataset;
go
CREATE type dbo.Information_Gain_Dataset AS TABLE(
Classification_Name nvarchar(500) not null
,Member_Name nvarchar(500) not null
,Member_Count decimal(9,0) not null
);