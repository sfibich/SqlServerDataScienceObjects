CREATE OR ALTER PROCEDURE dbo.Calculate_Information_Gain
@Information_Gain_Dataset Information_Gain_Dataset READONLY
,@Information_Gain decimal(9,8) OUTPUT
as
BEGIN
	
	declare @Parent_Entropy decimal(9,8);

	execute dbo.Calculate_Information_Gain_Parent_Entropy
	@Information_Gain_Dataset = @Information_Gain_Dataset
	,@Parent_Entropy = @Parent_Entropy OUTPUT;

END