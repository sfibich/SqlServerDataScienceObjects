CREATE OR ALTER PROCEDURE dbo.Calculate_Information_Gain_Parent_Entropy
@Information_Gain_Dataset Information_Gain_Dataset READONLY
,@Parent_Entropy decimal(9,8) OUTPUT
AS
BEGIN
	declare @Entropy_Dataset Entropy_Dataset;

	/*Get Parent Entropy*/
	insert into @Entropy_Dataset
	(Member_Name,Member_Count)
	select
	Member_Name
	,Sum(Member_Count) as [Member_Count]
	from
	@Information_Gain_Dataset
	group by
	Member_Name;

	execute dbo.Calculate_Entropy
	@Entropy_Dataset = @Entropy_Dataset 
	,@Entropy=@Parent_Entropy OUTPUT;
END