if exists (select 1 from sys.procedures where name = 'Calculate_Entropy')
	drop procedure dbo.Calculate_Entropy;

if exists (select 1 from sys.types where name = 'Entropy_Dataset')
	drop type dbo.Entropy_Dataset;
go
CREATE type dbo.Entropy_Dataset AS TABLE(
Member_Name nvarchar(500) not null
,Member_Count decimal(9,0) not null
);

go

CREATE OR ALTER PROCEDURE dbo.Calculate_Entropy 
@Entropy_Dataset Entropy_Dataset READONLY
,@Entropy decimal(9,8) OUTPUT
AS
BEGIN

	select
	ed.Member_Name
	,ed.Member_Count
	,sum(ed.Member_Count) over() as total_member_count
	,ed.Member_Count/sum(ed.Member_Count) over()
	,log(ed.Member_Count/sum(ed.Member_Count) over()) as [log]
--	,sum(ed.Member_Count) over()/ed.Member_Count * log(sum(ed.Member_Count) over()/ed.Member_Count) as part_entropy
	from
	@Entropy_Dataset ed

END

go


