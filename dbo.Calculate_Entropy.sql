if exists (select 1 from sys.procedures where name = 'Calculate_Entropy' and schema_id=schema_id('dbo'))
	drop procedure dbo.Calculate_Entropy;

if exists (select 1 from sys.types where name = 'Entropy_Dataset' and schema_id=schema_id('dbo'))
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
	SET NOCOUNT ON;

	declare @Internal_Entropy_Dataset Entropy_Dataset;
	insert into 
	@Internal_Entropy_Dataset
	select
	ed.Member_Name
	,sum(ed.Member_Count)
	from
	@Entropy_Dataset ed
	group by
	ed.Member_Name;

	select
	@Entropy=-1*sum(ed.partial_entropy_calculation)
	from
	(
		select
		ed.Member_Name
		,ed.Member_Count
		,sum(ed.Member_Count) over() as Total_Member_Count
		,ed.Member_Count/sum(ed.Member_Count) over() [Relative_Percentage]
		,log(ed.Member_Count/sum(ed.Member_Count) over(),2) as [Binary_Log_of_Relative_Percentage]
		,ed.Member_Count/sum(ed.Member_Count) over()*log(ed.Member_Count/sum(ed.Member_Count) over(),2) as Partial_Entropy_Calculation
		from
		@Internal_Entropy_Dataset ed
	) as ed

END

go


