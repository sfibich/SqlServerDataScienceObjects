CREATE OR ALTER PROCEDURE dbo.Calculate_Information_Gain
@Information_Gain_Dataset Information_Gain_Dataset READONLY
,@Information_Gain decimal(9,8) OUTPUT
as
BEGIN
	SET NOCOUNT ON;

	declare @Parent_Entropy decimal(9,8);
	declare @Entropy_Dataset Entropy_Dataset;
	declare @Entropy decimal(9,8);
	declare @Working_Entropy decimal(9,8)=0;
	declare @Total_Member_Count decimal(19,0);
	declare @Subset_Member_Count decimal(19,0);
	declare @Classification_Name varchar(500);

	select
	@Total_Member_Count=sum(Member_Count)
	from
	@Information_Gain_Dataset;

	execute dbo.Calculate_Information_Gain_Parent_Entropy
	@Information_Gain_Dataset = @Information_Gain_Dataset
	,@Parent_Entropy = @Parent_Entropy OUTPUT;

	declare looper cursor for
	select
	igd.Classification_Name
	from
	@Information_Gain_Dataset igd
	group by
	igd.Classification_Name;

	open looper;
	fetch next from looper into @Classification_Name

	while @@fetch_status=0
	BEGIN 
		delete @Entropy_Dataset;
		insert into @Entropy_Dataset
		(Member_Name
		,Member_Count
		)
		select
		igd.Member_Name
		,igd.Member_Count
		from
		@Information_Gain_Dataset igd
		where
		igd.Classification_Name=@Classification_Name;

		execute dbo.Calculate_Entropy
		@Entropy_Dataset=@Entropy_Dataset
		,@Entropy=@Entropy OUTPUT

		select
		@Subset_Member_Count=sum(Member_Count)
		from
		@Entropy_Dataset;

		set @Working_Entropy+=(@Subset_Member_Count/@Total_Member_Count)*@Entropy;

		fetch next from looper into @Classification_Name;

	END

	close looper;
	deallocate looper;

	set @Information_Gain=@Parent_Entropy+-1*@Working_Entropy;

END



--declare @Information_Gain_Dataset Information_Gain_Dataset;
--declare @Actual_Information_Gain decimal(9,8);
--declare @Expected_Information_Gain decimal(9,8)=.13;

--insert into @Information_Gain_Dataset
--Values('LessThan50K','Group 1',12);
--insert into @Information_Gain_Dataset
--Values('LessThan50K','Group 2',1);
--insert into @Information_Gain_Dataset
--Values('MoreThan50K','Group 1',4);
--insert into @Information_Gain_Dataset
--Values('MoreThan50K','Group 2',13);

--select
--ed.Classification_Name
--,ed.Member_Name
--,ed.Member_Count
--,sum(ed.Member_Count) over(partition by ed.Classification_Name) as Total_Member_Count
--,ed.Member_Count/sum(ed.Member_Count) over(partition by ed.Classification_Name) [Relative_Percentage]
--,log(ed.Member_Count/sum(ed.Member_Count) over(partition by ed.Classification_Name),2) as [Binary_Log_of_Relative_Percentage]
--,ed.Member_Count/sum(ed.Member_Count) over(partition by ed.Classification_Name)*log(ed.Member_Count/sum(ed.Member_Count) over(partition by ed.Classification_Name),2) as Partial_Entropy_Calculation
--from
--@Information_Gain_Dataset ed
