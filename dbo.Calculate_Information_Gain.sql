if exists (select 1 from sys.procedures where name = 'Calculate_Information_Gain' and schema_id=schema_id('dbo'))
	drop procedure dbo.Calculate_Information_Gain;

if exists (select 1 from sys.types where name = 'Information_Gain_Dataset' and schema_id=schema_id('dbo'))
	drop type dbo.Information_Gain_Dataset;
go
CREATE type dbo.Information_Gain_Dataset AS TABLE(
Classification_Name nvarchar(500) not null
,Member_Name nvarchar(500) not null
,Member_Count decimal(9,0) not null
);
go
CREATE OR ALTER PROCEDURE dbo.Calculate_Information_Gain
@Information_Gain_Dataset Information_Gain_Dataset READONLY
as
BEGIN
	print 'Stub!';
END