

if exists (select 1 from sys.types where name = 'Entropy_Dataset')
	drop type dbo.Entropy_Dataset;
go
CREATE type dbo.Entropy_Dataset AS TABLE(
Member_Name nvarchar(500) not null
,Member_Count bigint not null
)